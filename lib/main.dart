import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SmartBudgetApp(),
    ),
  );
}

class SmartBudgetApp extends StatelessWidget {
  const SmartBudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SmartBudget',
      routerConfig: appRouter,
    );
  }
}