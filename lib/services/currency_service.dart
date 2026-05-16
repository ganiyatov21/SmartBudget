import 'package:chopper/chopper.dart';

part 'currency_service.chopper.dart';

@ChopperApi()
abstract class CurrencyService
    extends ChopperService {
  @GET(path: '/latest/USD')
  Future<Response<dynamic>> getRates();

  static CurrencyService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse(
        'https://open.er-api.com/v6',
      ),

      services: [
        _$CurrencyService(),
      ],

      converter: const JsonConverter(),
    );

    return _$CurrencyService(client);
  }
}