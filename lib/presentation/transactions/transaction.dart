import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remit/core/entity/TransactionRecord.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/font.dart';
import 'package:remit/presentation/_common/widgets/loading_indicator.dart';
import 'package:remit/presentation/transactions/widgets/transaction_tile_widget.dart';
import 'package:remit/presentation/_providers/auth_provider.dart';
import 'package:remit/presentation/_providers/wallet_provider.dart';

class TransactionView extends ConsumerStatefulWidget {
  const TransactionView({super.key});

  @override
  ConsumerState<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends ConsumerState<TransactionView> {
  StreamSubscription? _sub;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((tm) {
      try {
        _sub = ref.read(authRepositoryProvider).user.listen((e) {
          if ((e?.uid ?? "").isEmpty) {
            return;
          }
          ref.read(walletProvider.notifier).getTransactions(e?.uid ?? "");
        });
      } catch (e) {
        //
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProv = ref.watch(walletProvider);

    if (walletProv.isLoading) {
      return Center(child: LoadingIndicator());
    }
    if (walletProv.transactions.isEmpty) {
      return Center(child: Text('No transactions'));
    }
    List<TransactionRecord> txns = walletProv.transactions;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kdPaddingLarge,
                vertical: kdPadding,
              ),
              child: Text(
                "Transactions",
                style: kfBodyMedium(context, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverFillRemaining(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: txns.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, index) =>
                  TransactionTileWidget(txn: txns[index]),
            ),
          ),
          SliverToBoxAdapter(child: kdSpaceXXXLarge.height),
        ],
      ),
    );
  }
}
