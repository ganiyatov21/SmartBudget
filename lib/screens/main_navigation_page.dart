import 'package:flutter/material.dart';

import 'analytics_page.dart';
import 'dashboard_page.dart';
import 'settings_page.dart';
import 'shared_expenses_page.dart';

class MainNavigationPage
    extends StatefulWidget {
  const MainNavigationPage({
    super.key,
  });

  @override
  State<MainNavigationPage>
  createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState
    extends State<
      MainNavigationPage
    > {
  int currentIndex = 0;

  final pages = const [
    DashboardPage(),
    AnalyticsPage(),
    SharedExpensesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Shared',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}