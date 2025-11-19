import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remit/core/entity/TransactionRecord.dart';
import 'package:remit/presentation/_common/app_colors.dart';

class TransactionTileWidget extends StatelessWidget {
  final TransactionRecord txn;
  const TransactionTileWidget({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    bool isSent = (txn.type ?? '') == 'sent';
    String amountText = (isSent ? '-' : '+') + txn.amount.toStringAsFixed(2);
    DateTime date = txn.timestamp ?? DateTime.now();
    String dateText = DateFormat.yMMMd().add_jm().format(date);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSent ? Colors.red.shade100 : Colors.green.shade100,
        child: Icon(
          isSent ? Icons.arrow_upward : Icons.arrow_downward,
          color: isSent ? kcRed : kcGreen,
        ),
      ),
      title: Text('${txn.currency} $amountText'),
      subtitle: Text('${txn.note ?? ''} • $dateText'),
      trailing: Text(
        isSent ? 'Sent' : 'Received',
        style: TextStyle(color: isSent ? kcRed : kcGreen),
      ),
    );
  }
}
