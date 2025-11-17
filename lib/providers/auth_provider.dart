import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:remit/core/entity/UserAccount.dart';
import 'package:remit/core/entity/ResponseData.dart';
import 'package:remit/core/interfaces/iauth.repository.dart';
import 'package:remit/data/auth/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final UserAccount? user;

  AuthState({this.isLoading = false, this.error, this.user});

  AuthState copyWith({bool? isLoading, String? error, UserAccount? user}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repo;
  StreamSubscription? _sub;

  AuthNotifier(IAuthRepository repo) : _repo = repo, super(AuthState()) {
    // Listen to repository user stream (already maps to UserAccount?)
    _sub = _repo.user.listen((account) {
      state = state.copyWith(user: account);
    });
  }

  Future<ResponseData<UserAccount?>> loginWithEmail(
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repo.loginWithEmailAndPassword(email, password);
    if (!res.isSuccessful) {
      state = state.copyWith(
        isLoading: false,
        error: res.errorMessages.join('\n'),
      );
    } else {
      state = state.copyWith(isLoading: false, user: res.data);
    }
    return res;
  }

  Future<ResponseData<UserAccount?>> signupWithEmailAndPassword({
    required UserAccount userAccount,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repo.createAccount(userAccount, password);
    if (!res.isSuccessful) {
      state = state.copyWith(
        isLoading: false,
        error: res.errorMessages.join('\n'),
      );
    } else {
      state = state.copyWith(isLoading: false, user: res.data);
    }
    return res;
  }

  Future<ResponseData<UserAccount?>> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repo.loginWithGoogle();
    if (!res.isSuccessful) {
      state = state.copyWith(
        isLoading: false,
        error: res.errorMessages.join('\n'),
      );
    } else {
      state = state.copyWith(isLoading: false, user: res.data);
    }
    return res;
  }

  Future<ResponseData> logout() async {
    state = state.copyWith(isLoading: true);
    final res = await _repo.logOut();
    state = state.copyWith(isLoading: false, user: null);
    return res;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthNotifier(repo);
});
