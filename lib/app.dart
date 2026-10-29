import 'dart:async';
import 'package:flutter/material.dart';

import 'controllers/expense_controller.dart';
import 'controllers/profile_controller.dart';
import 'data/expense_database.dart';
import 'data/platform_database.dart';
import 'data/profile_database.dart';
import 'screens/intro_flow.dart';
import 'theme/app_theme.dart';

class ExpenziaApp extends StatefulWidget {
  const ExpenziaApp({super.key, this.database});
  final ExpenseDatabase? database;

  @override
  State<ExpenziaApp> createState() => _ExpenziaAppState();
}

class _ExpenziaAppState extends State<ExpenziaApp> {
  late final ExpenseDatabase _database;
  late final ExpenseController _expenses;
  late final ProfileController _profile;

  @override
  void initState() {
    super.initState();
    _database = widget.database ?? createAppDatabase();
    _expenses = ExpenseController(_database)..load();
    _profile = ProfileController(ProfileDatabase(_database))..load();
  }

  @override
  void dispose() {
    _expenses.dispose();
    _profile.dispose();
    unawaited(
      _database.close().catchError((Object error, StackTrace stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'Expenzia database shutdown',
          ),
        );
      }),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Expenzia',
    debugShowCheckedModeBanner: false,
    theme: appTheme(),
    builder: (context, child) => ColoredBox(
      color: const Color(0xFF101B1A),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: child!,
        ),
      ),
    ),
    home: IntroFlow(controller: _expenses, profile: _profile),
  );
}
