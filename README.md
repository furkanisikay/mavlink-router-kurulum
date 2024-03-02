# Mavlink-router Kurulum Rehberi
Mavlink Router Kütüphanesinin kurulumunu pratik olarak yapmanızı sağlayan bash scriptini içeren repo.
Bu rehber, Ubuntu tabanlı bir Linux dağıtımında mavlink-router kütüphanesinin otomatik kurulumu için "kurulum.sh" scriptinin nasıl kullanılacağını anlatmaktadır.

## Kullanım

1. **"kurulum.sh" scriptini indirin:**

```bash
git clone https://github.com/furkanisikay/mavlink-router-kurulum.git
cd mavlink-router-kurulum
```

2. Scriptin çalıştırılabilirlik iznini ayarlayın:

```bash
chmod +x kurulum.sh
```

3. Scripti çalıştırın:

```bash
chmod +x kurulum.sh
```
4. Kurulum tamamlandıktan sonra, aşağıdaki komutu çalıştırarak kurulumu test edebilirsiniz:

```bash
mavlink-routerd -e 192.168.7.1:14550 -e 127.0.0.1:14550 /dev/ttyS1:1500000
```

### Notlar:

- Scriptin çalıştırılabilme iznini ayarlamak için chmod komutunu kullanmanız gerekir.
- Scripti sudo ile çalıştırmanız gerekir.
- Scripti çalıştırdıktan sonra, mavlink-routerd komutunu kullanarak kütüphaneyi test edebilirsiniz.
- Daha fazla bilgi için [mavlink-router belgelerine](https://mavlink.io/en/router/) bakabilirsiniz.
**Destek:**

Herhangi bir sorun yaşarsanız, lütfen [furkanisikay](https://github.com/furkanisikay) GitHub profilinden bana ulaşabilirsiniz.
