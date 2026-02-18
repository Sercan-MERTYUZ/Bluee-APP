# Bluee - Smart Reminder App

Bluee is a modern, efficient, and user-friendly reminder application built with **Flutter**. It allows users to manage tasks effectively with local notifications, persistent storage, and multi-language support.

## 🌟 Features

- **Task Management**: Create, read, and delete tasks easily.
- **Search Tasks**: Quickly find tasks by title or note.
- **Note Taking**: Create notes with rich details including person/topic tags.
- **Advanced Filtering**: Filter notes by person (using checkboxes) and date range.
- **Dual Local Notifications**: Receive reminders **30 minutes** and **10 minutes** before your task.
- **Custom Notification Icons**: Notifications feature the app logo and a custom status bar icon.
- **Offline Storage**: Uses **Hive** for fast and secure local data storage.
- **State Management**: Built with **Riverpod** for a robust and scalable architecture.
- **Multi-language Support**: Fully localized in **English** and **Turkish** using `easy_localization`.
- **Cross-Platform**: Runs smoothly on iOS, Android, macOS, and Web.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Local Storage**: [Hive](https://docs.hivedb.dev/)
- **Notifications**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Localization**: [easy_localization](https://pub.dev/packages/easy_localization)
- **Date Formatting**: [intl](https://pub.dev/packages/intl)

## 📂 Project Structure

The project follows a feature-first, clean architecture approach:

```
lib/
├── core/
│   ├── notifications/   # Notification logic and configuration
│   └── storage/        # Database (Hive) setup
├── features/
│   └── tasks/          # Task feature module
│       ├── data/       # Models, Hive Adapters, Repositories
│       ├── presentation/ # UI (Pages, Widgets)
│       └── state/      # Riverpod Providers
│   └── notes/          # Notes feature module
│       ├── data/       # Note Model and Adapter
│       └── presentation/ # UI (Notes Page, Dialogs)
├── assets/
│   └── translations/   # JSON files for EN and TR support
└── main.dart           # App entry point and initialization
```

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.0.0 or higher)
   - Download: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
   - Run `flutter doctor` to verify installation

2. **Dart SDK** (included with Flutter)

3. **Android Studio** (for Android builds)
   - Download: [https://developer.android.com/studio](https://developer.android.com/studio)
   - Install Android SDK via Android Studio
   - Set up an Android emulator or connect a physical device

4. **Xcode** (for iOS/macOS builds - Mac only)
   - Download from App Store
   - Run `xcode-select --install` for command line tools

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Sercan-MERTYUZ/Bluee-APP.git
   cd Bluee-APP
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Code Generator (for Hive & Riverpod)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

### Build APK (Android)

To build a release APK for Android:

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

Pre-built APKs are available in the `APKs/` directory:
- `APKs/Bluee.apk` - **Latest version** (Dual notifications, custom icons, timezone fix)
- `APKs/Bluee2.apk` - Old version with Notes feature

## 🌍 Localization

The app uses Turkish as the default language. Supported locales:
- 🇹🇷 Turkish (`tr`) - Default
- 🇺🇸 English (`en`)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

# 🇹🇷 Bluee - Akıllı Hatırlatıcı Uygulaması

Bluee, **Flutter** ile geliştirilmiş modern, etkili ve kullanıcı dostu bir hatırlatıcı uygulamasıdır. Yerel bildirimler, kalıcı depolama ve çoklu dil desteği ile görevlerinizi etkili bir şekilde yönetmenizi sağlar.

## 🌟 Özellikler

- **Görev Yönetimi**: Görevleri kolayca oluşturun, okuyun ve silin.
- **Görev Arama**: Başlık veya nota göre görevleri hızlıca bulun.
- **Not Alma**: Kişi/konu etiketleri ile detaylı notlar oluşturun.
- **Gelişmiş Filtreleme**: Notları kişiye (checkbox ile) ve tarih aralığına göre filtreleyin.
- **Çift Bildirim Sistemi**: Görevinizden **30 dakika** ve **10 dakika** önce hatırlatma alın.
- **Özel Bildirim İkonları**: Uygulama logosu ve özel durum çubuğu ikonu ile şık bildirimler.
- **Çevrimdışı Depolama**: Hızlı ve güvenli yerel veri depolaması için **Hive** kullanır.
- **Durum Yönetimi (State Management)**: Sağlam ve ölçeklenebilir bir mimari için **Riverpod** ile geliştirilmiştir.
- **Çoklu Dil Desteği**: `easy_localization` kullanılarak **İngilizce** ve **Türkçe** dillerini tam destekler.
- **Çapraz Platform**: iOS, Android, macOS ve Web'de sorunsuz çalışır.

## 🛠 Kullanılan Teknolojiler

- **Framework**: [Flutter](https://flutter.dev/)
- **Durum Yönetimi**: [Riverpod](https://riverpod.dev/)
- **Yerel Depolama**: [Hive](https://docs.hivedb.dev/)
- **Bildirimler**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Yerelleştirme (Dil)**: [easy_localization](https://pub.dev/packages/easy_localization)
- **Tarih Formatlama**: [intl](https://pub.dev/packages/intl)

## 📂 Proje Yapısı

Proje, özellik öncelikli (feature-first) temiz mimari yaklaşımını izler:

```
lib/
├── core/
│   ├── notifications/   # Bildirim mantığı ve konfigürasyonu
│   └── storage/        # Veritabanı (Hive) kurulumu
├── features/
│   └── tasks/          # Görev özelliği modülü
│       ├── data/       # Modeller, Hive Adaptörleri, Depolar (Repositories)
│       ├── presentation/ # Arayüz (Sayfalar, Widget'lar)
│       └── state/      # Riverpod Sağlayıcıları (Providers)
│   └── notes/          # Not özelliği modülü
│       ├── data/       # Not Modeli ve Adaptörü
│       └── presentation/ # Arayüz (Notlar Sayfası, Diyaloglar)
├── assets/
│   └── translations/   # EN ve TR desteği için JSON dosyaları
└── main.dart           # Uygulama giriş noktası ve başlatma
```

## 🚀 Başlarken

### Gereksinimler

Başlamadan önce aşağıdakilerin yüklü olduğundan emin olun:

1. **Flutter SDK** (3.0.0 veya üzeri)
   - İndirin: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
   - Kurulumu doğrulamak için `flutter doctor` komutunu çalıştırın

2. **Dart SDK** (Flutter ile birlikte gelir)

3. **Android Studio** (Android derlemeleri için)
   - İndirin: [https://developer.android.com/studio](https://developer.android.com/studio)
   - Android Studio üzerinden Android SDK'yı kurun
   - Bir Android emülatör kurun veya fiziksel cihaz bağlayın

4. **Xcode** (iOS/macOS derlemeleri için - Sadece Mac)
   - App Store'dan indirin
   - Komut satırı araçları için `xcode-select --install` çalıştırın

### Kurulum

1. **Depoyu klonlayın**
   ```bash
   git clone https://github.com/Sercan-MERTYUZ/Bluee-APP.git
   cd Bluee-APP
   ```

2. **Bağımlılıkları yükleyin**
   ```bash
   flutter pub get
   ```

3. **Kod Üreticisini Çalıştırın (Hive & Riverpod için)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Uygulamayı Çalıştırın**
   ```bash
   flutter run
   ```

### APK Oluşturma (Android)

Android için release APK oluşturmak için:

```bash
flutter build apk --release
```

APK dosyası şu konumda oluşturulacak: `build/app/outputs/flutter-apk/app-release.apk`

Hazır APK dosyaları `APKs/` klasöründe mevcuttur:
- `APKs/Bluee.apk` - İlk sürüm
- `APKs/Bluee2.apk` - Notlar özelliğini içeren sürüm

## 🌍 Dil Desteği

Uygulama varsayılan olarak Türkçe dilinde açılır. Desteklenen diller:
- 🇹🇷 Türkçe (`tr`) - Varsayılan
- 🇺🇸 İngilizce (`en`)

## 🤝 Katkıda Bulunma

Katkılarınız memnuniyetle karşılanır! Lütfen bir Pull Request göndermekten çekinmeyin.
