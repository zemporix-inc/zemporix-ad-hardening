# Zemporix Active Directory Hardening

Active Directory etki alanlarında parola ilkesi, ayrıcalıklı grup üyeliği,
inaktif bilgisayar hesapları, işlev düzeyi ve LDAP imzalama durumunu ölçen
PowerShell paketidir. Proje **zemporix-inc** tarafından geliştirilir ve MIT
lisansı ile sunulur.

## Amaç

Etki alanı güvenliği tek bir ayardan oluşmaz. Bu depo tekrarlanabilir bir
denetim modeli, sürümlenmiş baseline, makinece okunabilir sonuçlar ve yalnızca
güvenle otomatikleştirilebilen kontroller için `-WhatIf` destekli düzeltme
sağlar. Ayrıcalıklı gruplardan üye silme gibi bağlama bağlı kararlar özellikle
operatöre bırakılmıştır.

## Kapsam

- Varsayılan etki alanı parola ilkesi
- Domain Admins üye sayısı görünürlüğü
- Etkin fakat uzun süredir oturum açmamış bilgisayarlar
- Etki alanı işlev düzeyi
- Domain Controller üzerinde LDAP imzalama
- JSON durum anlık görüntüsü

## Gereksinimler

- Windows PowerShell 5.1 veya PowerShell 7
- RSAT `ActiveDirectory` modülü
- Etki alanını okuyabilen bir hesap
- Düzeltme için ilgili delegasyon ve yükseltilmiş oturum
- Testler için Pester 5

## Kurulum

```powershell
git clone https://github.com/zemporix-inc/zemporix-ad-hardening.git
cd zemporix-ad-hardening
Import-Module ./Zemporix.ADHardening.psd1 -Force
```

## Kullanım

Varsayılan etki alanını denetleyin:

```powershell
Test-ZxADHardening | Format-Table Id,Severity,Status,Expected,Actual
```

Belirli bir Domain Controller üzerinden sorgulayın:

```powershell
Test-ZxADHardening -Server dc01.contoso.local
```

Değişiklik planını görün:

```powershell
Invoke-ZxADHardening -IncludeControl ZX-AD-001,ZX-AD-002 -WhatIf
```

Denetim kanıtı üretin:

```powershell
Export-ZxADSnapshot -Server dc01.contoso.local -Path ./reports/ad-snapshot.json
```

## Güvenlik yaklaşımı

Modül varsayılan olarak hiçbir şeyi değiştirmez. `Invoke-ZxADHardening`
yalnızca baseline içinde `remediable: true` olan bulgulara dokunur ve
PowerShell onay mekanizmasını kullanır. Ayrıcalıklı grup üyeleri ve eski
bilgisayar nesneleri otomatik silinmez. LDAP imzalama eski uygulamaları
etkileyebileceğinden önce istemci envanteri çıkarılmalıdır.

## Baseline ve sonuçlar

Her kontrolün değişmez bir `ZX-AD-*` kimliği, önem seviyesi, karşılaştırma
operatörü ve beklenen değeri vardır. `Pass`, `Fail` ve `Error` durumları
raporlanır. `Error` sonucunu başarılı saymayın; çoğunlukla eksik RSAT,
yetkilendirme veya erişilemeyen DC anlamına gelir.

Yeni kontroller `baselines/ad-balanced.json` dosyasına eklenirken keşif
işlemi salt okunur tutulmalı ve test eklenmelidir:

```powershell
Invoke-Pester ./tests
```

Üretim sıralaması ve risk notları [docs/OPERASYON.md](docs/OPERASYON.md)
dosyasındadır.

## Lisans

Telif hakkı 2026 **zemporix-inc**. Proje [MIT Lisansı](LICENSE) altındadır.
Güvenlik açıklarını herkese açık issue yerine [SECURITY.md](SECURITY.md)
yoluyla bildirin.
