$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'NDI 6 Runtime'
  fileType       = 'exe'
  silentArgs     = "/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES"
  
  validExitCodes = @(0)
  url            = "http://ndi.link/NDIRedistV6"
  checksum       = '7ee73eedb56402bca5100868353dbab4e944b6c37d2d9881580698a3b61346cd'
  checksumType   = 'sha256'
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs

Write-Warning "You must reboot your computer to make a new or updated NDI Runtime installation effective"
