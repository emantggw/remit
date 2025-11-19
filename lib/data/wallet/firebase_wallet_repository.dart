import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:remit/core/entity/ResponseData.dart';
import 'package:remit/core/entity/TransactionRecord.dart';
import 'package:remit/core/entity/UserAccount.dart';
import 'package:remit/core/interfaces/iwallet.repository.dart';
import 'package:remit/presentation/_common/app_colors.dart';

class FirebaseWalletRepository implements IWalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _walletsPath = 'wallets';
  final String _usersPath = "users";

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
    String toUserEmail,
    double amount,
    String currency, {
    String? note,
  }) async {
    try {
      String toUserId = "";
      ResponseData<UserAccount?> toUserAccountRes = await findUserByEmail(
        toUserEmail,
      );
      if (!toUserAccountRes.isSuccessful || toUserAccountRes.data == null) {
        return ResponseData(
          isSuccessful: false,
          errorMessages: ['User is not found by given email.'],
        );
      }
      toUserId = toUserAccountRes.data?.uid ?? "";

      final fromRef = _firestore.collection(_walletsPath).doc(fromUserId);
      final toRef = _firestore.collection(_walletsPath).doc(toUserId);

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
  Future<ResponseData> mint(String userId, double mintAmount) async {
    try {
      await _firestore.collection(_walletsPath).doc(userId).set({
        "balance": mintAmount,
      });
      Fluttertoast.showToast(
        msg: "You've got $mintAmount",
        backgroundColor: kcGreen,
      );
      return ResponseData(isSuccessful: true);
    } catch (e) {
      //
    }
    return ResponseData(isSuccessful: false);
  }

  @override
  Future<ResponseData<UserAccount?>> findUserByEmail(String email) async {
    try {
      var res = await _firestore
          .collection(_usersPath)
          .where("email", isEqualTo: email)
          .get();
      if (res.docs.isNotEmpty) {
        dynamic data = res.docs.first.data();
        UserAccount account = UserAccount.fromJson(data);
        return ResponseData(isSuccessful: true, data: account);
      }
    } catch (e) {
      //
    }
    return ResponseData(isSuccessful: false);
  }
}
