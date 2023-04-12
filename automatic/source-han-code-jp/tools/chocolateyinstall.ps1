﻿$ErrorActionPreference = 'Stop'

# The code structure for this from https://chocolatey.org/packages/hackfont
 
# create temp directory
do {
    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
} while (Test-Path $tempPath)
New-Item -ItemType Directory -Path $tempPath | Out-Null
 
$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $tempPath    

    url            = 'https://github.com/adobe-fonts/source-han-code-jp/archive/2.012R.zip'
    checksum       = 'BEDC74973220F1CE4BB16E1FA64A46604C3164BF95B62FA48C8A046DD468D6EF'
    checksumType   = 'sha256'
}
 
Install-ChocolateyZipPackage @packageArgs
 
# Loop the extracted files and install them
Get-ChildItem -Path $tempPath\source-han-code-jp-$($env:ChocolateyPackageVersion)R\OTF -Recurse -Filter '*.otf' | ForEach-Object { 
    Write-Verbose "Registering font '$($_.Name)'."
    Add-Font $_.FullName
}
 
# Remove our temporary files
Remove-Item $tempPath -Recurse -ErrorAction SilentlyContinue
 
Write-Warning 'If the fonts are not available in your applications or receive any errors installing or upgrading, please reboot to release the font files.'
