#!/bin/bash
set -e

# Scriptin çalıştırılabilme izni kontrolü
if ! command -v sudo >/dev/null 2>&1; then
  echo "Bu script için 'sudo' gereklidir. Lütfen sudo kurup tekrar deneyin."
  exit 1
fi

# Gerekli paketlerin kontrolü ve kurulumu
echo "Gerekli paketler kontrol ediliyor..."
sudo apt update
sudo apt install -y git meson ninja-build pkg-config gcc g++ systemd python3-pip

# Mavlink-router kütüphanesinin klonlanması
echo "Mavlink-router kütüphanesi klonlanıyor..."
git clone https://github.com/mavlink-router/mavlink-router.git

# Kütüphanenin alt modüllerinin güncellenmesi
echo "Kütüphanenin alt modülleri güncelleniyor..."
cd mavlink-router || exit
git submodule update --init --recursive

# Kütüphanenin derlenmesi ve kurulumu
echo "Kütüphane derleniyor ve kuruluyor..."
meson setup build
ninja -C build
sudo ninja -C build install

# Dialout grubuna kullanıcı ekleme
echo "Kullanıcı 'dialout' grubuna ekleniyor..."
sudo usermod -a -G dialout "$USER"

# Kullanıcıdan yönlendirmeyi etkinleştirmek isteyip istemediğini sor
echo "Kurulum sonrası programı her yeniden başlatmada belirlediğiniz yapılandırma bilgileriyle otomatik olarak çalıştırmak ister misiniz? (Y/N)"
read -r cevap

if [[ $cevap =~ ^[Yy]$ ]]; then
  UART_DEVICE="${UART_DEVICE:-/dev/ttyACM0}"
  UART_BAUD="${UART_BAUD:-115200}"
  UDP_ADDRESS="${UDP_ADDRESS:-0.0.0.0}"
  UDP_PORT="${UDP_PORT:-14550}"

  # Gerekli dizinleri ve dosyaları oluştur
  sudo mkdir -p /etc/mavlink-router

  # Yapılandırma dosyasına gerekli bilgileri ekle
  sudo tee /etc/mavlink-router/main.conf >/dev/null <<EOF
[General]
TcpServerPort=5760
ReportStats=false
MavlinkDialect=common

[UartEndpoint alpha]
Device=${UART_DEVICE}
Baud=${UART_BAUD}

[UdpEndpoint bravo]
Mode = Server
Address = ${UDP_ADDRESS}
Port = ${UDP_PORT}
EOF

  # Sistem servisini oluştur ve etkinleştir
  sudo systemctl enable mavlink-router.service
  sudo systemctl start mavlink-router.service

  echo "Yönlendirme başarıyla otomatik hale getirildi!"

else

  echo "Yönlendirme otomatik hale getirilmedi."

fi

# Kurulum tamamlandı mesajı
echo "Mavlink-router kurulumu tamamlandı!"
echo "Kurulumu test etmek için aşağıdaki komutu çalıştırabilirsiniz:"
echo "mavlink-routerd -e 192.168.7.1:14550 -e 127.0.0.1:14550 /dev/ttyS1:1500000"
