import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/insight.dart';
import '../models/transaction.dart';
import '../services/insights_service.dart';
import '../theme/app_theme.dart';

class InsightsScreen extends StatefulWidget {
  final List<WalletTransaction> transactions;
  const InsightsScreen({super.key, required this.transactions});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<List<SpendingInsight>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<InsightsService>().generate(widget.transactions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI insights'), backgroundColor: Colors.transparent),
      body: FutureBuilder<List<SpendingInsight>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return const Center(child: Text('Not enough data yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == items.length) {
                return Text(
                  'Insights are generated automatically and are not financial advice.',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              final it = items[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        it.isWarning ? Icons.warning_amber_rounded : Icons.lightbulb_rounded,
                        color: it.isWarning ? AuricColors.expense : AuricColors.gold,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(it.headline, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(it.detail, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
