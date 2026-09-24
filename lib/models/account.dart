class Account {
  final String name;
  final String accountNumber;
  final String accountType;
  final double balance;

  Account({
    required this.name,
    required this.accountNumber,
    required this.accountType,
    required this.balance,
  });

  factory Account.fromFirestore(Map<String, dynamic> data) {
    return Account(
      name: data['name']?.toString() ?? '',
      accountNumber: data['accountNumber']?.toString() ?? '',
      accountType: data['accountType']?.toString() ?? '',
      balance: data['balance'] is num
          ? (data['balance'] as num).toDouble()
          : 0.0,
    );
  }
}

