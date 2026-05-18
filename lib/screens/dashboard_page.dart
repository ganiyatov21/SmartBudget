import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/currency_provider.dart';
import '../providers/currency_rate_provider.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_rounded;

      case 'Transport':
        return Icons.directions_car_rounded;

      case 'Shopping':
        return Icons.shopping_bag_rounded;

      case 'Bills':
        return Icons.receipt_long_rounded;

      case 'Entertainment':
        return Icons.movie_rounded;

      default:
        return Icons.attach_money_rounded;
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final transactionsAsync =
        ref.watch(transactionsProvider);

    final selectedCurrency =
        ref.watch(currencyProvider);

    final exchangeRateAsync =
        ref.watch(exchangeRateProvider);

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final backgroundColor =
        isDark
            ? const Color(0xFF061F1D)
            : const Color(0xFFF5F7FA);

    final textColor =
        isDark
            ? Colors.white
            : const Color(0xFF111827);

    final subtitleColor =
        isDark
            ? Colors.white54
            : Colors.black54;

    final transactionCardColor =
        isDark
            ? Colors.white.withValues(
              alpha: 0.07,
            )
            : Colors.white;

    final transactionBorderColor =
        isDark
            ? Colors.white.withValues(
              alpha: 0.08,
            )
            : Colors.black12;

    return Scaffold(
      backgroundColor:
          backgroundColor,

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(0xFF00D4E8),

        foregroundColor:
            Colors.black,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            22,
          ),
        ),

        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder:
                  (_) =>
                      const AddTransactionPage(),
            ),
          );
        },
      ),

      body: transactionsAsync.when(
        loading:
            () => const Center(
              child:
                  CircularProgressIndicator(),
            ),

        error:
            (error, _) => Center(
              child: Text(
                error.toString(),

                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),

        data: (transactions) {
          double totalBalance = 0;

          for (final transaction
              in transactions) {
            totalBalance +=
                transaction.amount;
          }

          return exchangeRateAsync.when(
            loading:
                () => const Center(
                  child:
                      CircularProgressIndicator(),
                ),

            error:
                (error, _) => Center(
                  child: Text(
                    error.toString(),

                    style: TextStyle(
                      color:
                          textColor,
                    ),
                  ),
                ),

            data: (rate) {
              double displayedBalance =
                  totalBalance;

              String symbol = '\$';

              if (selectedCurrency ==
                  'KZT') {
                displayedBalance *=
                    rate;

                symbol = '₸';
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight:
                        390,

                    pinned: true,

                    stretch: true,

                    centerTitle: true,

                    elevation: 0,

                    backgroundColor:
                        backgroundColor,

                    surfaceTintColor:
                        Colors.transparent,

                    title: Text(
                      'SmartBudget',

                      style: TextStyle(
                        color:
                            textColor,

                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),

                    flexibleSpace:
                        FlexibleSpaceBar(
                      background:
                          Padding(
                        padding:
                            const EdgeInsets.fromLTRB(
                              20,
                              100,
                              20,
                              24,
                            ),

                        child:
                            Container(
                          padding:
                              const EdgeInsets.all(
                                24,
                              ),

                          decoration:
                              BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(
                                  34,
                                ),

                            gradient:
                                const LinearGradient(
                                  begin:
                                      Alignment.topLeft,

                                  end:
                                      Alignment.bottomRight,

                                  colors: [
                                    Color(
                                      0xFF00D4E8,
                                    ),

                                    Color(
                                      0xFF2563EB,
                                    ),
                                  ],
                                ),

                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF00D4E8,
                                ).withValues(
                                  alpha:
                                      isDark
                                          ? 0.25
                                          : 0.18,
                                ),

                                blurRadius:
                                    28,

                                offset:
                                    const Offset(
                                      0,
                                      18,
                                    ),
                              ),
                            ],
                          ),

                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                'Total Balance',

                                style:
                                    TextStyle(
                                  color: Colors
                                      .white
                                      .withValues(
                                        alpha:
                                            0.90,
                                      ),

                                  fontSize:
                                      16,

                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                '$symbol${displayedBalance.toStringAsFixed(0)}',

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,

                                  fontSize:
                                      46,

                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
                              ),

                              const Spacer(),

                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        _InfoBox(
                                      icon:
                                          Icons.receipt_long_rounded,

                                      title:
                                          'Transactions',

                                      value:
                                          transactions
                                              .length
                                              .toString(),
                                    ),
                                  ),

                                  const SizedBox(
                                    width:
                                        14,
                                  ),

                                  Expanded(
                                    child:
                                        _InfoBox(
                                      icon:
                                          Icons.currency_exchange_rounded,

                                      title:
                                          'Currency',

                                      value:
                                          selectedCurrency,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(
                            20,
                            24,
                            20,
                            12,
                          ),

                      child: Text(
                        'Recent Transactions',

                        style: TextStyle(
                          color:
                              textColor,

                          fontSize:
                              22,

                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),
                    ),
                  ),

                  if (transactions
                      .isEmpty)
                    SliverFillRemaining(
                      hasScrollBody:
                          false,

                      child:
                          _EmptyState(
                        textColor:
                            textColor,

                        subtitleColor:
                            subtitleColor,
                      ),
                    )
                  else
                    SliverPadding(
                      padding:
                          const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            100,
                          ),

                      sliver:
                          SliverList(
                        delegate:
                            SliverChildBuilderDelegate(
                          (
                            context,
                            index,
                          ) {
                            final transaction =
                                transactions[index];

                            double amount =
                                transaction
                                    .amount;

                            String amountSymbol =
                                '\$';

                            if (selectedCurrency ==
                                'KZT') {
                              amount *=
                                  rate;

                              amountSymbol =
                                  '₸';
                            }

                            return Dismissible(
                              key: Key(
                                transaction.id
                                    .toString(),
                              ),

                              direction:
                                  DismissDirection
                                      .endToStart,

                              background:
                                  Container(
                                margin:
                                    const EdgeInsets.only(
                                      bottom:
                                          14,
                                    ),

                                padding:
                                    const EdgeInsets.only(
                                      right:
                                          24,
                                    ),

                                alignment:
                                    Alignment
                                        .centerRight,

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.redAccent,

                                  borderRadius:
                                      BorderRadius.circular(
                                        26,
                                      ),
                                ),

                                child:
                                    const Icon(
                                  Icons
                                      .delete_rounded,

                                  color:
                                      Colors
                                          .white,
                                ),
                              ),

                              confirmDismiss:
                                  (_) async {
                                final service =
                                    ref.read(
                                      transactionServiceProvider,
                                    );

                                await service
                                    .deleteTransaction(
                                      transaction.id!,
                                    );

                                ref.invalidate(
                                  transactionsProvider,
                                );

                                return true;
                              },

                              child:
                                  Container(
                                margin:
                                    const EdgeInsets.only(
                                      bottom:
                                          14,
                                    ),

                                padding:
                                    const EdgeInsets.all(
                                      18,
                                    ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      transactionCardColor,

                                  borderRadius:
                                      BorderRadius.circular(
                                        26,
                                      ),

                                  border:
                                      Border.all(
                                    color:
                                        transactionBorderColor,
                                  ),

                                  boxShadow: [
                                    if (!isDark)
                                      BoxShadow(
                                        color: Colors
                                            .black
                                            .withValues(
                                              alpha:
                                                  0.06,
                                            ),

                                        blurRadius:
                                            18,

                                        offset:
                                            const Offset(
                                              0,
                                              8,
                                            ),
                                      ),
                                  ],
                                ),

                                child:
                                    Row(
                                  children: [
                                    Container(
                                      width:
                                          54,

                                      height:
                                          54,

                                      decoration:
                                          BoxDecoration(
                                        color:
                                            isDark
                                                ? const Color(
                                                  0xFF00D4E8,
                                                ).withValues(
                                                  alpha:
                                                      0.18,
                                                )
                                                : const Color(
                                                  0xFF00AFC2,
                                                ).withValues(
                                                  alpha:
                                                      0.16,
                                                ),

                                        borderRadius:
                                            BorderRadius.circular(
                                              18,
                                            ),
                                      ),

                                      child:
                                          Icon(
                                        getCategoryIcon(
                                          transaction
                                              .category,
                                        ),

                                        color:
                                            isDark
                                                ? const Color(
                                                  0xFF00D4E8,
                                                )
                                                : const Color(
                                                  0xFF008A9A,
                                                ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width:
                                          16,
                                    ),

                                    Expanded(
                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            transaction
                                                .title,

                                            maxLines:
                                                1,

                                            overflow:
                                                TextOverflow.ellipsis,

                                            style:
                                                TextStyle(
                                              color:
                                                  textColor,

                                              fontSize:
                                                  17,

                                              fontWeight:
                                                  FontWeight.w800,
                                            ),
                                          ),

                                          const SizedBox(
                                            height:
                                                6,
                                          ),

                                          Text(
                                            transaction
                                                .category,

                                            style:
                                                TextStyle(
                                              color:
                                                  subtitleColor,

                                              fontSize:
                                                  14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      width:
                                          12,
                                    ),

                                    Text(
                                      '$amountSymbol${amount.toStringAsFixed(0)}',

                                      style:
                                          TextStyle(
                                        color:
                                            textColor,

                                        fontSize:
                                            17,

                                        fontWeight:
                                            FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },

                          childCount:
                              transactions.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;

  final String title;

  final String value;

  const _InfoBox({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
            vertical: 16,
          ),

      decoration: BoxDecoration(
        color: Colors.white
            .withValues(
              alpha: 0.16,
            ),

        borderRadius:
            BorderRadius.circular(
              22,
            ),
      ),

      child: Column(
        children: [
          Icon(
            icon,

            color: Colors.white,

            size: 24,
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            title,

            style: const TextStyle(
              color:
                  Colors.white70,

              fontSize: 13,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            value,

            style: const TextStyle(
              color:
                  Colors.white,

              fontWeight:
                  FontWeight.w800,

              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color textColor;

  final Color subtitleColor;

  const _EmptyState({
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
              28,
            ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,

          children: [
            Icon(
              Icons
                  .account_balance_wallet_outlined,

              size: 76,

              color:
                  subtitleColor,
            ),

            const SizedBox(
              height: 18,
            ),

            Text(
              'No Transactions Yet',

              style: TextStyle(
                color:
                    textColor,

                fontSize: 22,

                fontWeight:
                    FontWeight
                        .w800,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Tap + to add your first expense',

              style: TextStyle(
                color:
                    subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}