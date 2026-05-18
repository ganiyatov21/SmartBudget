import 'package:go_router/go_router.dart';

import '../screens/add_transaction_page.dart';
import '../screens/analytics_page.dart';
import '../screens/dashboard_page.dart';
import '../screens/main_navigation_page.dart';
import '../screens/settings_page.dart';
import '../screens/shared_expenses_page.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationPage(
          child: child,
        );
      },

      routes: [
        GoRoute(
          path: '/dashboard',

          builder: (context, state) {
            return const DashboardPage();
          },

          routes: [
            GoRoute(
              path: 'add',

              builder: (context, state) {
                return const AddTransactionPage();
              },
            ),
          ],
        ),

        GoRoute(
          path: '/analytics',

          builder: (context, state) {
            return const AnalyticsPage();
          },
        ),

        GoRoute(
          path: '/shared',

          builder: (context, state) {
            return const SharedExpensesPage();
          },
        ),

        GoRoute(
          path: '/settings',

          builder: (context, state) {
            return const SettingsPage();
          },
        ),
      ],
    ),
  ],
);