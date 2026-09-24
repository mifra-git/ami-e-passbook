import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/account.dart';
import '../models/transaction.dart';

class TransactionPage {
  final List<Transaction> transactions;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool hasMore;

  TransactionPage({
    required this.transactions,
    required this.lastDocument,
    required this.hasMore,
  });
}

class FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<Account?> getCurrentAccount() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final DocumentSnapshot<Map<String, dynamic>> document =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

    if (!document.exists) {
      return null;
    }

    final Map<String, dynamic>? data = document.data();

    if (data == null) {
      return null;
    }

    return Account.fromFirestore(data);
  }

  Future<TransactionPage> getTransactions({
    int limit = 10,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return TransactionPage(
        transactions: [],
        lastDocument: null,
        hasMore: false,
      );
    }

    final DocumentSnapshot<Map<String, dynamic>> userDocument =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

    if (!userDocument.exists) {
      return TransactionPage(
        transactions: [],
        lastDocument: null,
        hasMore: false,
      );
    }

    final Map<String, dynamic>? userData = userDocument.data();

    if (userData == null) {
      return TransactionPage(
        transactions: [],
        lastDocument: null,
        hasMore: false,
      );
    }

    final String accountNumber =
        userData['accountNumber']?.toString() ?? '';

    if (accountNumber.isEmpty) {
      return TransactionPage(
        transactions: [],
        lastDocument: null,
        hasMore: false,
      );
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(accountNumber)
        .collection('transactions')
        .orderBy('date', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await query.get();

    final List<Transaction> transactions =
        snapshot.docs.map((document) {
      return Transaction.fromFirestore(
        document.id,
        document.data(),
      );
    }).toList();

    return TransactionPage(
      transactions: transactions,
      lastDocument:
          snapshot.docs.isEmpty ? null : snapshot.docs.last,
      hasMore: snapshot.docs.length == limit,
    );
  }
}