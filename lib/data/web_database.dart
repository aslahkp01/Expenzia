import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'expense_database.dart';

ExpenseDatabase createAppDatabase() => ExpenseDatabase(
  factory: databaseFactoryFfiWeb,
  databasePath: 'expenzia.db',
);
