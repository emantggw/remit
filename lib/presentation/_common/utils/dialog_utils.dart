import 'package:flutter/material.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/font.dart';

class AppDialogUtils {
  static Future<dynamic> showGenDialog({
    required BuildContext context,
    required Function onOkay,
    Function? onCancel,
    required String content,
    Widget? contentWidget,
    String okayText = "OKAY",
    String cancelText = "CANCEL",
    bool barrierDismissible = true,
    bool keepdialogAfterSubmit = false,
    Widget? titleIcon,
    String title = "CONFIRM",
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: SimpleDialog(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (titleIcon != null) ...[titleIcon, kdSpace.width],
                Text(title, style: kfBodyMedium(context)),
              ],
            ),

            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            elevation: 10,
            children: [
              SimpleDialogOption(
                child: Container(child: contentWidget ?? Text(content)),
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.only(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onCancel != null)
                      MaterialButton(
                        padding: const EdgeInsets.all(0),
                        child: Text(cancelText),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          onCancel();
                        },
                      ),
                    MaterialButton(
                      child: Text(okayText),
                      onPressed: () async {
                        if (!keepdialogAfterSubmit) {
                          Navigator.of(context).pop(true);
                        }
                        await onOkay();
                      },
                    ),
                  ],
                ),
              ),
            ],
            //backgroundColor: Colors.green,
          ),
        );
      },
    );
  }
}
