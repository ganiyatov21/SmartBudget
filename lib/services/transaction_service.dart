import '../database/app_database.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final AppDatabase database;

  TransactionService(this.database);

  Future<List<TransactionModel>>
      getTransactions() async {
    final data =
        await database.getAllTransactions();

    return data.map((transaction) {
      return TransactionModel(
        id: transaction.id,
        title: transaction.title,
        amount: transaction.amount,
        category: transaction.category,
        createdAt: transaction.createdAt,
      );
    }).toList();
  }

  Future<void> addTransaction(
    TransactionModel transaction,
  ) async {
    await database.insertTransaction(
      TransactionsCompanion.insert(
        title: transaction.title,
        amount: transaction.amount,
        category: transaction.category,
        createdAt: transaction.createdAt,
      ),
    );
  }

  Future<void> deleteTransaction(int id) async {
    await database.deleteTransaction(id);
  }
}