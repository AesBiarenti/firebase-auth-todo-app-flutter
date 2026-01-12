# 🔑 Firebase API Key Değiştirme Rehberi

Bu rehber, Firebase API key'lerinizi güvenli bir şekilde değiştirmeniz için adım adım talimatlar içerir.

## ⚠️ ÖNEMLİ

Eğer API key'leriniz git history'de commit edildiyse, **ÖNCE** bu key'leri değiştirmeniz **ZORUNLUDUR**.

## 📋 Adım Adım Talimatlar

### 1. Firebase Console'a Giriş Yapın

1. [Firebase Console](https://console.firebase.google.com/)'a gidin
2. Projenizi seçin: `fir-todo-app-a4075` (veya kendi projeniz)

### 2. API Key'leri Bulun

1. Sol menüden **⚙️ Project Settings** (Proje Ayarları) seçin
2. **Your apps** (Uygulamalarınız) sekmesine gidin
3. Android uygulamanızı bulun
4. **API Key** bölümüne tıklayın

### 3. Mevcut API Key'i Kısıtlayın veya Değiştirin

#### Seçenek A: API Key'i Kısıtla (Önerilen)

1. API key'in yanındaki **"Restrict key"** (Anahtarı Kısıtla) butonuna tıklayın
2. **Application restrictions** bölümünde:
   - **Android apps** seçin
   - Package name ekleyin: `com.example.firebase_todo_app`
3. **API restrictions** bölümünde:
   - **Restrict key** seçin
   - Sadece gerekli API'leri seçin:
     - ✅ Firebase Authentication API
     - ✅ Cloud Firestore API
     - ✅ Firebase Realtime Database API (eğer kullanıyorsanız)
4. **Save** (Kaydet) butonuna tıklayın

#### Seçenek B: Yeni API Key Oluştur (Daha Güvenli)

1. **"Add API key"** (API Key Ekle) butonuna tıklayın
2. Yeni key için isim verin: `Firebase Todo App - New Key`
3. Yukarıdaki kısıtlamaları uygulayın
4. **Create** (Oluştur) butonuna tıklayın
5. Yeni API key'i kopyalayın

### 4. Eski API Key'i Revoke Edin (Silin)

1. Eski API key'in yanındaki **"Delete"** (Sil) butonuna tıklayın
2. Onaylayın

**NOT:** Eski key'i silmeden önce yeni key'in çalıştığından emin olun!

### 5. Yerel Dosyaları Güncelleyin

#### .env Dosyasını Güncelleyin

```bash
# .env dosyasını açın ve yeni değerleri girin
nano .env
```

Yeni değerlerle güncelleyin:

```env
FIREBASE_API_KEY=yeni_api_key_buraya
FIREBASE_APP_ID=1:544233077586:android:af761bbd26f24acfec988b
FIREBASE_MESSAGING_SENDER_ID=544233077586
FIREBASE_PROJECT_ID=fir-todo-app-a4075
FIREBASE_STORAGE_BUCKET=fir-todo-app-a4075.firebasestorage.app
```

**NOT:** Eğer App ID, Project ID veya diğer değerler değiştiyse, onları da güncelleyin.

### 6. Uygulamayı Test Edin

```bash
# Uygulamayı çalıştırın ve test edin
flutter run
```

Şunları kontrol edin:
- ✅ Uygulama başlatılıyor mu?
- ✅ Firebase Authentication çalışıyor mu?
- ✅ Firestore bağlantısı çalışıyor mu?

### 7. Google Services JSON Dosyasını Güncelleyin (Gerekirse)

Eğer App ID değiştiyse:

1. Firebase Console > Project Settings > Your apps
2. Android uygulamanızın yanındaki **"Download google-services.json"** butonuna tıklayın
3. Dosyayı `android/app/google-services.json` konumuna kopyalayın

## 🔒 Güvenlik Best Practices

### API Key Kısıtlamaları

Her zaman API key'lerinize kısıtlamalar ekleyin:

1. **Application Restrictions:**
   - Android apps: Package name kısıtlaması
   - iOS apps: Bundle ID kısıtlaması (eğer iOS desteği varsa)

2. **API Restrictions:**
   - Sadece kullandığınız API'leri aktif edin
   - Gereksiz API'leri kapatın

### Production vs Development

- **Development:** Test key'leri kullanabilirsiniz (daha az kısıtlı)
- **Production:** Mutlaka kısıtlamalı key'ler kullanın

### Key Rotation (Key Döndürme)

- Düzenli olarak (3-6 ayda bir) API key'lerinizi değiştirin
- Eski key'leri hemen revoke edin
- Yeni key'leri önce test edin, sonra eski key'i silin

## 🚨 Sorun Giderme

### "API key not valid" Hatası

1. `.env` dosyasındaki key'in doğru olduğundan emin olun
2. Firebase Console'da key'in aktif olduğunu kontrol edin
3. Key kısıtlamalarının doğru olduğunu kontrol edin

### "Permission denied" Hatası

1. API key kısıtlamalarını kontrol edin
2. Package name'in doğru olduğundan emin olun
3. Gerekli API'lerin aktif olduğundan emin olun

## 📞 Yardım

Sorun yaşarsanız:
1. Firebase Console > Support sekmesine bakın
2. [Firebase Documentation](https://firebase.google.com/docs) kontrol edin
3. [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase) arayın

