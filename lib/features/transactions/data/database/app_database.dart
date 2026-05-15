import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  RealColumn get amount => real()();

  TextColumn get category => text()();

  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Transaction>> getAllTransactions() {
    return select(transactions).get();
  }

  Future<int> insertTransaction(
    TransactionsCompanion transaction,
  ) {
    return into(transactions).insert(transaction);
  }

  Future<void> deleteTransaction(int id) {
    return (delete(transactions)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(dbFolder.path, 'smart_budget.sqlite'),
    );

    return NativeDatabase(file);
  });
}