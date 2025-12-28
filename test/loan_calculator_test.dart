import 'package:flutter_test/flutter_test.dart';
import 'package:loan_calculator/utils/loan_calculator.dart';

void main() {
  group('LoanCalculator', () {
    test('calculates monthly payment correctly for standard loan', () {
      final result = LoanCalculator.calculate(
        principal: 100000,
        annualInterestRate: 5.0,
        termYears: 30,
        frequency: PaymentFrequency.monthly,
      );

      // Expected monthly payment for $100,000 at 5% for 30 years is approximately $536.82
      expect(result.paymentAmount, closeTo(536.82, 0.01));
      expect(result.totalPayments, equals(360)); // 30 years * 12 months
    });

    test('calculates bi-weekly payment correctly', () {
      final result = LoanCalculator.calculate(
        principal: 100000,
        annualInterestRate: 5.0,
        termYears: 30,
        frequency: PaymentFrequency.biWeekly,
      );

      // Bi-weekly payments should be roughly half of monthly
      expect(result.paymentAmount, closeTo(247.49, 0.5));
      expect(result.totalPayments, equals(780)); // 30 years * 26 bi-weekly
    });

    test('calculates weekly payment correctly', () {
      final result = LoanCalculator.calculate(
        principal: 100000,
        annualInterestRate: 5.0,
        termYears: 30,
        frequency: PaymentFrequency.weekly,
      );

      expect(result.totalPayments, equals(1560)); // 30 years * 52 weeks
    });

    test('total interest is positive', () {
      final result = LoanCalculator.calculate(
        principal: 100000,
        annualInterestRate: 5.0,
        termYears: 30,
        frequency: PaymentFrequency.monthly,
      );

      expect(result.totalInterest, greaterThan(0));
      expect(result.totalPayment, greaterThan(result.totalInterest));
    });

    test('total payment equals principal plus interest', () {
      final result = LoanCalculator.calculate(
        principal: 100000,
        annualInterestRate: 5.0,
        termYears: 30,
        frequency: PaymentFrequency.monthly,
      );

      expect(
        result.totalPayment,
        closeTo(100000 + result.totalInterest, 0.01),
      );
    });

    test('payoff date is in the future', () {
      final result = LoanCalculator.calculate(
        principal: 100000,
        annualInterestRate: 5.0,
        termYears: 10,
        frequency: PaymentFrequency.monthly,
      );

      expect(result.payoffDate.isAfter(DateTime.now()), isTrue);
    });

    test('shorter term means higher payments but less interest', () {
      final longTermResult = LoanCalculator.calculate(
        principal: 100000,
        annualInterestRate: 5.0,
        termYears: 30,
        frequency: PaymentFrequency.monthly,
      );

      final shortTermResult = LoanCalculator.calculate(
        principal: 100000,
        annualInterestRate: 5.0,
        termYears: 15,
        frequency: PaymentFrequency.monthly,
      );

      // Shorter term should have higher monthly payment
      expect(
        shortTermResult.paymentAmount,
        greaterThan(longTermResult.paymentAmount),
      );

      // Shorter term should have less total interest
      expect(
        shortTermResult.totalInterest,
        lessThan(longTermResult.totalInterest),
      );
    });

    test('validates loan amount correctly', () {
      expect(LoanCalculator.isValidLoanAmount(100000), isTrue);
      expect(LoanCalculator.isValidLoanAmount(0), isFalse);
      expect(LoanCalculator.isValidLoanAmount(-1000), isFalse);
      expect(LoanCalculator.isValidLoanAmount(null), isFalse);
    });

    test('validates interest rate correctly', () {
      expect(LoanCalculator.isValidInterestRate(5.0), isTrue);
      expect(LoanCalculator.isValidInterestRate(0.1), isTrue);
      expect(LoanCalculator.isValidInterestRate(30.0), isTrue);
      expect(LoanCalculator.isValidInterestRate(0.0), isFalse);
      expect(LoanCalculator.isValidInterestRate(31.0), isFalse);
      expect(LoanCalculator.isValidInterestRate(null), isFalse);
    });

    test('validates term correctly', () {
      expect(LoanCalculator.isValidTerm(15), isTrue);
      expect(LoanCalculator.isValidTerm(1), isTrue);
      expect(LoanCalculator.isValidTerm(30), isTrue);
      expect(LoanCalculator.isValidTerm(0), isFalse);
      expect(LoanCalculator.isValidTerm(31), isFalse);
    });

    test('throws error for invalid principal', () {
      expect(
        () => LoanCalculator.calculate(
          principal: 0,
          annualInterestRate: 5.0,
          termYears: 30,
          frequency: PaymentFrequency.monthly,
        ),
        throwsArgumentError,
      );
    });

    test('throws error for invalid interest rate', () {
      expect(
        () => LoanCalculator.calculate(
          principal: 100000,
          annualInterestRate: 0,
          termYears: 30,
          frequency: PaymentFrequency.monthly,
        ),
        throwsArgumentError,
      );
    });
  });
}
