import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remit/core/entity/ExchangeRate.dart';
import 'package:remit/core/entity/ResponseData.dart';
import 'package:remit/core/interfaces/iexchange_rates.repository.dart';

class ExchangeRateRepository implements IExchangeRatesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _exchangeRatesPath = 'exchange_rates';
  @override
  Future<ResponseData<List<ExchangeRate>>> getExchangeRates() async {
    try {
      final res = await _firestore.collection(_exchangeRatesPath).get();
      List<ExchangeRate> exchangeRates = [];
      if (res.docs.isNotEmpty) {
        for (var d in res.docs) {
          dynamic data = d.data();
          List<String> pairs = d.id.split("_");
          if (pairs.isEmpty || pairs.length < 2) {
            continue;
          }

          exchangeRates.add(
            ExchangeRate(
              from: pairs[0],
              to: pairs[1],
              rate: double.tryParse(data["rate"].toString()) ?? 0.0,
            ),
          );
        }
        return ResponseData(isSuccessful: true, data: exchangeRates);
      }

      return ResponseData(
        isSuccessful: false,
        errorMessages: ['Rate not available'],
      );
    } catch (e) {
      return ResponseData(isSuccessful: false, errorMessages: [e.toString()]);
    }
  }
}
