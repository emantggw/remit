import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remit/core/entity/ExchangeRate.dart';
import 'package:remit/presentation/_common/app_colors.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/font.dart';
import 'package:remit/presentation/_common/widgets/app_bar_widget.dart';
import 'package:remit/presentation/_common/widgets/loading_indicator.dart';
import 'package:remit/presentation/_common/widgets/text_field_widget.dart';
import 'package:remit/providers/exchange_provider.dart';

class ExchangeRateView extends ConsumerStatefulWidget {
  const ExchangeRateView({super.key});

  @override
  ConsumerState<ExchangeRateView> createState() => _ExchangeRateViewState();
}

class _ExchangeRateViewState extends ConsumerState<ExchangeRateView> {
  ExchangeRate? selectedRate;
  final TextEditingController amountController = TextEditingController();
  double? convertedAmount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((tm) {
      ref.read(exchangeRateProvider.notifier).getExchangeRates();
    });
  }

  void calculate() {
    if (selectedRate == null) return;

    final amount = double.tryParse(amountController.text) ?? 0;
    setState(() {
      convertedAmount = amount * selectedRate!.rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(exchangeRateProvider).isLoading;
    List<ExchangeRate> rates = ref.watch(exchangeRateProvider).exchangeRates;

    return Scaffold(
      body: isLoading
          ? const Center(child: LoadingIndicator())
          : CustomScrollView(
              slivers: [
                const AppBarWidget(
                  title: "Exchange Rates",
                  automaticallyImplyLeading: false,
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// DROPDOWN FOR RATES
                        DropdownButtonFormField<ExchangeRate>(
                          decoration: InputDecoration(
                            labelText: "Select Exchange Rate",
                            labelStyle: kfBodyMedium(context),
                            // border: OutlineInputBorder(),
                          ),
                          items: rates
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    "1 ${e.from} → ${e.to} @ ${e.rate}",
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() => selectedRate = val);
                            calculate();
                          },
                        ),

                        kdSpaceLarge.height,
                        TextFieldWidget(
                          controller: amountController,
                          textInputType: TextInputType.number,
                          hintText: "Amount",
                          onChanged: (_) => calculate(),
                        ),
                        kdSpaceXLarge.height,

                        /// RESULT
                        if (convertedAmount != null &&
                            amountController.text.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: kdScreenWidth(context),
                            decoration: BoxDecoration(
                              color: kcTertiaryContainer(context),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${amountController.text} ${selectedRate?.from} = "
                              "${convertedAmount!.toStringAsFixed(2)} ${selectedRate?.to}",
                              style: kfBodyMedium(
                                context,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
