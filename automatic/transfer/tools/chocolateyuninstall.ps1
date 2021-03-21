﻿$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Frame.io Transfer'
  fileType      = 'exe'
  silentArgs    = '--uninstall -s'
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {    
    $packageArgs['file'] = "$($_.QuietUninstallString)" -Replace '(".*").*', '$1'
    Uninstall-ChocolateyPackage @packageArgs
    write-host "1111"
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
  write-host "2222"
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
  write-host "3333"
}