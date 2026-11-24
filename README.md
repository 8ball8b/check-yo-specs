# Windows Donanım Menüsü

Windows bilgisayarınızın temel donanım bilgilerini renkli ve kullanımı kolay bir PowerShell menüsünden görüntüleyin.

## Özellikler

- **İşlemci (CPU):** model, üretici, çekirdek ve mantıksal işlemci sayısı, azami saat hızı
- **Bellek (RAM):** toplam bellek ve tespit edilebilen modüllerin kapasite, hız ve üretici bilgileri
- **Ekran kartı (GPU):** model, grafik işlemcisi, sürücü sürümü ve Windows'un bildirdiği bellek değeri
- **Anakart:** üretici, model ve sürüm
- Bileşenleri ayrı ayrı veya tümünü tek seferde görüntüleme
- Mor menü, yeşil donanım çıktısı ve kırmızı hata mesajları

## Gereksinimler

- Windows 10 veya 11
- Windows PowerShell 5.1 (Windows ile birlikte gelir)
- Ek paket gerekmez; yönetici izni normalde gerekli değildir

## Hızlı Başlangıç

1. Depoyu GitHub'da **Code > Download ZIP** seçeneğiyle indirin ve arşivi açın. İsterseniz Git ile klonlayın:

   ```powershell
   git clone https://github.com/8ball8b/check-yo-specs.git
   ```

2. PowerShell'de `donanim_menu.ps1` dosyasının bulunduğu klasöre geçin. Git ile klonladıysanız `cd check-yo-specs` komutunu kullanabilirsiniz; ZIP indirdiyseniz çıkardığınız klasöre gidin. Ardından uygulamayı başlatın:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\donanim_menu.ps1"
   ```

`-ExecutionPolicy Bypass` yalnızca bu PowerShell işlemi için geçerlidir; bilgisayarınızdaki kalıcı çalıştırma ilkesi değişmez. Yalnızca güvendiğiniz kaynaklardan indirdiğiniz betikleri çalıştırın.

## Menü

| Tuş | Gösterilen bilgi |
| --- | --- |
| `1` | İşlemci (CPU) |
| `2` | Bellek (RAM) |
| `3` | Ekran kartı (GPU) |
| `4` | Anakart |
| `5` | Tüm bilgiler |
| `0` | Çıkış |

Bir sonuç görüntülendikten sonra Enter'a basarak menüye dönün.

## Bilinen Sınırlamalar

Donanım bilgileri Windows'un yerel CIM/WMI arayüzlerinden alınır. Bazı alanlar üreticiye veya sürücüye bağlı olarak boş ya da genel değerlerle raporlanabilir. Özellikle eski `AdapterRAM` alanı ekran kartının gerçek VRAM kapasitesini her zaman doğru göstermeyebilir. Ayrılmış GPU belleğini doğrulamak için **Görev Yöneticisi > Performans > GPU > Ayrılmış GPU belleği** bölümüne bakın.

## Lisans

Bu depoda henüz bir lisans dosyası bulunmuyor.
