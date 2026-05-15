import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final transactionRepositoryProvider =
    Provider<TransactionRepositoryImpl>((ref) {
  final database = ref.watch(databaseProvider);

  return TransactionRepositoryImpl(database);
});

final transactionsProvider =
    FutureProvider<List<TransactionEntity>>((ref) async {
  final repository =
      ref.watch(transactionRepositoryProvider);

  return repository.getTransactions();
});