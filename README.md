# Loan Calculator

A production-ready, multi-language Loan Calculator app built with Flutter 3.x+, supporting Android, iOS, and Web platforms.

## Features

- **Multi-language Support**: English, Russian, Spanish
- **Language Switcher**: Easy-to-use dropdown in the AppBar
- **Currency by Locale**: USD (English), RUB (Russian), EUR (Spanish)
- **Loan Inputs**:
  - Loan amount with currency formatting
  - Annual interest rate (0.1% - 30%)
  - Loan term (1-30 years) via slider
  - Payment frequency: Monthly, Bi-weekly, Weekly
- **Real-time Calculations**: Using standard amortization formula
- **Results Display**:
  - Payment amount (per period)
  - Total payment
  - Total interest
  - Approximate payoff date
- **Material 3 Design**: Modern UI with adaptive layouts
- **Dark/Light Theme**: Toggle between themes
- **Responsive**: Works on phones, tablets, and web

## Project Structure

```
loan_calculator/
├── lib/
│   ├── main.dart                    # App entry point with theme/locale management
│   ├── screens/
│   │   └── loan_calculator_screen.dart  # Main calculator screen
│   ├── widgets/
│   │   ├── result_card.dart         # Result display card widget
│   │   └── language_selector.dart   # Language dropdown widget
│   ├── utils/
│   │   ├── loan_calculator.dart     # Loan calculation logic
│   │   └── currency_formatter.dart  # Currency/date formatting utilities
│   └── l10n/
│       ├── app_en.arb               # English translations
│       ├── app_ru.arb               # Russian translations
│       └── app_es.arb               # Spanish translations
├── assets/
│   └── images/
│       ├── app_icon.png             # App icon (512x512)
│       └── splash_logo.png          # Splash screen logo
├── android/                         # Android configuration
├── ios/                             # iOS configuration
├── web/                             # Web configuration
├── pubspec.yaml                     # Dependencies and assets
├── l10n.yaml                        # Localization configuration
└── analysis_options.yaml            # Dart analyzer settings
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- For Android: Android SDK with API level 21+
- For iOS: Xcode 14+ with iOS 12.0+ support
- For Web: Chrome browser (for development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/remotenode/create-apps-ai.git
   cd create-apps-ai
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localization files:
   ```bash
   flutter gen-l10n
   ```

4. Generate app icons (optional, only if you update the icon):
   ```bash
   flutter pub run flutter_launcher_icons
   ```

5. Generate splash screen (optional):
   ```bash
   flutter pub run flutter_native_splash:create
   ```

## Running the App

### Development

```bash
# Run on connected device/emulator
flutter run

# Run on Chrome (web)
flutter run -d chrome

# Run on Android emulator
flutter run -d android

# Run on iOS simulator
flutter run -d ios
```

### Debug Mode

```bash
flutter run --debug
```

## Building for Release

### Android

1. Build APK:
   ```bash
   flutter build apk --release
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk`

2. Build App Bundle (recommended for Play Store):
   ```bash
   flutter build appbundle --release
   ```
   Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

1. Build IPA:
   ```bash
   flutter build ipa --release
   ```
   Output: `build/ios/ipa/`

2. For App Store submission, open `ios/Runner.xcworkspace` in Xcode and archive from there.

### Web

1. Build for web:
   ```bash
   flutter build web --release
   ```
   Output: `build/web/`

2. Deploy the contents of `build/web/` to any static hosting service.

## Configuration

### Customizing App Icons

1. Replace `assets/images/app_icon.png` with your icon (512x512 PNG recommended)
2. Run:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

### Customizing Splash Screen

1. Replace `assets/images/splash_logo.png` with your logo
2. Edit colors in `pubspec.yaml` under `flutter_native_splash`
3. Run:
   ```bash
   flutter pub run flutter_native_splash:create
   ```

### Adding New Languages

1. Create a new ARB file in `lib/l10n/` (e.g., `app_de.arb` for German)
2. Add the locale to `supportedLocales` in `lib/main.dart`
3. Add the locale to the `LanguageSelector` widget
4. Run `flutter gen-l10n`

## Loan Calculation Formula

The app uses the standard amortization formula:

```
M = P * [r(1+r)^n] / [(1+r)^n - 1]
```

Where:
- **M** = Payment amount
- **P** = Principal (loan amount)
- **r** = Periodic interest rate (annual rate / payments per year)
- **n** = Total number of payments

## Dependencies

- `flutter_localizations` - Flutter localization support
- `intl` (^0.19.0) - Internationalization and localization
- `flutter_launcher_icons` (^0.13.1) - App icon generation
- `flutter_native_splash` (^2.3.8) - Native splash screen generation

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is open source and available under the MIT License.
