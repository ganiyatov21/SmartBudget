import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/currency_provider.dart';
import '../providers/currency_rate_provider.dart';
import '../providers/transaction_provider.dart';
import '../services/analytics_service.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final selectedCurrency = ref.watch(currencyProvider);
    final exchangeRateAsync = ref.watch(exchangeRateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pie_chart_outline_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Analytics Yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add transactions to see your spending chart',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return exchangeRateAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Center(
              child: Text(error.toString()),
            ),
            data: (rate) {
              final categoryTotals =
                  AnalyticsService.calculateCategoryTotals(transactions);

              final convertedCategoryTotals =
                  categoryTotals.map((category, amount) {
                if (selectedCurrency == 'KZT') {
                  return MapEntry(category, amount * rate);
                }

                return MapEntry(category, amount);
              });

              double totalExpenses =
                  AnalyticsService.calculateTotalExpenses(transactions);

              String symbol = '\$';

              if (selectedCurrency == 'KZT') {
                totalExpenses *= rate;
                symbol = '₸';
              }

              final topCategory =
                  AnalyticsService.getTopCategory(transactions);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expenses by Category',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Theme.of(context).cardColor,
                      ),
                      child: SizedBox(
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 60,
                            sections: convertedCategoryTotals.entries.map(
                              (entry) {
                                Color sectionColor;

                                switch (entry.key.toLowerCase()) {
                                  case 'food':
                                    sectionColor = Colors.orange;
                                    break;
                                  case 'transport':
                                  case 'car':
                                    sectionColor = Colors.blue;
                                    break;
                                  case 'shopping':
                                    sectionColor = Colors.purple;
                                    break;
                                  case 'bills':
                                  case 'phone':
                                    sectionColor = Colors.green;
                                    break;
                                  default:
                                    sectionColor = Colors.cyan;
                                }

                                return PieChartSectionData(
                                  value: entry.value,
                                  title: entry.key,
                                  radius: 70,
                                  color: sectionColor,
                                  titleStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$symbol${totalExpenses.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('Total Expenses'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  topCategory,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('Top Category'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}