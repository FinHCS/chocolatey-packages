# Remove start menu shortcut
$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutFilePath = Join-Path $programs "CudaText.lnk"
if (Test-Path $shortcutFilePath) { Remove-Item $shortcutFilePath }