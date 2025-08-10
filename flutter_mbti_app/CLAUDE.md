# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Run the app:**
```bash
flutter run
```

**Build for different platforms:**
```bash
flutter build apk          # Android APK
flutter build appbundle    # Android App Bundle
flutter build ios          # iOS (requires macOS)
flutter build web          # Web
flutter build windows      # Windows
flutter build macos        # macOS
flutter build linux        # Linux
```

**Testing:**
```bash
flutter test               # Run all tests
flutter test test/specific_test.dart  # Run specific test file
```

**Linting and Code Analysis:**
```bash
flutter analyze           # Run static analysis
flutter format lib/       # Format Dart code
```

**Dependencies:**
```bash
flutter pub get           # Install dependencies
flutter pub upgrade       # Upgrade dependencies
flutter pub deps          # Show dependency tree
```

**Clean build:**
```bash
flutter clean             # Clean build artifacts
flutter pub get           # Reinstall dependencies after clean
```

## Project Architecture

This is a basic Flutter application for an MBTI (Myers-Briggs Type Indicator) app. Currently in early development stage.

**Key Structure:**
- `lib/main.dart` - Entry point with basic Material app setup
- `pubspec.yaml` - Dependencies and project configuration
- Platform-specific folders: `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`

**Current State:**
- Basic Flutter app template with "Hello World" placeholder
- Uses Material Design
- Multi-platform support configured
- Flutter lints enabled for code quality

**Development Notes:**
- Uses Flutter SDK 3.4.0+
- Analysis options configured with `flutter_lints`
- No additional dependencies beyond Flutter core
- Ready for MBTI-related feature development

## Platform Support

The app is configured for all major platforms:
- Android (via `android/` folder)
- iOS (via `ios/` folder) 
- Web (via `web/` folder)
- Windows (via `windows/` folder)
- macOS (via `macos/` folder)
- Linux (via `linux/` folder)