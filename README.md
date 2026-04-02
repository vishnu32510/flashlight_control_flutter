# flashlight_control

Simple Flutter flashlight app scaffold with a clean, reusable architecture:

- `core/` for config, DI, services, and shared utils
- `features/` for feature modules (currently `home` and `theme`)
- `get_it` dependency injection setup in `core/di/injection.dart`
- `go_router` route setup in `core/config/routes.dart`
- `flutter_bloc` for theme state management

This app currently has **no Firebase** and **no authentication**.

## Project Structure

```text
lib/
  core/
    config/
    di/
    services/
    utils/
  features/
    home/
    theme/
  main.dart
```

## Run

```bash
flutter pub get
flutter run
```

## Quality Check

```bash
flutter analyze
```

## Store Releases (Fastlane)

Fastlane setup is available for iOS and Android releases:

- `ios/fastlane/`
- `android/fastlane/`
- root `Gemfile`

Example commands:

```bash
cd ios && bundle exec fastlane beta
cd android && bundle exec fastlane internal
```
