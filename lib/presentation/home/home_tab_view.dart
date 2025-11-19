import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:remit/core/entity/UserAccount.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/transactions/transaction.dart';
import 'package:remit/presentation/_common/icons.dart';
import 'package:remit/presentation/_common/widgets/app_bar_widget.dart';
import 'package:remit/presentation/transactions/widgets/send_money_widget.dart';
import 'package:remit/presentation/_providers/auth_provider.dart';
import 'package:remit/presentation/_providers/theme_provider.dart';
import 'package:remit/presentation/_providers/wallet_provider.dart';

class HomeTabView extends ConsumerStatefulWidget {
  const HomeTabView({super.key});

  @override
  ConsumerState<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends ConsumerState<HomeTabView> {
  get walletRepo => ref.read(walletProvider);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        AppBarWidget(
          title: "Home",
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(onTap: _onLogout, child: Icon(kiLogout)),
            kdSpace.width,
            GestureDetector(
              onTap: () {
                ref.read(themeProvider.notifier).toggleCurrentThme(context);
              },
              child: Icon(
                ref.watch(themeProvider).themeMode == ThemeMode.dark
                    ? kiLightMode
                    : kiDarkMode,
              ),
            ),
            kdSpace.width,
          ],
        ),
        SliverToBoxAdapter(child: _buildBalanceCard()),
        SliverFillRemaining(
          hasScrollBody: false,
          child: SizedBox(
            height: kdScreenHeight(context) * .65,
            child: TransactionView(),
          ),
        ),
      ],
    );
  }

  Future<void> _onLogout() async {
    final res = await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    if (res.isSuccessful) {
      context.go('/login');
    }
  }

  Widget _buildBalanceCard() {
    final walletRepo = ref.read(walletRepositoryProvider);
    UserAccount? user = ref.watch(authProvider).user;
    if (user == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Please login to see your balance'),
        ),
      );
    }

    return StreamBuilder<double>(
      stream: walletRepo.balanceStream(user.uid ?? ''),
      builder: (context, snap) {
        final balance = snap.data ?? 0.0;
        final formatter = NumberFormat.currency(symbol: '');
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Balance (ETB)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      kdSpace.height,
                      Text(
                        formatter.format(balance),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showSendBottomSheet(user.uid ?? ''),
                  icon: Icon(Icons.send),
                  label: Text('Send'),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSendBottomSheet(String fromUserId) async {
    bool? status = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (context) => SendMoneyWidget(
        userId: fromUserId,
        onSend: ref.read(walletProvider.notifier).transact,
      ),
    );
    if (status == true) {}
  }

  double parseDouble(String s) {
    return double.tryParse(s) ?? 0.0;
  }
}
