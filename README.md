# Firebase Todo App

Modern, kullanıcı dostu bir Todo uygulaması. Firebase Authentication ve Firestore ile güçlendirilmiş, Clean Architecture prensipleriyle geliştirilmiş Flutter uygulaması.

## 🚀 Özellikler

- ✅ Firebase Authentication (Email/Password)
- ✅ Firestore Database entegrasyonu
- ✅ Real-time todo listesi
- ✅ Todo ekleme, düzenleme, silme
- ✅ Durum yönetimi (Beklemede, Devam Ediyor, Tamamlandı)
- ✅ Tarih seçimi ve takibi
- ✅ Material Design 3 tema
- ✅ Dark/Light mode desteği
- ✅ Türkçe locale desteği
- ✅ Clean Architecture + Riverpod state management

## 📋 Gereksinimler

- Flutter SDK (3.9.2 veya üzeri)
- Dart SDK
- Firebase projesi
- Android Studio / VS Code

## 🛠️ Kurulum

### 1. Projeyi klonlayın

```bash
git clone https://github.com/YOUR_USERNAME/firebase_todo_app.git
cd firebase_todo_app
```

### 2. Bağımlılıkları yükleyin

```bash
flutter pub get
```

### 3. Firebase yapılandırması

#### Firebase projesi oluşturma

1. [Firebase Console](https://console.firebase.google.com/)'a gidin
2. Yeni bir proje oluşturun
3. Authentication'ı aktif edin (Email/Password)
4. Firestore Database oluşturun

#### Android yapılandırması

1. Firebase Console'da Android uygulaması ekleyin
2. Package name: `com.example.firebase_todo_app`
3. `google-services.json` dosyasını indirin
4. Dosyayı `android/app/` klasörüne kopyalayın

#### Firebase Options dosyası

1. FlutterFire CLI ile yapılandırın:

```bash
flutterfire configure
```

Veya manuel olarak:

1. `lib/firebase_options.example.dart` dosyasını `lib/firebase_options.dart` olarak kopyalayın
2. Firebase Console'dan alacağınız değerleri doldurun:
   - `apiKey`
   - `appId`
   - `messagingSenderId`
   - `projectId`
   - `storageBucket`

### 4. Firestore Security Rules

Firebase Console > Firestore Database > Rules sekmesinde:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /todos/{todoId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && resource.data.userId == request.auth.uid && request.resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

### 5. Firestore Index (Opsiyonel)

Performans için composite index oluşturun:

- Collection: `todos`
- Fields: `userId` (Ascending), `createdAt` (Descending)

### 6. Uygulamayı çalıştırın

```bash
flutter run
```

## 📁 Proje Yapısı

```
lib/
├── core/              # Temel yapılar
│   ├── constants/    # Sabitler
│   ├── theme/         # Tema yapılandırması
│   └── widgets/       # Ortak widget'lar
├── data/              # Data katmanı
│   ├── datasources/   # Firebase datasource
│   ├── models/        # Data modelleri
│   └── repositories/  # Repository implementasyonları
├── domain/            # Domain katmanı
│   ├── entities/      # İş mantığı entity'leri
│   ├── repositories/  # Repository interface'leri
│   └── usecases/      # Use case'ler
└── presentation/      # Presentation katmanı
    ├── pages/         # UI sayfaları
    └── providers/     # Riverpod provider'ları
```

## 🔒 Güvenlik

**ÖNEMLİ:** Bu proje public bir repository'dir. Aşağıdaki dosyalar `.gitignore`'a eklenmiştir ve commit edilmemelidir:

- `lib/firebase_options.dart` - Firebase API key'leri içerir
- `android/app/google-services.json` - Firebase yapılandırması
- `android/local.properties` - Local yapılandırma
- `.env` dosyaları

Kendi Firebase projenizi oluşturup yapılandırmanız gerekmektedir.

## 📝 Kullanım

1. Uygulamayı başlatın
2. Kayıt olun veya giriş yapın
3. Todo ekleyin, düzenleyin veya silin
4. Todo durumlarını güncelleyin
5. Bitiş tarihi ekleyin

## 🛡️ Güvenlik Notları

- Firebase Security Rules'ı production'da mutlaka yapılandırın
- API key'leri asla public repository'lerde paylaşmayın
- Firestore Rules'ı düzenli olarak gözden geçirin
- Production'da test mode kurallarını kullanmayın

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add some amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 👨‍💻 Geliştirici

[Your Name]

## 🙏 Teşekkürler

- Flutter ekibine
- Firebase ekibine
- Riverpod ekibine
