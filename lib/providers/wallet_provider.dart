import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remit/core/interfaces/iwallet.repository.dart';
import 'package:remit/data/wallet/firebase_wallet_repository.dart';

final walletRepositoryProvider = Provider<IWalletRepository>((ref) {
  return FirebaseWalletRepository();
});
