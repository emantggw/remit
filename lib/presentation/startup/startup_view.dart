import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:remit/presentation/_common/widgets/loading_indicator.dart';

import '../../providers/auth_provider.dart';

class StartupView extends ConsumerStatefulWidget {
  const StartupView({super.key});

  @override
  ConsumerState<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends ConsumerState<StartupView> {
  @override
  void initState() {
    super.initState();
    // Start an async check that waits for the first auth state emission
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.user.first;
      if (!mounted) return;
      if (user != null) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    } catch (e) {
      // On error, navigate to login as a safe default
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: LoadingIndicator()));
  }
}
