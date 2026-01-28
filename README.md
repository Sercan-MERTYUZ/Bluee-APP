# Bluee - Smart Reminder App

Bluee is a modern, efficient, and user-friendly reminder application built with **Flutter**. It allows users to manage tasks effectively with local notifications, persistent storage, and multi-language support.

## 🌟 Features

- **Task Management**: Create, read, and delete tasks easily.
- **Local Notifications**: Scheduled notifications to remind you of your tasks on time.
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
├── assets/
│   └── translations/   # JSON files for EN and TR support
└── main.dart           # App entry point and initialization
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK

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

## 🌍 Localization

The app automatically detects the system language. Supported locales:
- �� Turkish (`tr`) - Default
- �� English (`en`)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

# 🇹🇷 Bluee - Akıllı Hatırlatıcı Uygulaması

Bluee, **Flutter** ile geliştirilmiş modern, etkili ve kullanıcı dostu bir hatırlatıcı uygulamasıdır. Yerel bildirimler, kalıcı depolama ve çoklu dil desteği ile görevlerinizi etkili bir şekilde yönetmenizi sağlar.

## 🌟 Özellikler

- **Görev Yönetimi**: Görevleri kolayca oluşturun, okuyun ve silin.
- **Yerel Bildirimler**: Görevlerinizi zamanında hatırlatmak için zamanlanmış bildirimler.
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
├── assets/
│   └── translations/   # EN ve TR desteği için JSON dosyaları
└── main.dart           # Uygulama giriş noktası ve başlatma
```

## 🚀 Başlarken

### Gereksinimler

- Flutter SDK (3.0.0 veya üzeri)
- Dart SDK

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

## 🌍 Dil Desteği

Uygulama, sistem dilini otomatik olarak algılar. Desteklenen diller:
- �� Türkçe (`tr`) - Varsayılan
- �� İngilizce (`en`)

## 🤝 Katkıda Bulunma

Katkılarınız memnuniyetle karşılanır! Lütfen bir Pull Request göndermekten çekinmeyin.
