import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../services/analytics_service.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final transactionsAsync =
        ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),

      body: transactionsAsync.when(
        data: (transactions) {
          final categoryTotals =
              AnalyticsService
                  .calculateCategoryTotals(
            transactions,
          );

          final totalExpenses =
              AnalyticsService
                  .calculateTotalExpenses(
            transactions,
          );

          final topCategory =
              AnalyticsService.getTopCategory(
            transactions,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Expenses by Category',

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding:
                      const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    color:
                        Theme.of(context)
                            .cardColor,
                  ),

                  child: SizedBox(
                    height: 300,

                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,

                        centerSpaceRadius:
                            60,

                        sections:
                            categoryTotals
                                .entries
                                .map(
                          (entry) {
                            Color sectionColor;

                            switch (
                              entry.key
                                  .toLowerCase()
                            ) {
                              case 'food':
                                sectionColor =
                                    Colors.orange;
                                break;

                              case 'car':
                                sectionColor =
                                    Colors.blue;
                                break;

                              case 'shopping':
                                sectionColor =
                                    Colors.purple;
                                break;

                              case 'phone':
                                sectionColor =
                                    Colors.green;
                                break;

                              default:
                                sectionColor =
                                    Colors.cyan;
                            }

                            return PieChartSectionData(
                              value:
                                  entry.value,

                              title:
                                  entry.key,

                              radius: 70,

                              color:
                                  sectionColor,

                              titleStyle:
                                  const TextStyle(
                                color:
                                    Colors.black,
                                fontWeight:
                                    FontWeight
                                        .bold,
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
                        padding:
                            const EdgeInsets.all(
                          20,
                        ),

                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),

                          color:
                              Theme.of(context)
                                  .cardColor,
                        ),

                        child: Column(
                          children: [
                            Text(
                              '\$${totalExpenses.toStringAsFixed(0)}',

                              style:
                                  const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            const Text(
                              'Total Expenses',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          20,
                        ),

                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),

                          color:
                              Theme.of(context)
                                  .cardColor,
                        ),

                        child: Column(
                          children: [
                            Text(
                              topCategory,

                              style:
                                  const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            const Text(
                              'Top Category',
                            ),
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

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stackTrace) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
      ),
    );
  }
}