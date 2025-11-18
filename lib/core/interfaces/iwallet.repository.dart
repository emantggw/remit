import 'package:remit/core/entity/ResponseData.dart';
import 'package:remit/core/entity/TransactionRecord.dart';

abstract class IWalletRepository {
  /// Get current wallet balance for a user. Returns ResponseData with a double value.
  Future<ResponseData<double>> getBalance(String userId);

  /// Stream of balance updates for the user (optional realtime updates)
  Stream<double> balanceStream(String userId);

  /// Fetch transaction history for the user. Returns list ordered by timestamp desc.
  Future<ResponseData<List<TransactionRecord>>> getTransactionHistory(
    String userId, {
    int limit = 50,
    DateTime? from,
  });

  /// Send money from one user to another. Currency is a 3-letter code.
  /// Returns ResponseData indicating success/failure.
  Future<ResponseData> sendMoney(
    String fromUserId,
    String toUserId,
    double amount,
    String currency, {
    String? note,
  });

  /// Get exchange rate for converting fromCurrency -> toCurrency.
  /// Returns ResponseData with rate (double).
  Future<ResponseData<double>> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  );
}
