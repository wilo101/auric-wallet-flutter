import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final WalletTransaction tx;
  const TransactionTile({super.key, required this.tx});

  static IconData iconFor(TxCategory c) => switch (c) {
        TxCategory.groceries => Icons.shopping_basket_rounded,
        TxCategory.dining => Icons.restaurant_rounded,
        TxCategory.transport => Icons.directions_car_rounded,
        TxCategory.bills => Icons.receipt_long_rounded,
        TxCategory.shopping => Icons.shopping_bag_rounded,
        TxCategory.salary => Icons.payments_rounded,
        TxCategory.other => Icons.circle_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final color = tx.isExpense ? AuricColors.textPrimary : AuricColors.income;
    final sign = tx.isExpense ? '-' : '+';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AuricColors.surfaceHigh,
        child: Icon(iconFor(tx.category), color: AuricColors.gold, size: 20),
      ),
      title: Text(tx.title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(DateFormat('d MMM').format(tx.date),
          style: Theme.of(context).textTheme.bodyMedium),
      trailing: Text(
        '$sign${tx.amount.abs().toStringAsFixed(2)}',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
