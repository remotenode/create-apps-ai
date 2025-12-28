import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/loan_calculator.dart';
import '../utils/currency_formatter.dart';
import '../widgets/result_card.dart';
import '../widgets/language_selector.dart';

/// Main screen for the loan calculator
class LoanCalculatorScreen extends StatefulWidget {
  final Locale currentLocale;
  final bool isDarkMode;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback onThemeToggle;

  const LoanCalculatorScreen({
    super.key,
    required this.currentLocale,
    required this.isDarkMode,
    required this.onLocaleChanged,
    required this.onThemeToggle,
  });

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();

  int _termYears = 15;
  PaymentFrequency _paymentFrequency = PaymentFrequency.monthly;
  LoanCalculationResult? _result;

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState?.validate() ?? false) {
      final loanAmount = _parseNumber(_loanAmountController.text);
      final interestRate = _parseNumber(_interestRateController.text);

      if (loanAmount != null && interestRate != null) {
        try {
          final result = LoanCalculator.calculate(
            principal: loanAmount,
            annualInterestRate: interestRate,
            termYears: _termYears,
            frequency: _paymentFrequency,
          );
          setState(() {
            _result = result;
          });
        } catch (e) {
          _showError(e.toString());
        }
      }
    }
  }

  double? _parseNumber(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^\d.,]'), '').replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _getFrequencyLabel(PaymentFrequency frequency) {
    final l10n = AppLocalizations.of(context)!;
    switch (frequency) {
      case PaymentFrequency.monthly:
        return l10n.monthly;
      case PaymentFrequency.biWeekly:
        return l10n.biWeekly;
      case PaymentFrequency.weekly:
        return l10n.weekly;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = widget.currentLocale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: widget.isDarkMode ? l10n.lightMode : l10n.darkMode,
            onPressed: widget.onThemeToggle,
          ),
          // Language selector
          LanguageSelector(
            currentLocale: widget.currentLocale,
            onLocaleChanged: widget.onLocaleChanged,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout: side-by-side on wider screens
            final isWideScreen = constraints.maxWidth > 800;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: isWideScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildInputForm(l10n, localeCode),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildResults(l10n, localeCode),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildInputForm(l10n, localeCode),
                            const SizedBox(height: 24),
                            _buildResults(l10n, localeCode),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputForm(AppLocalizations l10n, String localeCode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Loan Amount
              TextFormField(
                controller: _loanAmountController,
                decoration: InputDecoration(
                  labelText: l10n.loanAmount,
                  hintText: l10n.enterLoanAmount,
                  prefixText: _getCurrencySymbol(localeCode),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                ],
                validator: (value) {
                  final amount = _parseNumber(value ?? '');
                  if (!LoanCalculator.isValidLoanAmount(amount)) {
                    return l10n.invalidLoanAmount;
                  }
                  return null;
                },
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),

              // Interest Rate
              TextFormField(
                controller: _interestRateController,
                decoration: InputDecoration(
                  labelText: l10n.annualInterestRate,
                  hintText: l10n.enterInterestRate,
                  suffixText: '%',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                ],
                validator: (value) {
                  final rate = _parseNumber(value ?? '');
                  if (!LoanCalculator.isValidInterestRate(rate)) {
                    return l10n.invalidInterestRate;
                  }
                  return null;
                },
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 24),

              // Loan Term Slider
              Text(
                '${l10n.loanTermYears}: ${l10n.years(_termYears)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _termYears.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                label: _termYears.toString(),
                onChanged: (value) {
                  setState(() {
                    _termYears = value.round();
                  });
                  _calculate();
                },
              ),
              const SizedBox(height: 16),

              // Payment Frequency Dropdown
              DropdownButtonFormField<PaymentFrequency>(
                value: _paymentFrequency,
                decoration: InputDecoration(
                  labelText: l10n.paymentFrequency,
                ),
                items: PaymentFrequency.values.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(_getFrequencyLabel(frequency)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _paymentFrequency = value;
                    });
                    _calculate();
                  }
                },
              ),
              const SizedBox(height: 24),

              // Calculate Button
              FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate),
                label: Text(l10n.calculate),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(AppLocalizations l10n, String localeCode) {
    if (_result == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.calculate_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.results,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Text(
          l10n.results,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ResultCard(
          icon: Icons.payment,
          label: l10n.paymentAmount,
          value: CurrencyFormatter.format(_result!.paymentAmount, localeCode),
          color: Theme.of(context).colorScheme.primary,
        ),
        ResultCard(
          icon: Icons.account_balance_wallet,
          label: l10n.totalPayment,
          value: CurrencyFormatter.format(_result!.totalPayment, localeCode),
          color: Theme.of(context).colorScheme.secondary,
        ),
        ResultCard(
          icon: Icons.trending_up,
          label: l10n.totalInterest,
          value: CurrencyFormatter.format(_result!.totalInterest, localeCode),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        ResultCard(
          icon: Icons.event,
          label: l10n.payoffDate,
          value: CurrencyFormatter.formatDate(_result!.payoffDate, localeCode),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  String _getCurrencySymbol(String localeCode) {
    switch (localeCode) {
      case 'ru':
        return '\u20BD '; // ₽
      case 'es':
        return '\u20AC '; // €
      case 'en':
      default:
        return '\$ ';
    }
  }
}
