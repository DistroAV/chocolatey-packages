$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Added clean-up to remove obs-ndi if it was installed
$oldPackageId = "obs-ndi"

# Check if the deprecated package is currently installed locally
$installedPackages = choco list --local-only

if ($installedPackages -match $oldPackageId) {
    Write-ChocolateyProvidingHint "Found deprecated package '$oldPackageId'. Uninstalling it before proceeding..."
    # Removes the Chocolatey tracking of obs-ndi without uninstalling as this can cause more problem than solve
    choco uninstall $oldPackageId -y -n --remove-dependencies --skip-autouninstaller
} else {
    Write-Verbose "No old deprecated '$oldPackageId' found. Proceeding with clean install."
}

# Proceed with the normal package installation

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url = 'https://github.com/DistroAV/DistroAV/releases/download/6.2.2/distroav-6.2.2-windows-x64-Installer.exe'
$checksum = '86087f8ac1f51886794e2a903e64e36341aca0a463a5278b88b2c760a06a6f7e'

# Now install DistroAV
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $url
  softwareName   = 'DistroAV*'
  checksum       = $checksum
  checksumType   = 'sha256'
  silentArgs     = '/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
