import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';

abstract class WalletRepository {
  Stream<List<WalletTransaction>> watchTransactions(String uid);
  Future<void> add(String uid, WalletTransaction tx);
}

/// Firestore layout:  users/{uid}/transactions/{txId}
class FirestoreWalletRepository implements WalletRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('transactions');

  @override
  Stream<List<WalletTransaction>> watchTransactions(String uid) => _col(uid)
      .orderBy('date', descending: true)
      .limit(100)
      .snapshots()
      .map((s) => s.docs
          .map((d) => WalletTransaction.fromMap(d.id, d.data()))
          .toList());

  @override
  Future<void> add(String uid, WalletTransaction tx) =>
      _col(uid).add(tx.toMap());
}

class MockWalletRepository implements WalletRepository {
  final List<WalletTransaction> _items = _seed();

  static List<WalletTransaction> _seed() {
    final now = DateTime.now();
    WalletTransaction t(String id, String title, double amt, TxCategory c, int daysAgo) =>
        WalletTransaction(
            id: id,
            title: title,
            amount: amt,
            category: c,
            date: now.subtract(Duration(days: daysAgo)));
    return [
      t('1', 'Salary', 24500, TxCategory.salary, 2),
      t('2', 'Carrefour', -862.5, TxCategory.groceries, 1),
      t('3', 'Uber', -145, TxCategory.transport, 1),
      t('4', 'Cafe Nile', -210, TxCategory.dining, 3),
      t('5', 'Electricity bill', -480, TxCategory.bills, 4),
      t('6', 'Noon', -1299, TxCategory.shopping, 5),
      t('7', 'Talabat', -385, TxCategory.dining, 6),
      t('8', 'Talabat', -420, TxCategory.dining, 8),
      t('9', 'Internet bill', -350, TxCategory.bills, 9),
    ];
  }

  @override
  Stream<List<WalletTransaction>> watchTransactions(String uid) =>
      Stream.value(List.unmodifiable(_items));

  @override
  Future<void> add(String uid, WalletTransaction tx) async => _items.insert(0, tx);
}
