import 'package:intl/intl.dart';

/// Utility class for currency formatting based on locale
class CurrencyFormatter {
  /// Returns the appropriate currency code for a given locale
  static String getCurrencyCode(String localeCode) {
    switch (localeCode) {
      case 'ru':
        return 'RUB';
      case 'es':
        return 'EUR';
      case 'en':
      default:
        return 'USD';
    }
  }

  /// Returns a NumberFormat for currency formatting based on locale
  static NumberFormat getCurrencyFormat(String localeCode) {
    final currencyCode = getCurrencyCode(localeCode);
    return NumberFormat.currency(
      locale: localeCode,
      symbol: _getCurrencySymbol(currencyCode),
      decimalDigits: 2,
    );
  }

  /// Returns the currency symbol for a given currency code
  static String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'RUB':
        return '\u20BD'; // ₽
      case 'EUR':
        return '\u20AC'; // €
      case 'USD':
      default:
        return '\$';
    }
  }

  /// Formats a number as currency based on locale
  static String format(double amount, String localeCode) {
    return getCurrencyFormat(localeCode).format(amount);
  }

  /// Returns a date formatter for the given locale
  static DateFormat getDateFormat(String localeCode) {
    return DateFormat.yMMMd(localeCode);
  }

  /// Formats a date based on locale
  static String formatDate(DateTime date, String localeCode) {
    return getDateFormat(localeCode).format(date);
  }
}
