# quick_camera.ps1
# Cek kamera dengan satu perintah

Write-Host "Quick Camera Check..." -ForegroundColor Yellow
Get-PnpDevice -Class Camera | Format-Table FriendlyName, Status, Class -AutoSize

# Coba buka kamera
$answer = Read-Host "Buka Camera App? (y/n)"
if ($answer -eq 'y') { Start-Process "microsoft.windows.camera:" }
