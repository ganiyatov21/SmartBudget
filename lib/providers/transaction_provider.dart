import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

final databaseProvider = Provider<AppDatabase>(
  (ref) {
    return AppDatabase();
  },
);

final transactionServiceProvider =
    Provider<TransactionService>((ref) {
  final database = ref.watch(databaseProvider);

  return TransactionService(database);
});

final transactionsProvider =
    FutureProvider<List<TransactionModel>>(
  (ref) async {
    final service =
        ref.watch(transactionServiceProvider);

    return service.getTransactions();
  },
);