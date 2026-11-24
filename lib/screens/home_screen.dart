import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../services/auth_service.dart';
import '../services/wallet_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import 'insights_screen.dart';

class HomeScreen extends StatelessWidget {
  final String uid;
  const HomeScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<WalletRepository>();
    return StreamBuilder<List<WalletTransaction>>(
      stream: repo.watchTransactions(uid),
      builder: (context, snap) {
        final txs = snap.data ?? const <WalletTransaction>[];
        final income = txs.where((t) => !t.isExpense).fold<double>(0, (a, t) => a + t.amount);
        final spent = txs.where((t) => t.isExpense).fold<double>(0, (a, t) => a + t.amount.abs());
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Auric'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () => context.read<AuthService>().signOut(),
              ),
            ],
          ),
          body: !snap.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    BalanceCard(balance: income - spent, income: income, expenses: spent),
                    const SizedBox(height: 16),
                    _InsightsBanner(txs: txs),
                    const SizedBox(height: 24),
                    Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    for (final t in txs) TransactionTile(tx: t),
                  ],
                ),
        );
      },
    );
  }
}

class _InsightsBanner extends StatelessWidget {
  final List<WalletTransaction> txs;
  const _InsightsBanner({required this.txs});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        leading: const Icon(Icons.auto_awesome_rounded, color: AuricColors.gold),
        title: Text('AI spending insights', style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text('See where your money goes',
            style: Theme.of(context).textTheme.bodyMedium),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => InsightsScreen(transactions: txs)),
        ),
      ),
    );
  }
}
