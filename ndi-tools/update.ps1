Import-Module chocolatey-au

$ErrorActionPreference = 'Stop'

$versionUrl = 'https://downloads.ndi.tv/Tools/ndi_tools_win_current_version.json'
$installerUrl = 'https://downloads.ndi.tv/Tools/NDI%206%20Tools.exe'

function global:au_SearchReplace {
  @{
    '.\tools\chocolateyInstall.ps1' = @{
      "(?i)(^[$]url\s*=\s*)'.*'" = "`${1}'$($Latest.URL32)'"
      "(?i)(^[$]checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
    }
  }
}

function Get-NormalizedVersion {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Version
  )

  $trimmedVersion = $Version.Trim()

  try {
    $parsedVersion = [version]$trimmedVersion
  } catch {
    return $trimmedVersion
  }

  if ($parsedVersion.Revision -eq 0) {
    return $parsedVersion.ToString(3)
  }

  return $parsedVersion.ToString()
}

function global:au_GetLatest {
  Write-Host '[ndi-tools] Fetching upstream version metadata.'
  $json = Invoke-RestMethod -Uri $versionUrl
  $normalized = Get-NormalizedVersion -Version $json.version
  Write-Host "[ndi-tools] Upstream version: $normalized."

  [xml]$nuspec = Get-Content (Join-Path $PSScriptRoot 'ndi-tools.nuspec') -Raw
  $nuspecVersion = $nuspec.package.metadata.version
  Write-Host "[ndi-tools] Comparing with package version $nuspecVersion."
  if (-not $global:au_Force -and [version]$nuspec.package.metadata.version -eq [version]$normalized) {
    Write-Host '[ndi-tools] Versions match; skipping installer download and checksum.'
    return @{ Version = $normalized }
  }

  $installerPath = Join-Path $env:TEMP 'NDI-Tools-Setup.exe'

  Write-Host '[ndi-tools] Downloading installer for checksum calculation.'
  $currentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'
  try {
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    Write-Host '[ndi-tools] Installer downloaded; calculating SHA256 checksum.'
    $checksum = (Get-FileHash $installerPath -Algorithm SHA256).Hash
    Write-Host '[ndi-tools] SHA256 checksum calculated.'
  }
  finally {
    $ProgressPreference = $currentProgressPreference
    Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
    Write-Host '[ndi-tools] Temporary installer cleanup complete.'
  }

  Write-Host '[ndi-tools] Returning version and checksum to chocolatey-au.'
  @{
    Version      = $normalized
    URL32        = $installerUrl
    Checksum32   = $checksum
    ReleaseNotes = 'https://docs.ndi.video/all/using-ndi/ndi-tools/release-notes'
  }
}

update -ChecksumFor none