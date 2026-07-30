# Operasyon rehberi

İlk tarama bir yönetim iş istasyonundan salt okunur şekilde yapılmalıdır.
`Error` sonuçları uyumsuzluk değil, ölçüm eksikliği olarak ele alınır.
Privileged group ve inaktif nesne kontrolleri otomatik düzeltilmez; sahiplik,
bağımlılık ve geri alma planı gerektirir.

Parola ilkesi değişiklikleri yeni parola belirleme anında etkili olur. LDAP
imzalama zorunluluğu eski istemcileri kesebilir. Önce olay günlüklerinden
imzasız LDAP istemcileri belirlenmeli, sonra kontrollü bakım penceresinde
uygulanmalıdır.
