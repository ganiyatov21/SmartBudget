import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/currency_provider.dart';
import '../providers/currency_rate_provider.dart';

class SharedExpensesPage extends ConsumerStatefulWidget {
  const SharedExpensesPage({super.key});

  @override
  ConsumerState<SharedExpensesPage> createState() => _SharedExpensesPageState();
}

class _SharedExpensesPageState extends ConsumerState<SharedExpensesPage> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  String selectedCurrency = 'USD';

  final expensesCollection = FirebaseFirestore.instance.collection(
    'shared_expenses',
  );

  @override
  Widget build(BuildContext context) {
    final globalCurrency = ref.watch(currencyProvider);

    final exchangeRateAsync = ref.watch(exchangeRateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shared Expenses')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: titleController,

              decoration: const InputDecoration(hintText: 'Title'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: amountController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(hintText: 'Amount'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCurrency,

              decoration: const InputDecoration(labelText: 'Currency'),

              items: const [
                DropdownMenuItem(value: 'USD', child: Text('USD')),

                DropdownMenuItem(value: 'KZT', child: Text('KZT')),
              ],

              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                double amount = double.parse(amountController.text);

                final rate = exchangeRateAsync.value ?? 1;

                if (selectedCurrency == 'KZT') {
                  amount = amount / rate;
                }

                await expensesCollection.add({
                  'title': titleController.text,

                  'amount': amount,

                  'createdAt': Timestamp.now(),
                });

                titleController.clear();
                amountController.clear();
              },

              child: const Text('Add Shared Expense'),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: expensesCollection
                    .orderBy('createdAt', descending: true)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No shared expenses'));
                  }

                  final expenses = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: expenses.length,

                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      final docId =
                          expense.id; // 👈 Получаем ID документа из Firebase
                      final data = expense.data() as Map<String, dynamic>;

                      return Dismissible(
                        key: Key(docId), // Уникальный ключ для Flutter
                        direction:
                            DismissDirection.endToStart, // Свайп справа налево
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(
                              24,
                            ), // Чтобы подходило под форму Card
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        // 💥 Сама логика удаления из Firebase
                        onDismissed: (direction) async {
                          await expensesCollection.doc(docId).delete();

                          // Показывать уведомление об удалении (по желанию)
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('"${data['title']}" deleted'),
                              ),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(20),
                            title: Text(
                              data['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            trailing: exchangeRateAsync.when(
                              data: (rate) {
                                double amount = data['amount'];
                                String symbol = '\$';

                                if (globalCurrency == 'KZT') {
                                  amount *= rate;
                                  symbol = '₸';
                                }

                                return Text(
                                  '$symbol${amount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                );
                              },
                              loading: () => const Text('...'),
                              error: (e, _) => const Text('Error'),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
