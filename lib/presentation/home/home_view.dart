import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/icons.dart';
import 'package:remit/presentation/_common/widgets/app_bar_widget.dart';
import 'package:remit/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarWidget(
            title: 'Home',
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(onTap: _onLogout, child: Icon(kiLogout)),
              kdSpace.width,
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('Home View')),
          ),
        ],
      ),
    );
  }

  Future<void> _onLogout() async {
    final res = await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    if (res.isSuccessful) {
      context.go('/login');
    }
  }
}
