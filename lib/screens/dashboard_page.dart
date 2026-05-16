import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/currency_provider.dart';
import '../providers/currency_rate_provider.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final transactionsAsync =
        ref.watch(transactionsProvider);

    final selectedCurrency =
        ref.watch(currencyProvider);

    final exchangeRateAsync =
        ref.watch(exchangeRateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartBudget'),
      ),

      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                'No transactions yet',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: transactions.length,

            itemBuilder: (context, index) {
              final transaction =
                  transactions[index];

              return Dismissible(
                key: Key(
                  transaction.id.toString(),
                ),

                direction:
                    DismissDirection.endToStart,

                background: Container(
                  margin:
                      const EdgeInsets.only(
                    bottom: 16,
                  ),

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),

                  alignment:
                      Alignment.centerRight,

                  decoration: BoxDecoration(
                    color: Colors.red,

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),

                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),

                confirmDismiss: (_) async {
                  final service = ref.read(
                    transactionServiceProvider,
                  );

                  await service
                      .deleteTransaction(
                    transaction.id!,
                  );

                  ref.invalidate(
                    transactionsProvider,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${transaction.title} deleted',
                        ),
                      ),
                    );
                  }

                  return true;
                },

                child: Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 16,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),

                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(
                      20,
                    ),

                    title: Text(
                      transaction.title,

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 8,
                      ),

                      child: Text(
                        transaction.category,
                      ),
                    ),

                    trailing:
                        exchangeRateAsync.when(
                      data: (rate) {
                        double amount =
                            transaction.amount;

                        String symbol = '\$';

                        if (selectedCurrency ==
                            'KZT') {
                          amount *= rate;
                          symbol = '₸';
                        }

                        return Text(
                          '$symbol${amount.toStringAsFixed(0)}',

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize: 18,
                          ),
                        );
                      },

                      loading: () =>
                          const Text(
                        '...',
                      ),

                      error: (e, _) =>
                          const Text(
                        'Error',
                      ),
                    ),
                  ),
                ),
              );
            },
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

      floatingActionButton:
          FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  const AddTransactionPage(),
            ),
          );
        },
      ),
    );
  }
}