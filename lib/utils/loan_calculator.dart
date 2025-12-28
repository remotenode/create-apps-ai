import 'dart:math';

/// Enum representing payment frequency options
enum PaymentFrequency {
  monthly(12, 'monthly'),
  biWeekly(26, 'biWeekly'),
  weekly(52, 'weekly');

  final int paymentsPerYear;
  final String key;

  const PaymentFrequency(this.paymentsPerYear, this.key);
}

/// Result of loan calculation
class LoanCalculationResult {
  final double paymentAmount;
  final double totalPayment;
  final double totalInterest;
  final DateTime payoffDate;
  final int totalPayments;

  const LoanCalculationResult({
    required this.paymentAmount,
    required this.totalPayment,
    required this.totalInterest,
    required this.payoffDate,
    required this.totalPayments,
  });
}

/// Utility class for loan calculations
class LoanCalculator {
  /// Calculates loan payment details using the standard amortization formula.
  ///
  /// Formula: M = P * [r(1+r)^n] / [(1+r)^n - 1]
  /// Where:
  /// - M = Payment amount
  /// - P = Principal (loan amount)
  /// - r = Periodic interest rate (annual rate / payments per year)
  /// - n = Total number of payments
  static LoanCalculationResult calculate({
    required double principal,
    required double annualInterestRate,
    required int termYears,
    required PaymentFrequency frequency,
  }) {
    // Validate inputs
    if (principal <= 0) {
      throw ArgumentError('Principal must be positive');
    }
    if (annualInterestRate < 0.1 || annualInterestRate > 30) {
      throw ArgumentError('Annual interest rate must be between 0.1% and 30%');
    }
    if (termYears < 1 || termYears > 30) {
      throw ArgumentError('Term must be between 1 and 30 years');
    }

    // Calculate periodic interest rate and total number of payments
    final periodicRate = (annualInterestRate / 100) / frequency.paymentsPerYear;
    final totalPayments = termYears * frequency.paymentsPerYear;

    // Calculate payment amount using the standard loan formula
    double paymentAmount;
    if (periodicRate == 0) {
      // Handle edge case of 0% interest
      paymentAmount = principal / totalPayments;
    } else {
      final compoundFactor = pow(1 + periodicRate, totalPayments);
      paymentAmount =
          principal * (periodicRate * compoundFactor) / (compoundFactor - 1);
    }

    // Calculate totals
    final totalPayment = paymentAmount * totalPayments;
    final totalInterest = totalPayment - principal;

    // Calculate payoff date
    final now = DateTime.now();
    final daysPerPayment = 365.25 / frequency.paymentsPerYear;
    final totalDays = (daysPerPayment * totalPayments).round();
    final payoffDate = now.add(Duration(days: totalDays));

    return LoanCalculationResult(
      paymentAmount: paymentAmount,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      payoffDate: payoffDate,
      totalPayments: totalPayments,
    );
  }

  /// Validates if the given loan amount is valid
  static bool isValidLoanAmount(double? amount) {
    return amount != null && amount > 0;
  }

  /// Validates if the given interest rate is valid (0.1% - 30%)
  static bool isValidInterestRate(double? rate) {
    return rate != null && rate >= 0.1 && rate <= 30;
  }

  /// Validates if the given term is valid (1 - 30 years)
  static bool isValidTerm(int term) {
    return term >= 1 && term <= 30;
  }
}
