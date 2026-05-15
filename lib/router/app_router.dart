import 'package:go_router/go_router.dart';

import '../screens/main_navigation_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const MainNavigationPage(),
    ),
  ],
);