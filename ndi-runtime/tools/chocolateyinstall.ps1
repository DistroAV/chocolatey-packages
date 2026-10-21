$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'NDI 6 Runtime'
  fileType       = 'exe'
  silentArgs     = "/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES"
  
  validExitCodes = @(0)
  url            = "http://ndi.link/NDIRedistV6"
  checksum       = '7EE73EEDB56402BCA5100868353DBAB4E944B6C37D2D9881580698A3B61346CD'
  checksumType   = 'sha256'
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs

Write-Warning "You must reboot your computer to make a new or updated NDI Runtime installation effective"
