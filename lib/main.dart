import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remit/presentation/auth/signup_view.dart';
import 'package:remit/presentation/home/home_view.dart';
import 'package:remit/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/auth/login_view.dart';
import 'presentation/startup/startup_view.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

SharedPreferences? localStorage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  localStorage = await SharedPreferences.getInstance();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    ref.read(themeProvider.notifier).initThemeMode();
    super.initState();
  }

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
      theme: FlexThemeData.light(
        useMaterial3: true,
        scheme: FlexScheme.rosewood,
        fontFamily: GoogleFonts.roboto().fontFamily,
        typography: Typography.material2021(platform: defaultTargetPlatform),
      ),
      darkTheme: FlexThemeData.dark(
        useMaterial3: true,
        scheme: FlexScheme.rosewood,
        fontFamily: GoogleFonts.roboto().fontFamily,
        typography: Typography.material2021(platform: defaultTargetPlatform),
      ),
      themeMode: ref.watch(themeProvider).themeMode,
      routerConfig: router,
    );
  }
}
