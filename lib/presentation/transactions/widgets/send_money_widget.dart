import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:remit/core/entity/ResponseData.dart';
import 'package:remit/presentation/_common/app_colors.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/icons.dart';
import 'package:remit/presentation/_common/utils/dialog_utils.dart';
import 'package:remit/presentation/_common/utils/validators_utils.dart';
import 'package:remit/presentation/_common/widgets/action_button.dart';
import 'package:remit/presentation/_common/widgets/loading_indicator.dart';
import 'package:remit/presentation/_common/widgets/text_field_widget.dart';

class SendMoneyWidget extends StatefulWidget {
  final String userId;
  final Future<ResponseData?> Function(
    String fromUserId,
    String toUserEmail,
    double amount,
    String currency, {
    String? note,
  })
  onSend;
  const SendMoneyWidget({
    super.key,
    required this.userId,
    required this.onSend,
  });

  @override
  State<SendMoneyWidget> createState() => _SendMoneyWidgetState();
}

class _SendMoneyWidgetState extends State<SendMoneyWidget> {
  final toController = TextEditingController();
  final amountController = TextEditingController();
  bool isLoading = false;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kdScreenHeight(context) * .75,
      child: isLoading
          ? Center(child: LoadingIndicator())
          : Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formState,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Send Money (ETB)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        kdSpaceLarge.height,
                        TextFieldWidget(
                          controller: toController,
                          validator: ValidatorUtils.emailValidator,
                          hintText: "Recipient User Email",
                        ),
                        kdSpaceLarge.height,
                        TextFieldWidget(
                          controller: amountController,
                          textInputType: TextInputType.number,
                          hintText: "Amount (ETB)",
                        ),

                        kdSpaceLarge.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            SizedBox(width: 8),

                            AppActionButton(
                              onPressed: _onSendHandler,
                              child: Text("SEND"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  _onSendHandler() async {
    if (formState.currentState?.validate() ?? false) {
      try {
        final toEmail = toController.text.trim();
        final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
        if (toEmail.isEmpty || amount <= 0) {
          await AppDialogUtils.showGenDialog(
            context: context,
            title: "ERROR",
            titleIcon: Icon(kiError, color: kcRed),
            onOkay: () {},
            content: 'Please enter valid recipient and amount',
          );
          return;
        }

        // confirmation
        var confirm = await AppDialogUtils.showGenDialog(
          context: context,
          title: "CONFIRM",
          titleIcon: Icon(kiInfo),
          onOkay: () {},
          onCancel: () {},
          content:
              "You are about to send ETB ${amount.toStringAsFixed(2)} to $toEmail. Continue?",
        );

        if (confirm != true) return;

        setState(() {
          isLoading = true;
        });
        var res = await widget.onSend(
          widget.userId,
          toEmail,
          amount,
          'ETB',
          note: 'Sent via app',
        );

        if (res?.isSuccessful ?? false) {
          Fluttertoast.showToast(
            msg: 'Sent successfully',
            backgroundColor: kcGreen,
          );
          Navigator.of(context).pop(true);
        } else {
          AppDialogUtils.showGenDialog(
            context: context,
            title: "FAILED TO SEND",
            titleIcon: Icon(kiError, color: kcRed),
            onOkay: () {},
            content: (res?.errorMessages ?? []).join("\n"),
          );
        }
      } catch (e) {
        //
        Fluttertoast.showToast(
          msg: 'Exception occured.',
          backgroundColor: kcRed,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
