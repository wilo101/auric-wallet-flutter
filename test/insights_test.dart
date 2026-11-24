import 'package:auric_wallet/models/transaction.dart';
import 'package:auric_wallet/services/insights_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mock insights flag dining when it dominates spending', () async {
    final now = DateTime.now();
    final txs = [
      WalletTransaction(id: '1', title: 'A', amount: -900, category: TxCategory.dining, date: now),
      WalletTransaction(id: '2', title: 'B', amount: -100, category: TxCategory.bills, date: now),
    ];
    final out = await MockInsightsService().generate(txs);
    expect(out.any((i) => i.headline.contains('Dining') && i.isWarning), isTrue);
  });
}
