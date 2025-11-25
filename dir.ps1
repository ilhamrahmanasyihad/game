# simple_dir.ps1
# Menampilkan isi direktori saat ini

Write-Host "=== ISI DIREKTORI SAAT INI ===" -ForegroundColor Cyan
Get-Location
Write-Host ""

Get-ChildItem | Format-Table Name, Length, LastWriteTime -AutoSize
