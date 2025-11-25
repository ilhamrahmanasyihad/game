# tebak_angka_fixed.ps1
# Game Tebak Angka Sederhana PowerShell - FIXED

function Start-TebakAngkaGame {
    [CmdletBinding()]
    param(
        [int]$MinNumber = 1,
        [int]$MaxNumber = 100,
        [int]$MaxAttempts = 7
    )
    
    # Generate angka rahasia
    $angkaRahasia = Get-Random -Minimum $MinNumber -Maximum ($MaxNumber + 1)
    $score = 100
    $attempt = 0
    $isWinner = $false
    
    # Header game
    Clear-Host
    Write-Host "🎮 === GAME TEBAK ANGKA === 🎮" -ForegroundColor Cyan
    Write-Host "Saya telah memilih angka antara $MinNumber-$MaxNumber" -ForegroundColor Yellow
    Write-Host "Anda memiliki $MaxAttempts kesempatan" -ForegroundColor Yellow
    Write-Host ("-" * 50) -ForegroundColor Gray
    
    # Game loop
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        Write-Host "`n📝 Percobaan ke-$attempt dari $MaxAttempts" -ForegroundColor Magenta
        Write-Host "🎯 Score saat ini: $score" -ForegroundColor Green
        
        # Input validation
        do {
            $inputValid = $true
            $inputTebakan = Read-Host "Masukkan tebakan Anda ($MinNumber-$MaxNumber)"
            
            # Validasi input kosong
            if ([string]::IsNullOrWhiteSpace($inputTebakan)) {
                Write-Host "❌ Input tidak boleh kosong!" -ForegroundColor Red
                $inputValid = $false
                continue
            }
            
            # Validasi numeric
            if (-not ($inputTebakan -match '^\d+$')) {
                Write-Host "❌ Harap masukkan angka yang valid!" -ForegroundColor Red
                $inputValid = $false
                continue
            }
            
            $tebakan = [int]$inputTebakan
            
            # Validasi range
            if ($tebakan -lt $MinNumber -or $tebakan -gt $MaxNumber) {
                Write-Host "❌ Angka harus antara $MinNumber-$MaxNumber!" -ForegroundColor Red
                $inputValid = $false
            }
        } while (-not $inputValid)
        
        # Check tebakan
        if ($tebakan -eq $angkaRahasia) {
            Write-Host "`n🎉 SELAMAT! Anda menebak dengan benar!" -ForegroundColor Green
            Write-Host "🏆 Angka yang benar: $angkaRahasia" -ForegroundColor Cyan
            Write-Host "⭐ Score akhir: $score" -ForegroundColor Yellow
            $isWinner = $true
            break
        }
        elseif ($tebakan -lt $angkaRahasia) {
            Write-Host "📈 Terlalu KECIL! Coba angka yang lebih besar." -ForegroundColor Blue
        }
        else {
            Write-Host "📉 Terlalu BESAR! Coba angka yang lebih kecil." -ForegroundColor Red
        }
        
        # Kurangi score
        $score = [math]::Max(0, $score - 15)
        $sisaKesempatan = $MaxAttempts - $attempt
        
        if ($sisaKesempatan -gt 0) {
            Write-Host "⏳ Sisa kesempatan: $sisaKesempatan" -ForegroundColor Gray
            Write-Host ("─" * 30) -ForegroundColor DarkGray
        }
    }
    
    # Game over message
    if (-not $isWinner) {
        Write-Host "`n💀 GAME OVER!" -ForegroundColor Red
        Write-Host "🔍 Angka yang benar adalah: $angkaRahasia" -ForegroundColor Cyan
        Write-Host "😞 Coba lagi ya!" -ForegroundColor Gray
    }
    
    # Tanya mau main lagi
    Write-Host "`n" + ("=" * 50) -ForegroundColor Cyan
    $mainLagi = Read-Host "Mau main lagi? (y/n)"
    
    if ($mainLagi -eq 'y' -or $mainLagi -eq 'Y') {
        Start-TebakAngkaGame
    }
    else {
        Write-Host "`n👋 Terima kasih telah bermain!" -ForegroundColor Cyan
    }
}

# Jalankan game
Write-Host "Memuat Game Tebak Angka..." -ForegroundColor Green
Start-Sleep -Seconds 2
Start-TebakAngkaGame
