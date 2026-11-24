import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/insight.dart';
import '../models/transaction.dart';

/// The only thing the UI knows about AI. Swap implementations freely.
abstract class InsightsService {
  Future<List<SpendingInsight>> generate(List<WalletTransaction> txs);
}

/// Builds a compact, privacy-conscious summary (category totals, no merchant
/// names) and asks an LLM for structured JSON insights.
///
/// IMPORTANT: in production the API key must live on a backend (e.g. a Cloud
/// Function that proxies the call). Never ship a model key inside the app.
/// Here [endpoint] is meant to point at that proxy.
class LlmInsightsService implements InsightsService {
  final Uri endpoint;
  final http.Client _client;
  final InsightsService fallback;

  LlmInsightsService({
    required this.endpoint,
    required this.fallback,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<List<SpendingInsight>> generate(List<WalletTransaction> txs) async {
    try {
      final res = await _client
          .post(endpoint,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'summary': _summarize(txs), 'format': 'insights_v1'}))
          .timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return fallback.generate(txs);
      final list = (jsonDecode(res.body)['insights'] as List)
          .map((e) => SpendingInsight.fromJson(e as Map<String, dynamic>))
          .toList();
      return list.isEmpty ? fallback.generate(txs) : list;
    } catch (_) {
      // Network error, timeout, bad JSON: the screen must never break.
      return fallback.generate(txs);
    }
  }

  Map<String, double> _summarize(List<WalletTransaction> txs) {
    final totals = <String, double>{};
    for (final t in txs.where((t) => t.isExpense)) {
      totals.update(t.category.name, (v) => v + t.amount.abs(),
          ifAbsent: () => t.amount.abs());
    }
    return totals;
  }
}

/// Rule-based insights. Used when there is no API key / no network, and keeps
/// the demo fully runnable offline.
class MockInsightsService implements InsightsService {
  @override
  Future<List<SpendingInsight>> generate(List<WalletTransaction> txs) async {
    await Future<void>.delayed(const Duration(milliseconds: 900)); // feels like a model call
    final expenses = txs.where((t) => t.isExpense).toList();
    final byCat = <TxCategory, double>{};
    for (final t in expenses) {
      byCat.update(t.category, (v) => v + t.amount.abs(), ifAbsent: () => t.amount.abs());
    }
    final total = byCat.values.fold<double>(0, (a, b) => a + b);
    if (total == 0) return const [];
    final top = byCat.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final dining = byCat[TxCategory.dining] ?? 0;
    return [
      SpendingInsight(
        headline: '${_label(top.key)} is your biggest category',
        detail: '${(top.value / total * 100).round()}% of spending this period.',
      ),
      if (dining > 0)
        SpendingInsight(
          headline: 'Dining out adds up',
          detail: 'EGP ${dining.round()} across ${expenses.where((t) => t.category == TxCategory.dining).length} orders.',
          isWarning: dining / total > 0.2,
        ),
      const SpendingInsight(
        headline: 'Bills are on track',
        detail: 'Recurring bills look stable compared to last month.',
      ),
    ];
  }

  String _label(TxCategory c) => c.name[0].toUpperCase() + c.name.substring(1);
}
