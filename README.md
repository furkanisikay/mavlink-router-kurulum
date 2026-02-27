# mavlink-router Kurulum Rehberi

[![Bash](https://img.shields.io/badge/Shell-Bash-121011?logo=gnubash)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Platform-Linux-FCC624?logo=linux&logoColor=black)](https://kernel.org/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%2B-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Lisans: MIT](https://img.shields.io/badge/Lisans-MIT-green.svg)](./LICENSE)

## Neden Bu Proje?

Bu proje, MAVLink Router kurulumunu manuel adımlardan çıkarıp tek bir script ile tekrarlanabilir hale getirir.
Kurulum daha hızlı ve hataya daha dayanıklı olur.
Özellikle drone/otonom sistem geliştirme süreçlerinde farklı cihazlara aynı kurulumu uygularken zaman kazandırır ve operasyonel tutarlılığı artırır.

## Mimari / Özellikler

- Ubuntu tabanlı sistemlerde gerekli bağımlılıkları otomatik kurar.
- `mavlink-router` kaynak kodunu klonlar ve alt modülleri hazırlar.
- `meson` + `ninja` ile derleme ve kurulum adımlarını otomatikleştirir.
- Kullanıcıyı `dialout` grubuna ekleyerek seri port erişimini kolaylaştırır.
- İsteğe bağlı olarak `main.conf` üretir ve systemd servisini etkinleştirir.
- UART/UDP ayarlarını çevre değişkenleri ile özelleştirmenize izin verir (`UART_DEVICE`, `UART_BAUD`, `UDP_ADDRESS`, `UDP_PORT`).

## Hızlı Başlangıç

```bash
git clone https://github.com/furkanisikay/mavlink-router-kurulum.git
cd mavlink-router-kurulum
chmod +x kurulum.sh
./kurulum.sh
```

> Not: Script kurulum sırasında `sudo` yetkisi ister.

Kurulum sonrası örnek doğrulama:

```bash
mavlink-routerd -e 192.168.7.1:14550 -e 127.0.0.1:14550 /dev/ttyS1:1500000
```

## Ortam Kurulumu

1. Ubuntu 20.04+ (veya uyumlu Debian tabanlı dağıtım) kullanın.
2. Script çalışmadan önce `sudo` yetkisine sahip bir kullanıcı ile oturum açın.
3. Otomatik yapılandırma sırasında farklı cihaz/port kullanacaksanız aşağıdaki değişkenleri export edin:

```bash
export UART_DEVICE=/dev/ttyUSB0
export UART_BAUD=921600
export UDP_ADDRESS=0.0.0.0
export UDP_PORT=14550
```

## Katkı

Katkı süreci için [CONTRIBUTING.md](./CONTRIBUTING.md) dosyasına bakın.
