#!/bin/bash

# Scriptin çalıştırılabilme izni kontrolü
if ! [ -x "$(command -v sudo)" ]; then
  echo "Bu script çalıştırılabilme iznine sahip değil. Lütfen 'sudo chmod +x kurulum.sh' komutunu çalıştırın."
  exit 1
fi

# Gerekli paketlerin kontrolü ve kurulumu
echo "Gerekli paketler kontrol ediliyor..."
for paket in git meson ninja-build pkg-config gcc g++ systemd python3-pip; do
  if ! [ -x "$(command -v $paket)" ]; then
    echo "$paket paketi bulunamadı. Kuruluyor..."
    sudo apt install -y $paket
  fi
done

# Mavlink-router kütüphanesinin klonlanması
echo "Mavlink-router kütüphanesi klonlanıyor..."
git clone https://github.com/mavlink-router/mavlink-router.git

# Kütüphanenin alt modüllerinin güncellenmesi
echo "Kütüphanenin alt modülleri güncelleniyor..."
cd mavlink-router
git submodule update --init --recursive

# Kütüphanenin derlenmesi ve kurulumu
echo "Kütüphane derleniyor ve kuruluyor..."
sudo pip3 install meson

ninja -C build
sudo ninja -C build install

# Dialout grubuna kullanıcı ekleme
echo "Kullanıcı 'dialout' grubuna ekleniyor..."
sudo usermod -a -G dialout $USER

# Kullanıcıdan yönlendirmeyi etkinleştirmek isteyip istemediğini sor
echo "Kurulum sonrası programı her yeniden başlatmada belirlediğiniz yapılandırma bilgileriyle otomatik olarak çalıştırmak ister misiniz? (Y/N)"
read -r cevap

if [[ $cevap =~ ^[Yy]$ ]]; then

  # Gerekli dizinleri ve dosyaları oluştur
  sudo mkdir /etc/mavlink-router
  cd /etc/mavlink-router
  sudo touch main.conf

  # Yapılandırma dosyasına gerekli bilgileri ekle
  echo "[General]" >> main.conf
  echo "TcpServerPort=5760" >> main.conf
  echo "ReportStats=false" >> main.conf
  echo "MavlinkDialect=common" >> main.conf
  echo "" >> main.conf

  echo "[UartEndpoint alpha]" >> main.conf
  echo "Device=/dev/ttyACM0" >> main.conf
  echo "Baud=115200" >> main.conf
  echo "" >> main.conf

  echo "[UdpEndpoint bravo]" >> main.conf
  echo "Mode = Server" >> main.conf
  echo "Address = 0.0.0.0" >> main.conf
  echo "Port = 14550" >> main.conf

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
