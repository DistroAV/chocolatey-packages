# Chocolatey package for DistroAV

This repository contains the Chocolatey packages for DistroAV. It uses [chocolatey automatic packages](https://chocolatey.org/docs/automatic-packages) via the `update.ps1` script in the folder that is run daily to automatically detect and publish new versions.

This repo is dedicated to DistroAV and possibly it's core dependencies.

## Contributions & history

All the groundwork has been done by @flcdrg and based from his [au-packages repo](https://github.com/flcdrg/au-packages). 

This is *totally* based on the great work by [@flcdrg](https://github.com/flcdrg) from his [au-packages repo](https://github.com/flcdrg/au-packages).

As October 2026, packages for DistroAV have been moved to the DistroAV organisation to streamline control and ultimately make the chocolatey packages offcial.

While this is all automated, contributions are welcome. For anything outside of the DistroAV packages themselves we suggest contributions to be directed towards the original [au-packages repo](https://github.com/flcdrg/au-packages).


## Prerequisites

To run locally you will need:

- Powershell 7+.
- [Custom fork of Chocolatey AU](https://github.com/flcdrg/chocolatey-au/tree/simplify) (has some extra features that hopefully will be merged into Chocolatey AU eventually)
- [au-dotnet](https://github.com/flcdrg/au-dotnet/), a custom orchestrator used instead of the AU module's `update_all.ps1` script (to work around issues with PowerShell 7+).

## Automatic package update

### Single package

Run from within the directory of the package to update that package:

```powershell
    cd <package_dir>
    ./update.ps1
```

If this script is missing, the package update is not automatic.  
Set `$au_Force = $true` prior to script call to update the package even if no new version is found.
