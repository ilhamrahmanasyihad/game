import random
import getpass

class TebakAngkaGame:
    def __init__(self):
        self.angka_rahasia = random.randint(1, 100)
        self.kesempatan = 7
        self.score = 100
    
    def play(self):
        print("🎮 === GAME TEBAK ANGKA === 🎮")
        print("Saya telah memilih angka antara 1-100")
        print(f"Anda memiliki {self.kesempatan} kesempatan")
        print("-" * 30)
        
        for percobaan in range(self.kesempatan):
            try:
                tebakan = int(input("Masukkan tebakan Anda: "))
                
                if tebakan < self.angka_rahasia:
                    print("📈 Terlalu kecil! Coba lagi.")
                elif tebakan > self.angka_rahasia:
                    print("📉 Terlalu besar! Coba lagi.")
                else:
                    print(f"🎉 SELAMAT! Anda menebak dengan benar!")
                    print(f"🏆 Score akhir: {self.score - (percobaan * 10)}")
                    return
                
                # Kurangi score setiap tebakan salah
                self.score -= 10
                print(f"Kesempatan tersisa: {self.kesempatan - percobaan - 1}")
                
            except ValueError:
                print("❌ Harap masukkan angka yang valid!")
        
        print(f"💀 Game Over! Angka yang benar adalah: {self.angka_rahasia}")

# Jalankan game
if __name__ == "__main__":
    game = TebakAngkaGame()
    game.play()
