import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: SmartBudgetApp(),
    ),
  );
}

class SmartBudgetApp
    extends ConsumerWidget {
  const SmartBudgetApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final themeMode =
        ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner:
          false,

      title: 'SmartBudget',

      routerConfig: appRouter,

      themeMode: themeMode,

      theme: ThemeData(
        brightness: Brightness.light,

        colorSchemeSeed:
            Colors.cyan,

        useMaterial3: true,

        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          selectedItemColor:
              Colors.black,

          unselectedItemColor:
              Colors.grey,

          backgroundColor:
              Colors.white,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,

        colorSchemeSeed:
            Colors.cyan,

        useMaterial3: true,

        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          selectedItemColor:
              Colors.cyan,

          unselectedItemColor:
              Colors.grey,

          backgroundColor:
              Colors.black,
        ),
      ),
    );
  }
}