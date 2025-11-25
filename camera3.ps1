# camera_winrm.ps1
# Dioptimalkan untuk WinRM execution

function Show-CameraInfo {
    $cameras = Get-PnpDevice -Class Camera
    
    Write-Host "=== WEBCAM STATUS ===" -ForegroundColor Cyan
    
    if (-not $cameras) {
        Write-Host "❌ NO CAMERAS DETECTED" -ForegroundColor Red
        return
    }
    
    # Tampilkan dalam format yang mudah dibaca
    foreach ($camera in $cameras) {
        $statusIcon = if ($camera.Status -eq 'OK') { "✅" } else { "❌" }
        Write-Host "$statusIcon $($camera.FriendlyName)" -ForegroundColor $(if($camera.Status -eq 'OK'){"Green"}else{"Red"})
        Write-Host "   Status: $($camera.Status)" -ForegroundColor Gray
        Write-Host "   Class: $($camera.Class)" -ForegroundColor Gray
        Write-Host ""
    }
    
    # Hitung statistik
    $workingCameras = ($cameras | Where-Object { $_.Status -eq 'OK' }).Count
    Write-Host "📊 Summary: $workingCameras/$($cameras.Count) cameras working" -ForegroundColor Yellow
    
    # Auto-attempt to open camera app if cameras are detected
    if ($workingCameras -gt 0) {
        Write-Host "`n🎯 Attempting to launch camera application..." -ForegroundColor Magenta
        try {
            $process = Start-Process "microsoft.windows.camera:" -PassThru -ErrorAction Stop
            Write-Host "✅ Camera app launched successfully (PID: $($process.Id))" -ForegroundColor Green
        }
        catch {
            Write-Host "⚠️ Could not auto-launch camera app" -ForegroundColor Yellow
            Write-Host "💡 Manual launch: Open Start Menu and search 'Camera'" -ForegroundColor Gray
        }
    }
}

# Jalankan fungsi utama
Show-CameraInfo
