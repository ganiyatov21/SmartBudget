import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();

  Future<void> addTransaction(
    TransactionEntity transaction,
  );

  Future<void> deleteTransaction(int id);
}