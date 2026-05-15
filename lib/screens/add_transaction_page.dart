import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionPage
    extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState
    extends ConsumerState<AddTransactionPage> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  final categoryController = TextEditingController();

  Future<void> saveTransaction() async {
    final service =
        ref.read(transactionServiceProvider);

    final transaction = TransactionModel(
      title: titleController.text,
      amount: double.parse(
        amountController.text,
      ),
      category: categoryController.text,
      createdAt: DateTime.now(),
    );

    await service.addTransaction(transaction);

    ref.invalidate(transactionsProvider);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType:
                  TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveTransaction,
              child: const Text(
                'Save Transaction',
              ),
            ),
          ],
        ),
      ),
    );
  }
}