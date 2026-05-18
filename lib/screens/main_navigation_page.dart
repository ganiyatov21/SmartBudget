import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationPage
    extends StatelessWidget {
  final Widget child;

  const MainNavigationPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final location =
        GoRouterState.of(context)
            .uri
            .toString();

    int currentIndex = 0;

    if (location.startsWith(
      '/analytics',
    )) {
      currentIndex = 1;
    } else if (location.startsWith(
      '/shared',
    )) {
      currentIndex = 2;
    } else if (location.startsWith(
      '/settings',
    )) {
      currentIndex = 3;
    }

    return Scaffold(
      body: child,

      bottomNavigationBar:
          NavigationBar(
        selectedIndex:
            currentIndex,

        backgroundColor:
            Theme.of(context)
                .scaffoldBackgroundColor,

        indicatorColor:
            Colors.transparent,

        labelBehavior:
            NavigationDestinationLabelBehavior
                .onlyShowSelected,

        onDestinationSelected:
            (index) {
              switch (index) {
                case 0:
                  context.go(
                    '/dashboard',
                  );
                  break;

                case 1:
                  context.go(
                    '/analytics',
                  );
                  break;

                case 2:
                  context.go(
                    '/shared',
                  );
                  break;

                case 3:
                  context.go(
                    '/settings',
                  );
                  break;
              }
            },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home,
            ),

            selectedIcon: Icon(
              Icons.home,
            ),

            label:
                'Dashboard',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.bar_chart,
            ),

            selectedIcon: Icon(
              Icons.bar_chart,
            ),

            label:
                'Analytics',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.group,
            ),

            selectedIcon: Icon(
              Icons.group,
            ),

            label:
                'Shared',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.settings,
            ),

            selectedIcon: Icon(
              Icons.settings,
            ),

            label:
                'Settings',
          ),
        ],
      ),
    );
  }
}