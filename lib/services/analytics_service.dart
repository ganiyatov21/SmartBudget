import '../models/transaction_model.dart';

class AnalyticsService {
  static Map<String, double>
  calculateCategoryTotals(
    List<TransactionModel> transactions,
  ) {
    final Map<String, double> totals = {};

    for (final transaction
        in transactions) {
      final category =
          transaction.category;

      totals[category] =
          (totals[category] ?? 0) +
              transaction.amount;
    }

    return totals;
  }

  static double calculateTotalExpenses(
    List<TransactionModel> transactions,
  ) {
    double total = 0;

    for (final transaction
        in transactions) {
      total += transaction.amount;
    }

    return total;
  }

  static String getTopCategory(
    List<TransactionModel> transactions,
  ) {
    final totals =
        calculateCategoryTotals(
      transactions,
    );

    if (totals.isEmpty) {
      return 'No Data';
    }

    return totals.entries
        .reduce(
          (a, b) =>
              a.value > b.value
                  ? a
                  : b,
        )
        .key;
  }
}