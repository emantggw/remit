import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remit/core/entity/ResponseData.dart';
import 'package:remit/core/entity/TransactionRecord.dart';
import 'package:remit/core/interfaces/iwallet.repository.dart';

class FirebaseWalletRepository implements IWalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _walletsPath = 'wallets';
  final String _exchangeRatesPath = 'exchange_rates';

  @override
  Future<ResponseData<double>> getBalance(String userId) async {
    try {
      final doc = await _firestore.collection(_walletsPath).doc(userId).get();
      if (!doc.exists) {
        return ResponseData(isSuccessful: true, data: 0.0);
      }
      final data = doc.data()!;
      final bal = (data['balance'] ?? 0).toDouble();
      return ResponseData(isSuccessful: true, data: bal);
    } catch (e) {
      return ResponseData(isSuccessful: false, errorMessages: [e.toString()]);
    }
  }

  @override
  Stream<double> balanceStream(String userId) {
    return _firestore.collection(_walletsPath).doc(userId).snapshots().map((
      snap,
    ) {
      final data = snap.data();
      if (data == null) return 0.0;
      return (data['balance'] ?? 0).toDouble();
    });
  }

  @override
  Future<ResponseData<List<TransactionRecord>>> getTransactionHistory(
    String userId, {
    int limit = 50,
    DateTime? from,
  }) async {
    try {
      var col = _firestore
          .collection(_walletsPath)
          .doc(userId)
          .collection('transactions')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (from != null) {
        col = col.startAfter([Timestamp.fromDate(from)]);
      }

      final snap = await col.get();
      final items = snap.docs.map((d) {
        final data = Map<String, dynamic>.from(d.data());
        data['id'] = d.id;
        return TransactionRecord.fromJson(data);
      }).toList();
      return ResponseData(isSuccessful: true, data: items);
    } catch (e) {
      return ResponseData(isSuccessful: false, errorMessages: [e.toString()]);
    }
  }

  @override
  Future<ResponseData> sendMoney(
    String fromUserId,
    String toUserId,
    double amount,
    String currency, {
    String? note,
  }) async {
    final fromRef = _firestore.collection(_walletsPath).doc(fromUserId);
    final toRef = _firestore.collection(_walletsPath).doc(toUserId);

    try {
      await _firestore.runTransaction((tx) async {
        final fromSnap = await tx.get(fromRef);
        final toSnap = await tx.get(toRef);

        final fromBal =
            (fromSnap.exists ? (fromSnap.data()?['balance'] ?? 0) : 0)
                .toDouble();
        final toBal = (toSnap.exists ? (toSnap.data()?['balance'] ?? 0) : 0)
            .toDouble();

        if (fromBal < amount) {
          throw Exception('Insufficient balance');
        }

        final newFrom = fromBal - amount;
        final newTo = toBal + amount;

        tx.set(fromRef, {'balance': newFrom}, SetOptions(merge: true));
        tx.set(toRef, {'balance': newTo}, SetOptions(merge: true));

        final now = DateTime.now();
        final fromTxRef = fromRef.collection('transactions').doc();
        final toTxRef = toRef.collection('transactions').doc();

        tx.set(fromTxRef, {
          'fromUserId': fromUserId,
          'toUserId': toUserId,
          'amount': amount,
          'currency': currency,
          'timestamp': Timestamp.fromDate(now),
          'note': note,
          'type': 'sent',
        });

        tx.set(toTxRef, {
          'fromUserId': fromUserId,
          'toUserId': toUserId,
          'amount': amount,
          'currency': currency,
          'timestamp': Timestamp.fromDate(now),
          'note': note,
          'type': 'received',
        });
      });

      return ResponseData(isSuccessful: true);
    } catch (e) {
      return ResponseData(isSuccessful: false, errorMessages: [e.toString()]);
    }
  }

  @override
  Future<ResponseData<double>> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    try {
      if (fromCurrency.toUpperCase() == toCurrency.toUpperCase()) {
        return ResponseData(isSuccessful: true, data: 1.0);
      }

      // Try reading exchange rate document: exchange_rates/{from}_{to}
      final pairId =
          '${fromCurrency.toUpperCase()}_${toCurrency.toUpperCase()}';
      final doc = await _firestore
          .collection(_exchangeRatesPath)
          .doc(pairId)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        final rate = (data['rate'] ?? 0).toDouble();
        return ResponseData(isSuccessful: true, data: rate);
      }

      // Fallback: simple hardcoded common rates (for disconnected/demo use)
      const fallback = {
        'USD_EUR': 0.92,
        'EUR_USD': 1.09,
        'USD_GHS': 12.0,
        'GHS_USD': 0.083,
      };

      final fallbackRate = fallback[pairId];
      if (fallbackRate != null) {
        return ResponseData(isSuccessful: true, data: fallbackRate);
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
