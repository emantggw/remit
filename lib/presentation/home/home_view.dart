import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remit/core/entity/UserAccount.dart';
import 'package:remit/core/interfaces/iwallet.repository.dart';
import 'package:remit/presentation/_common/app_colors.dart';
import 'package:remit/presentation/_common/icons.dart';
import 'package:remit/presentation/exchangeRates/exchange_rates.dart';
import 'package:remit/presentation/home/home_tab_view.dart';
import 'package:remit/presentation/profile/profile.dart';
import 'package:remit/presentation/transactions/transaction.dart';
import 'package:remit/presentation/_providers/auth_provider.dart';
import 'package:remit/presentation/_providers/wallet_provider.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _currentIndex = 0;

  double get mintAmount => 100000;

  IWalletRepository get walletRepo => ref.read(walletRepositoryProvider);
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    UserAccount? user = ref.watch(authProvider).user;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => walletRepo.mint(user?.uid ?? "", mintAmount),
        label: Text("Mint"),
      ),
      body: PageView(
        controller: pageController,
        allowImplicitScrolling: false,

        onPageChanged: onPageChanged,

        children: [
          HomeTabView(),
          TransactionView(),
          ExchangeRateView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(kiHome), label: "Home"),
          BottomNavigationBarItem(
            icon: const Icon(kiHistory),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: const Icon(kiExchange),
            label: "Exhange",
          ),
          BottomNavigationBarItem(icon: Icon(kiProfile), label: "Profile"),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: kcPrimary(context),

        onTap: (i) {
          _currentIndex = i;
          pageController.animateToPage(
            _currentIndex,
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 300),
          );
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void onPageChanged(int value) {}
}
