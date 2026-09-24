enum TransactionType {
  loan,
  savings,
  loanRepayment,
}

class Transaction {
  final String transactionId;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String description;
  final double debit;
  final double credit;
  final double balance;
  final String reference;

  Transaction({
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.reference,
  });

  factory Transaction.fromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    return Transaction(
      transactionId: documentId,
      type: _transactionTypeFromString(
        data['type']?.toString() ?? '',
      ),
      amount: data['amount'] is num
          ? (data['amount'] as num).toDouble()
          : 0.0,
      date: _dateFromFirestore(data['date']),
      description: data['description']?.toString() ?? '',
      debit: data['debit'] is num
          ? (data['debit'] as num).toDouble()
          : 0.0,
      credit: data['credit'] is num
          ? (data['credit'] as num).toDouble()
          : 0.0,
      balance: data['balance'] is num
          ? (data['balance'] as num).toDouble()
          : 0.0,
      reference: data['reference']?.toString() ?? '',
    );
  }

  static TransactionType _transactionTypeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'loan':
        return TransactionType.loan;

      case 'savings':
        return TransactionType.savings;

      case 'loanrepayment':
      case 'loan repayment':
        return TransactionType.loanRepayment;

      default:
        return TransactionType.savings;
    }
  }

  static DateTime _dateFromFirestore(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value != null) {
      try {
        return value.toDate();
      } catch (_) {
        try {
          return DateTime.parse(value.toString());
        } catch (_) {}
      }
    }

    return DateTime.now();
  }
}