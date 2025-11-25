# camera_launcher.ps1
# Membuka aplikasi kamera Windows

function Show-CameraMenu {
    Clear-Host
    Write-Host "=== KAMERA LAUNCHER ===" -ForegroundColor Cyan
    Write-Host "1. Buka Kamera Windows" -ForegroundColor Yellow
    Write-Host "2. Cek Ketersediaan Kamera" -ForegroundColor Yellow
    Write-Host "3. Test Perangkat Kamera" -ForegroundColor Yellow
    Write-Host "4. Keluar" -ForegroundColor Red
    Write-Host ""
}

function Test-CameraAvailability {
    Write-Host "`n🔍 MENDETEKSI KAMERA..." -ForegroundColor Cyan
    
    # Method 1: Cek melalui PnP devices
    $cameras = Get-PnpDevice -Class Camera -Status OK
    if ($cameras) {
        Write-Host "✅ Kamera terdeteksi:" -ForegroundColor Green
        foreach ($camera in $cameras) {
            Write-Host "   📷 $($camera.FriendlyName)" -ForegroundColor White
        }
    } else {
        Write-Host "❌ Tidak ada kamera yang terdeteksi" -ForegroundColor Red
    }
    
    # Method 2: Cek melalui Device Manager
    Write-Host "`n📋 Informasi Device Manager:" -ForegroundColor Cyan
    try {
        $devices = Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.Name -like "*camera*" -or $_.Name -like "*webcam*" }
        if ($devices) {
            foreach ($device in $devices) {
                Write-Host "   💻 $($device.Name)" -ForegroundColor Gray
                Write-Host "     Status: $($device.Status)" -ForegroundColor $(if($device.Status -eq "OK"){"Green"}else{"Red"})
            }
        } else {
            Write-Host "   ℹ️ Tidak ada perangkat kamera di Device Manager" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "   ❌ Tidak dapat mengakses Device Manager" -ForegroundColor Red
    }
}

function Open-WindowsCamera {
    Write-Host "`n📷 MEMBUKA APLIKASI KAMERA..." -ForegroundColor Cyan
    
    try {
        # Method 1: Gunakan start microsoft.windows.camera:
        Write-Host "🚀 Membuka Windows Camera App..." -ForegroundColor Yellow
        
        $process = Start-Process "microsoft.windows.camera:" -PassThru -ErrorAction Stop
        Write-Host "✅ Aplikasi kamera berhasil dibuka!" -ForegroundColor Green
        Write-Host "⏱️ Process ID: $($process.Id)" -ForegroundColor Gray
        
        # Tunggu sebentar untuk memastikan aplikasi terbuka
        Start-Sleep -Seconds 2
    }
    catch {
        Write-Host "❌ Gagal membuka aplikasi kamera built-in" -ForegroundColor Red
        Write-Host "💡 Mencoba metode alternatif..." -ForegroundColor Yellow
        
        # Method 2: Coba buka melalui shell
        try {
            Start-Process "shell:AppsFolder\Microsoft.WindowsCamera_8wekyb3d8bbwe!App"
            Write-Host "✅ Berhasil membuka kamera via shell" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Gagal membuka kamera dengan semua metode" -ForegroundColor Red
            Write-Host "💡 Pastikan Windows Camera App terinstall di sistem Anda" -ForegroundColor Yellow
        }
    }
}

function Test-CameraDevices {
    Write-Host "`n🎯 TEST PERANGKAT KAMERA..." -ForegroundColor Cyan
    
    # Cek driver kamera
    $cameraDrivers = Get-WindowsDriver -Online | Where-Object { $_.Driver -like "*camera*" -or $_.Class -like "*image*" }
    
    if ($cameraDrivers) {
        Write-Host "✅ Driver kamera ditemukan:" -ForegroundColor Green
        foreach ($driver in $cameraDrivers) {
            Write-Host "   🚀 $($driver.Driver)" -ForegroundColor White
            Write-Host "     Class: $($driver.Class)" -ForegroundColor Gray
        }
    } else {
        Write-Host "ℹ️ Tidak ada driver kamera khusus yang ditemukan" -ForegroundColor Yellow
    }
    
    # Cek melalui WMI
    Write-Host "`n🔧 Informasi WMI:" -ForegroundColor Cyan
    try {
        $imagingDevices = Get-CimInstance -ClassName Win32_SerialPort | Where-Object { $_.Description -like "*camera*" }
        if ($imagingDevices) {
            foreach ($device in $imagingDevices) {
                Write-Host "   📸 $($device.Description)" -ForegroundColor White
            }
        }
    }
    catch {
        Write-Host "   ℹ️ Tidak dapat mengakses informasi WMI kamera" -ForegroundColor Gray
    }
}

# Main execution
do {
    Show-CameraMenu
    $choice = Read-Host "Pilih menu (1-4)"
    
    switch ($choice) {
        '1' { 
            Open-WindowsCamera
        }
        '2' { 
            Test-CameraAvailability
        }
        '3' { 
            Test-CameraDevices
        }
        '4' { 
            Write-Host "`n👋 Terima kasih!" -ForegroundColor Cyan
            break
        }
        default {
            Write-Host "❌ Pilihan tidak valid!" -ForegroundColor Red
        }
    }
    
    if ($choice -ne '4') {
        Write-Host "`nTekan Enter untuk kembali ke menu..." -ForegroundColor Gray
        $null = Read-Host
    }
} while ($choice -ne '4')
