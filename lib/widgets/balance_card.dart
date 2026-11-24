import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;
  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AuricColors.surfaceHigh, AuricColors.surface],
        ),
        border: Border.all(color: AuricColors.gold.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total balance', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(fmt.format(balance), style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 18),
          Row(children: [
            _Stat(label: 'Income', value: fmt.format(income), color: AuricColors.income),
            const SizedBox(width: 24),
            _Stat(label: 'Spent', value: fmt.format(expenses), color: AuricColors.expense),
          ]),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      );
}
