import 'package:remit/core/entity/ExchangeRate.dart';
import 'package:remit/core/entity/ResponseData.dart';

abstract class IExchangeRatesRepository {
  /// Get a list of available exchange rates
  Future<ResponseData<List<ExchangeRate>>> getExchangeRates();
}
