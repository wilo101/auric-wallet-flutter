import 'package:cloud_firestore/cloud_firestore.dart';

enum TxCategory { groceries, dining, transport, bills, shopping, salary, other }

class WalletTransaction {
  final String id;
  final String title;
  final double amount; // negative = expense, positive = income
  final TxCategory category;
  final DateTime date;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  bool get isExpense => amount < 0;

  Map<String, dynamic> toMap() => {
        'title': title,
        'amount': amount,
        'category': category.name,
        'date': Timestamp.fromDate(date),
      };

  factory WalletTransaction.fromMap(String id, Map<String, dynamic> map) {
    return WalletTransaction(
      id: id,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: TxCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => TxCategory.other,
      ),
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
