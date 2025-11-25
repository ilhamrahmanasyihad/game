# camera_winrm_fixed.ps1
# Multiple methods untuk buka kamera

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
    
    return $workingCameras
}

function Start-CameraApp {
    Write-Host "`n🎯 ATTEMPTING TO LAUNCH CAMERA..." -ForegroundColor Magenta
    
    $methods = @(
        @{Name = "Windows Camera URI"; Command = "microsoft.windows.camera:"},
        @{Name = "Camera Shell Command"; Command = "shell:AppsFolder\Microsoft.WindowsCamera_8wekyb3d8bbwe!App"},
        @{Name = "Start Menu Camera"; Command = "start microsoft.windows.camera:"},
        @{Name = "Using Explorer"; Command = "explorer shell:AppsFolder\Microsoft.WindowsCamera_8wekyb3d8bbwe!App"}
    )
    
    $success = $false
    
    foreach ($method in $methods) {
        Write-Host "`n🔄 Trying: $($method.Name)..." -ForegroundColor Yellow
        try {
            $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c start $($method.Command)" -PassThru -ErrorAction Stop
            Start-Sleep -Seconds 2
            
            if ($process -and -not $process.HasExited) {
                Write-Host "✅ SUCCESS: Camera app launched via $($method.Name)" -ForegroundColor Green
                $success = $true
                break
            }
        }
        catch {
            Write-Host "❌ Failed: $($method.Name)" -ForegroundColor Red
        }
    }
    
    if (-not $success) {
        Write-Host "`n⚠️ ALL AUTO-LAUNCH METHODS FAILED" -ForegroundColor Yellow
        Write-Host "💡 SOLUTIONS:" -ForegroundColor Cyan
        Write-Host "   1. Open manually: Press Win + R, type 'microsoft.windows.camera:'" -ForegroundColor Gray
        Write-Host "   2. Search in Start Menu: Type 'Camera'" -ForegroundColor Gray
        Write-Host "   3. Use physical camera button (if available)" -ForegroundColor Gray
        Write-Host "   4. Run this script directly on the target computer (not via WinRM)" -ForegroundColor Gray
    }
    
    return $success
}

# Main execution
$workingCams = Show-CameraInfo

if ($workingCams -gt 0) {
    Start-CameraApp
}

Write-Host "`n🔍 Camera detection completed successfully!" -ForegroundColor Cyan
