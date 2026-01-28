# Reminder App

A Flutter MVP reminder app with local notifications, persistent storage with Hive, and localization support (English & Turkish).

## Features

- ✅ Create tasks with title, optional notes, and date/time
- ✅ List all tasks sorted by scheduled time
- ✅ Mark tasks as done
- ✅ Delete tasks
- ✅ Local notifications at scheduled time
- ✅ Persistent storage with Hive
- ✅ Localization (English & Turkish)
- ✅ Language toggle in AppBar

## Project Structure

```
lib/
  main.dart                          # Entry point
  app.dart                           # App configuration
  core/
    notifications/
      notification_service.dart      # Local notifications management
    storage/
      hive_boxes.dart               # Hive box access
  features/
    tasks/
      data/
        task_model.dart             # Task Hive model
        task_repository.dart        # Repository pattern
      state/
        task_providers.dart         # Riverpod state management
      presentation/
        pages/
          task_list_page.dart       # Main task list screen
          task_add_page.dart        # Add new task screen
        widgets/
          task_tile.dart            # Task item widget

assets/translations/
  en.json                           # English localization strings
  tr.json                           # Turkish localization strings
```

## Tech Stack

- **Flutter**: UI framework
- **flutter_riverpod**: State management
- **hive & hive_flutter**: Local database
- **easy_localization**: Multi-language support
- **flutter_local_notifications**: Push notifications
- **timezone & flutter_timezone**: Timezone handling
- **uuid**: Unique ID generation
- **intl**: Date formatting

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- iOS: Xcode
- Android: Android Studio, Android SDK

### Installation

1. Clone and navigate to project:
```bash
cd reminder
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Usage

### Creating a Task
1. Tap the FAB (+) button
2. Enter task title
3. Optionally add a note
4. Select date and time
5. Tap Save

### Managing Tasks
- **Mark as Done**: Tap the checkbox to mark a task complete
- **Delete Task**: Tap the delete icon (notification will be cancelled)
- **Change Language**: Tap the language icon in AppBar

## Validation

- Scheduled time must be in the future
- Title field is required
- Date/time selection is required

## Notifications

Local notifications are scheduled for each task at the specified time. When you:
- **Create a task**: Notification is scheduled
- **Mark as done**: Notification is cancelled
- **Delete a task**: Notification is cancelled

## Localization

Supports English (en) and Turkish (tr). Language changes are applied immediately and persist in the app session.

---

**MVP Version**: No repeating reminders, cloud sync, or authentication features.
