import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction_model.dart';
import '../providers/currency_rate_provider.dart';
import '../providers/transaction_provider.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String selectedCurrency = 'USD';

  final categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
  ];

  String selectedCategory = 'Food';

  @override
  Widget build(BuildContext context) {
    final exchangeRateAsync = ref.watch(exchangeRateProvider);

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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),

            const SizedBox(height: 16),

            // ✅ ONLY ONE CATEGORY WIDGET
            DropdownMenu<String>(
              initialSelection: selectedCategory,
              width: double.infinity,
              label: const Text('Category'),
              dropdownMenuEntries: categories.map((category) {
                return DropdownMenuEntry(
                  value: category,
                  label: category,
                );
              }).toList(),
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCurrency,
              decoration: const InputDecoration(
                labelText: 'Currency',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'USD',
                  child: Text('USD'),
                ),
                DropdownMenuItem(
                  value: 'KZT',
                  child: Text('KZT'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                });
              },
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async {
                final service = ref.read(transactionServiceProvider);

                if (titleController.text.isEmpty ||
                    amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                    ),
                  );
                  return;
                }

                double amount = double.parse(amountController.text);

                final rate = exchangeRateAsync.value ?? 1;

                if (selectedCurrency == 'KZT') {
                  amount = amount / rate;
                }

                await service.addTransaction(
                  TransactionModel(
                    id: null,
                    title: titleController.text,
                    amount: amount,
                    category: selectedCategory,
                    createdAt: DateTime.now(),
                  ),
                );

                ref.invalidate(transactionsProvider);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}