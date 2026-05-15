import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import 'add_transaction_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartBudget'),
      ),
      body: transactions.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text(
                'No transactions yet',
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final transaction = data[index];

              return Card(
                child: ListTile(
                  title: Text(transaction.title),
                  subtitle: Text(
                    transaction.category,
                  ),
                  trailing: Text(
                    '\$${transaction.amount}',
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
            child: Text(error.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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