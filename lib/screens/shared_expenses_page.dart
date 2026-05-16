import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SharedExpensesPage
    extends StatefulWidget {
  const SharedExpensesPage({
    super.key,
  });

  @override
  State<SharedExpensesPage>
  createState() =>
      _SharedExpensesPageState();
}

class _SharedExpensesPageState
    extends State<
      SharedExpensesPage
    > {
  final titleController =
      TextEditingController();

  final amountController =
      TextEditingController();

  final expenses =
      FirebaseFirestore.instance
          .collection(
            'shared_expenses',
          );

  Future<void> addExpense() async {
    await expenses.add({
      'title':
          titleController.text,

      'amount': double.parse(
        amountController.text,
      ),

      'createdAt':
          Timestamp.now(),
    });

    titleController.clear();
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shared Expenses',
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(
              16,
            ),

            child: Column(
              children: [
                TextField(
                  controller:
                      titleController,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Title',
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                TextField(
                  controller:
                      amountController,

                  keyboardType:
                      TextInputType
                          .number,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Amount',
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                ElevatedButton(
                  onPressed:
                      addExpense,

                  child: const Text(
                    'Add Shared Expense',
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<
              QuerySnapshot
            >(
              stream:
                  expenses
                      .orderBy(
                        'createdAt',
                        descending:
                            true,
                      )
                      .snapshots(),

              builder:
                  (
                    context,
                    snapshot,
                  ) {
                    if (!snapshot
                        .hasData) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    final docs =
                        snapshot
                            .data!
                            .docs;

                    return ListView.builder(
                      itemCount:
                          docs.length,

                      itemBuilder:
                          (
                            context,
                            index,
                          ) {
                            final data =
                                docs[index];

                            return ListTile(
                              title: Text(
                                data['title'],
                              ),

                              trailing:
                                  Text(
                                '\$${data['amount']}',
                              ),
                            );
                          },
                    );
                  },
            ),
          ),
        ],
      ),
    );
  }
}