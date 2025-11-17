import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:remit/presentation/auth/signup_view.dart';
import 'package:remit/presentation/home/home_view.dart';
import 'presentation/auth/login_view.dart';
import 'presentation/startup/startup_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/startup',
      routes: [
        GoRoute(path: '/startup', builder: (ctx, state) => const StartupView()),
        GoRoute(path: '/login', builder: (ctx, state) => const LoginView()),
        GoRoute(path: '/signup', builder: (ctx, state) => const SignupView()),
        GoRoute(path: '/home', builder: (ctx, state) => const HomeView()),
      ],
    );

    return MaterialApp.router(
      title: 'Remit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
