import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: SmartBudgetApp()));
}

class SmartBudgetApp extends ConsumerWidget {
  const SmartBudgetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SmartBudget',
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routerConfig: appRouter,
    );
  }
}
