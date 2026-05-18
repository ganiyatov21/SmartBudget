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

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
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
                      size: 84,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 18),

                    Text(
                      'No Analytics Yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Add transactions to see your spending analytics',
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
                  AnalyticsService.calculateCategoryTotals(
                transactions,
              );

              final convertedCategoryTotals =
                  categoryTotals.map((category, amount) {
                if (selectedCurrency == 'KZT') {
                  return MapEntry(category, amount * rate);
                }

                return MapEntry(category, amount);
              });

              double totalExpenses =
                  AnalyticsService.calculateTotalExpenses(
                transactions,
              );

              String symbol = '\$';

              if (selectedCurrency == 'KZT') {
                totalExpenses *= rate;
                symbol = '₸';
              }

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
                    Container(
                      padding: const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(32),

                        gradient:
                            const LinearGradient(
                          begin: Alignment.topLeft,
                          end:
                              Alignment.bottomRight,

                          colors: [
                            Color(0xFF00D4E8),
                            Color(0xFF2563EB),
                          ],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00D4E8,
                            ).withValues(
                              alpha: 0.20,
                            ),

                            blurRadius: 24,

                            offset: const Offset(
                              0,
                              14,
                            ),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Total Expenses',

                            style: TextStyle(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.90,
                              ),

                              fontSize: 16,

                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            '$symbol${totalExpenses.toStringAsFixed(0)}',

                            style:
                                const TextStyle(
                              color: Colors.white,

                              fontSize: 42,

                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),

                          const SizedBox(
                            height: 26,
                          ),

                          Container(
                            padding:
                                const EdgeInsets.all(
                              18,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.16,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                22,
                              ),
                            ),

                            child: Row(
                              children: [
                                const Icon(
                                  Icons
                                      .trending_up_rounded,

                                  color:
                                      Colors.white,
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [
                                      const Text(
                                        'Top Category',

                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white70,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 4,
                                      ),

                                      Text(
                                        topCategory,

                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .white,

                                          fontSize:
                                              18,

                                          fontWeight:
                                              FontWeight
                                                  .w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Expenses by Category',

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding:
                          const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),

                        color:
                            Theme.of(context)
                                .cardColor,

                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white10
                                  : Colors.black12,
                        ),

                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black
                                  .withValues(
                                alpha: 0.05,
                              ),

                              blurRadius: 18,

                              offset:
                                  const Offset(
                                0,
                                10,
                              ),
                            ),
                        ],
                      ),

                      child: SizedBox(
                        height: 320,

                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 5,

                            centerSpaceRadius:
                                68,

                            sections:
                                convertedCategoryTotals
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

                                  case 'transport':
                                  case 'car':
                                    sectionColor =
                                        Colors.blue;
                                    break;

                                  case 'shopping':
                                    sectionColor =
                                        Colors.purple;
                                    break;

                                  case 'bills':
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

                                  radius: 78,

                                  color:
                                      sectionColor,

                                  titleStyle:
                                      const TextStyle(
                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    fontSize:
                                        13,
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
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