import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A dropdown widget for selecting the app language
class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getLanguageFlag(currentLocale.languageCode),
            style: const TextStyle(fontSize: 20),
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      tooltip: l10n.language,
      onSelected: onLocaleChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              const Text('🇺🇸 ', style: TextStyle(fontSize: 20)),
              Text(l10n.english),
              if (currentLocale.languageCode == 'en') ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('ru'),
          child: Row(
            children: [
              const Text('🇷🇺 ', style: TextStyle(fontSize: 20)),
              Text(l10n.russian),
              if (currentLocale.languageCode == 'ru') ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('es'),
          child: Row(
            children: [
              const Text('🇪🇸 ', style: TextStyle(fontSize: 20)),
              Text(l10n.spanish),
              if (currentLocale.languageCode == 'es') ...[
                const Spacer(),
                const Icon(Icons.check, size: 18),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return '🇷🇺';
      case 'es':
        return '🇪🇸';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
