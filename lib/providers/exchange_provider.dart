import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:remit/core/entity/ExchangeRate.dart';
import 'package:remit/core/interfaces/iexchange_rates.repository.dart';
import 'package:remit/data/exchangeRate/exchange_rate_repository.dart';

class ExchangeRateState {
  final bool isLoading;
  final String? error;
  final List<ExchangeRate> exchangeRates;

  ExchangeRateState({
    this.isLoading = false,
    this.error,
    this.exchangeRates = const [],
  });

  ExchangeRateState copyWith({
    bool? isLoading,
    String? error,
    List<ExchangeRate>? exchangeRates,
  }) {
    return ExchangeRateState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      exchangeRates: exchangeRates ?? this.exchangeRates,
    );
  }
}

class ExchangeRateNotifier extends StateNotifier<ExchangeRateState> {
  final IExchangeRatesRepository _repo;

  ExchangeRateNotifier(IExchangeRatesRepository repo)
    : _repo = repo,
      super(ExchangeRateState()) {
    //
  }

  Future<void> getExchangeRates() async {
    List<ExchangeRate> exhangeRates = [];
    String? err;
    try {
      state = state.copyWith(
        isLoading: true,
        error: err,
        exchangeRates: exhangeRates,
      );
      var res = await _repo.getExchangeRates();
      if (res.isSuccessful && res.data != null) {
        exhangeRates = res.data ?? [];
      } else {
        err = res.errorMessages.join("\n");
      }
    } catch (e) {
      //
    } finally {
      state = state.copyWith(
        isLoading: false,
        error: err,
        exchangeRates: exhangeRates,
      );
    }
  }
}

final exchangeRateRepository = Provider<IExchangeRatesRepository>((ref) {
  return ExchangeRateRepository();
});

final exchangeRateProvider =
    StateNotifierProvider<ExchangeRateNotifier, ExchangeRateState>((ref) {
      final repo = ref.read(exchangeRateRepository);
      return ExchangeRateNotifier(repo);
    });
