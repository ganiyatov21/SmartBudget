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
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty) {
      return;
    }

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

  Future<void> deleteExpense(
    String id,
  ) async {
    await expenses.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

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
                      InputDecoration(
                    labelText:
                        'Title',

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
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
                      InputDecoration(
                    labelText:
                        'Amount',

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed:
                        addExpense,

                    child: const Text(
                      'Add Shared Expense',
                    ),
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
                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot
                        .hasData) {
                      return const Center(
                        child: Text(
                          'No shared expenses',
                        ),
                      );
                    }

                    final docs =
                        snapshot
                            .data!
                            .docs;

                    return ListView.builder(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      itemCount:
                          docs.length,

                      itemBuilder:
                          (
                            context,
                            index,
                          ) {
                            final doc =
                                docs[index];

                            final data =
                                doc.data()
                                    as Map<
                                      String,
                                      dynamic
                                    >;

                            return Dismissible(
                              key: Key(
                                doc.id,
                              ),

                              direction:
                                  DismissDirection
                                      .endToStart,

                              background:
                                  Container(
                                alignment:
                                    Alignment
                                        .centerRight,

                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal:
                                      24,
                                ),

                                margin:
                                    const EdgeInsets.only(
                                  bottom:
                                      16,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors
                                          .red,

                                  borderRadius:
                                      BorderRadius.circular(
                                    24,
                                  ),
                                ),

                                child:
                                    const Icon(
                                  Icons.delete,
                                  color:
                                      Colors
                                          .white,
                                ),
                              ),

                              onDismissed:
                                  (_) async {
                                await deleteExpense(
                                  doc.id,
                                );
                              },

                              child: Card(
                                color:
                                    Theme.of(
                                      context,
                                    ).cardColor,

                                elevation: 4,

                                shadowColor:
                                    Colors.black54,

                                margin:
                                    const EdgeInsets.only(
                                  bottom:
                                      16,
                                ),

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    24,
                                  ),

                                  side: BorderSide(
                                    color:
                                        Theme.of(context)
                                                    .brightness ==
                                                Brightness
                                                    .dark
                                            ? Colors
                                                .white10
                                            : Colors
                                                .black12,

                                    width: 1.2,
                                  ),
                                ),

                                child:
                                    ListTile(
                                  contentPadding:
                                      const EdgeInsets.all(
                                    20,
                                  ),

                                  title: Text(
                                    data['title'],

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,

                                      fontSize:
                                          18,
                                    ),
                                  ),

                                  trailing:
                                      Text(
                                    '\$${data['amount']}',

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,

                                      fontSize:
                                          18,
                                    ),
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
    );
  }
}