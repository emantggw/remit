import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:remit/main.dart';

class ThemeState {
  final ThemeMode? themeMode;
  ThemeState({this.themeMode});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState());

  initThemeMode() {
    String? themeMode = localStorage?.getString("themeMode");
    if (themeMode == null || themeMode == "system") {
      state = state.copyWith(themeMode: ThemeMode.system);
    } else if (themeMode == "dark") {
      state = state.copyWith(themeMode: ThemeMode.dark);
    } else if (themeMode == "light") {
      state = state.copyWith(themeMode: ThemeMode.light);
    }
  }

  toggleCurrentThme(BuildContext ctx) {
    if (state.themeMode == ThemeMode.light) {
      state = state.copyWith(themeMode: ThemeMode.dark);
    } else if (state.themeMode == ThemeMode.dark) {
      state = state.copyWith(themeMode: ThemeMode.light);
    } else if (state.themeMode == ThemeMode.system) {
      final isDark = MediaQuery.of(ctx).platformBrightness == Brightness.dark;
      if (isDark) {
        state = state.copyWith(themeMode: ThemeMode.light);
      } else {
        state = state.copyWith(themeMode: ThemeMode.dark);
      }
    }
    localStorage?.setString("themeMode", state.themeMode?.name ?? "dark");
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
