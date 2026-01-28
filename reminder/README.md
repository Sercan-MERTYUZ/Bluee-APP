# Bluee - Smart Reminder App

Bluee is a modern, efficient, and user-friendly reminder application built with **Flutter**. It allows users to manage tasks effectively with local notifications, persistent storage, and multi-language support.

## 🌟 Features

- **Task Management**: Create, read, and delete tasks easily.
- **Local Notifications**: Scheduled notifications to remind you of your tasks on time.
- **Offline Storage**: Uses **Hive** for fast and secure local data storage.
- **State Management**: Built with **Riverpod** for a robust and scalable architecture.
- **Multi-language Support**: Fully localized in **English** and **Turkish** using `easy_localization`.
- **Cross-Platform**: Runs smoothly on both iOS and Android.

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
   cd Bluee-APP/reminder
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
- 🇺🇸 English (`en`) - Default
- 🇹🇷 Turkish (`tr`)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
