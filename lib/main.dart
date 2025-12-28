import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/loan_calculator_screen.dart';

void main() {
  runApp(const LoanCalculatorApp());
}

/// Main application widget with theme and localization support
class LoanCalculatorApp extends StatefulWidget {
  const LoanCalculatorApp({super.key});

  @override
  State<LoanCalculatorApp> createState() => _LoanCalculatorAppState();
}

class _LoanCalculatorAppState extends State<LoanCalculatorApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  /// Updates the app locale
  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  /// Toggles between light and dark theme
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Calculator',
      debugShowCheckedModeBanner: false,

      // Theme configuration with Material 3
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
        cardTheme: const CardTheme(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
        cardTheme: const CardTheme(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      themeMode: _themeMode,

      // Localization configuration
      locale: _locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('ru'), // Russian
        Locale('es'), // Spanish
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Main screen
      home: LoanCalculatorScreen(
        currentLocale: _locale,
        isDarkMode: _themeMode == ThemeMode.dark,
        onLocaleChanged: _setLocale,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
