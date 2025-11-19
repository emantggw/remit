import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:remit/core/entity/ResponseData.dart';
import 'package:remit/core/entity/TransactionRecord.dart';
import 'package:remit/core/interfaces/iwallet.repository.dart';
import 'package:remit/data/wallet/firebase_wallet_repository.dart';

class WalletState {
  final bool isLoading;
  final String? error;
  final List<TransactionRecord> transactions;

  WalletState({
    this.isLoading = false,
    this.error,
    this.transactions = const [],
  });

  WalletState copyWith({
    bool? isLoading,
    String? error,
    List<TransactionRecord>? transactions,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      transactions: transactions ?? this.transactions,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  final IWalletRepository _repo;

  WalletNotifier(IWalletRepository repo) : _repo = repo, super(WalletState()) {
    //
  }

  Future<void> getTransactions(String userId) async {
    List<TransactionRecord> records = [];
    String? err;
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        transactions: records,
      );
      var res = await _repo.getTransactionHistory(userId);

      if (res.isSuccessful) {
        records = res.data ?? [];
      } else {
        err = res.errorMessages.join("\n");
      }
    } catch (e) {
      //
    } finally {
      state = state.copyWith(
        isLoading: false,
        error: err,
        transactions: records,
      );
    }
  }

  Future<ResponseData<dynamic>?> transact(
    String userId,
    String toEmail,
    double amount,
    String currency, {
    String? note,
  }) async {
    ResponseData<dynamic>? res;
    try {
      state = state.copyWith(isLoading: true, error: null);
      res = await _repo.sendMoney(
        userId,
        toEmail,
        amount,
        currency,
        note: note,
      );
      if (res.isSuccessful) {
        await getTransactions(userId);
      }
    } catch (e) {
      //
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return res;
  }
}

final walletRepositoryProvider = Provider<IWalletRepository>((ref) {
  return FirebaseWalletRepository();
});

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  final repo = ref.read(walletRepositoryProvider);
  return WalletNotifier(repo);
});
