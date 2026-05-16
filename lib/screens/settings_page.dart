import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    final isDark =
        themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text(
              'Enable dark theme',
            ),
            value: isDark,
            onChanged: (value) {
              ref
                  .read(themeProvider.notifier)
                  .toggleTheme(value);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency'),
            subtitle: const Text('USD'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            subtitle: const Text(
              'SmartBudget v1.0',
            ),
          ),
        ],
      ),
    );
  }
}