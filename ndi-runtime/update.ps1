Import-Module chocolatey-au

$ErrorActionPreference = 'Stop'

$versionUrl = 'https://downloads.ndi.tv/Tools/ndi_tools_win_current_version.json'
$installerUrl = 'https://downloads.ndi.tv/SDK/NDI_SDK/NDI%206%20Runtime.exe'

function global:au_SearchReplace {
  @{
    '.\tools\chocolateyInstall.ps1' = @{
      "(?i)(^\s*checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(<packageSourceUrl>).*?(</packageSourceUrl>)" = "`${1}https://github.com/DistroAV/chocolatey-packages/tree/$($Latest.PackageName)-$($Latest.Version)/$($Latest.PackageName)`${2}"
    }
  }
}

function global:au_GetLatest {
  $json = Invoke-RestMethod -Uri $versionUrl
  $version = [version]$json.version
  $normalized = if ($version.Revision -eq 0) { $version.ToString(3) } else { $version.ToString() }

  [xml]$nuspec = Get-Content (Join-Path $PSScriptRoot 'ndi-runtime.nuspec') -Raw
  if (-not $global:au_Force -and [version]$nuspec.package.metadata.version -eq [version]$normalized) {
    return @{ Version = $normalized }
  }

  # The installer URL is constant, so download it to compute the checksum
  $installerPath = Join-Path $env:TEMP 'NDI-Runtime-Setup.exe'
  $currentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'
  try {
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    $checksum = (Get-FileHash $installerPath -Algorithm SHA256).Hash
  }
  finally {
    $ProgressPreference = $currentProgressPreference
    Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
  }

  @{
    Version      = $normalized
    URL32        = $installerUrl
    Checksum32   = $checksum
    ReleaseNotes = 'https://docs.ndi.video/all/using-ndi/ndi-tools/release-notes'
  }
}

update -ChecksumFor none
