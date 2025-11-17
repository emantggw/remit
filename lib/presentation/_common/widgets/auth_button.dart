import 'package:remit/presentation/_common/app_colors.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/font.dart';
import 'package:remit/presentation/_common/widgets/action_button.dart';
import 'package:remit/presentation/_common/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Function() onPressed;
  final String? title;
  final Widget? titleWidget;
  final bool isBusy;
  final Color? background;
  final bool outlineMode;
  const AuthButton({
    super.key,
    this.isBusy = false,
    this.outlineMode = false,
    this.titleWidget,
    this.title,
    this.background,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kdMarginLarge),
      child: outlineMode
          ? OutlinedButton(
              onPressed: onPressed,
              child: isBusy
                  ? const LoadingIndicator(size: 35)
                  : titleWidget ??
                        Text(title ?? "", style: kfBodyMedium(context)),
            )
          : AppActionButton(
              backgroundColor: background ?? kcPrimary(context),
              onPressed: onPressed,
              child: isBusy
                  ? LoadingIndicator(size: 35, color: kcOnPrimary(context))
                  : titleWidget ??
                        Text(
                          title ?? "",
                          style: kfBodyMedium(
                            context,
                            color: kcOnPrimary(context),
                          ),
                        ),
            ),
    );
  }
}
