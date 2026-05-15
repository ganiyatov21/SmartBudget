import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../database/app_database.dart';

class TransactionRepositoryImpl
    implements TransactionRepository {
  final AppDatabase database;

  TransactionRepositoryImpl(this.database);

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final transactions =
        await database.getAllTransactions();

    return transactions.map((transaction) {
      return TransactionEntity(
        id: transaction.id,
        title: transaction.title,
        amount: transaction.amount,
        category: transaction.category,
        createdAt: transaction.createdAt,
      );
    }).toList();
  }

  @override
  Future<void> addTransaction(
    TransactionEntity transaction,
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

  @override
  Future<void> deleteTransaction(int id) async {
    await database.deleteTransaction(id);
  }
}