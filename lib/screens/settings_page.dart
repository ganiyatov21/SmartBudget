import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../providers/currency_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final themeMode =
        ref.watch(themeProvider);

    final isDark =
        themeMode == ThemeMode.dark;

    final selectedCurrency =
        ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(
              'Dark Mode',
            ),

            subtitle: const Text(
              'Enable dark theme',
            ),

            value: isDark,

            onChanged: (value) {
              ref
                  .read(
                    themeProvider.notifier,
                  )
                  .toggleTheme(value);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.currency_exchange,
            ),

            title: const Text(
              'Currency',
            ),

            subtitle: Text(
              selectedCurrency,
            ),

            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),

            onTap: () {
              showDialog(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Select Currency',
                    ),

                    content: Column(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [
                        ListTile(
                          title: const Text(
                            'USD',
                          ),

                          onTap: () {
                            ref
                                .read(
                                  currencyProvider
                                      .notifier,
                                )
                                .state = 'USD';

                            Navigator.pop(
                              context,
                            );
                          },
                        ),

                        ListTile(
                          title: const Text(
                            'KZT',
                          ),

                          onTap: () {
                            ref
                                .read(
                                  currencyProvider
                                      .notifier,
                                )
                                .state = 'KZT';

                            Navigator.pop(
                              context,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.info_outline,
            ),

            title: const Text(
              'About App',
            ),

            subtitle: const Text(
              'SmartBudget v1.0',
            ),
          ),
        ],
      ),
    );
  }
}