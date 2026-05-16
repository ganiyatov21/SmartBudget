import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/currency_service.dart';

final currencyServiceProvider =
    Provider<CurrencyService>((ref) {
  return CurrencyService.create();
});

final exchangeRateProvider =
    FutureProvider<double>((ref) async {
  final service =
      ref.watch(currencyServiceProvider);

  final response =
      await service.getRates();

  return response.body['rates']['KZT']
      .toDouble();
});