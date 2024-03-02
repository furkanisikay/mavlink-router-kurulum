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

# Kurulum tamamlandı mesajı
echo "Mavlink-router kurulumu tamamlandı!"
echo "Kurulumu test etmek için aşağıdaki komutu çalıştırabilirsiniz:"
echo "mavlink-routerd -e 192.168.7.1:14550 -e 127.0.0.1:14550 /dev/ttyS1:1500000"
