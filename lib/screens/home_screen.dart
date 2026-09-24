import 'package:ami_e_passbook_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/transaction.dart';
import 'transaction_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final Account account;
  final List<Transaction> transactions;
  final Future<void> Function()? onRefresh;

  const HomeScreen({
    super.key,
    required this.account,
    required this.transactions,
    this.onRefresh,
  });

  String _maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) {
      return accountNumber;
    }

    return '**** **** ${accountNumber.substring(accountNumber.length - 4)}';
  }

  String _getTransactionType(TransactionType type) {
    switch (type) {
      case TransactionType.loan:
        return 'Loan';
      case TransactionType.savings:
        return 'Savings';
      case TransactionType.loanRepayment:
        return 'Loan Repayment';
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.loan:
        return Icons.account_balance_wallet_rounded;
      case TransactionType.savings:
        return Icons.savings_rounded;
      case TransactionType.loanRepayment:
        return Icons.payments_rounded;
    }
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.loan:
        return AppTheme.primary;
      case TransactionType.savings:
        return AppTheme.success;
      case TransactionType.loanRepayment:
        return AppTheme.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppTheme.primary,
        backgroundColor: AppTheme.card,
        onRefresh: onRefresh ?? () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // TOP HEADER
              // --------------------------------------------------

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.primaryDark,
                          AppTheme.primary,
                          AppTheme.primaryLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.16),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 13),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AMI E-Passbook',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Your account at a glance',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Refresh button
                  Material(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: onRefresh,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.border,
                          ),
                        ),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: AppTheme.primary,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // WELCOME SECTION
              // --------------------------------------------------

              const Text(
                'Good day,',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                account.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 22),

              // --------------------------------------------------
              // BALANCE CARD
              // --------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(23, 22, 23, 21),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primaryDark,
                      AppTheme.primary,
                      AppTheme.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.23),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -35,
                      top: -45,
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 30,
                      bottom: -65,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'AVAILABLE BALANCE',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.gold.withValues(alpha: 0.35),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppTheme.goldLight,
                                    size: 12,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'READ ONLY',
                                    style: TextStyle(
                                      color: AppTheme.goldLight,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 9),

                        Text(
                          'LKR ${account.balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.12),
                        ),

                        const SizedBox(height: 17),

                        Row(
                          children: [
                            Expanded(
                              child: _BalanceDetail(
                                label: 'ACCOUNT NUMBER',
                                value: _maskAccountNumber(
                                  account.accountNumber,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            _BalanceDetail(
                              label: 'ACCOUNT TYPE',
                              value: account.accountType,
                              alignEnd: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // ACCOUNT OVERVIEW
              // --------------------------------------------------

              const Text(
                'Account Overview',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.account_balance_outlined,
                      title: 'Account Type',
                      value: account.accountType,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _InfoCard(
                      icon: Icons.verified_rounded,
                      title: 'Account Status',
                      value: 'Active',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // RECENT TRANSACTIONS HEADER
              // --------------------------------------------------

              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Your latest account activity',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (transactions.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.goldLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '3 recent',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 14),

              // --------------------------------------------------
              // TRANSACTIONS
              // --------------------------------------------------

              if (transactions.isEmpty)
                _buildEmptyTransactions()
              else
                ...transactions.take(3).map(
                  (transaction) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _TransactionCard(
                        transaction: transaction,
                        title: _getTransactionType(
                          transaction.type,
                        ),
                        icon: _getTransactionIcon(
                          transaction.type,
                        ),
                        iconColor: _getTransactionColor(
                          transaction.type,
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // READ-ONLY INFORMATION
              // --------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: AppTheme.goldLight.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.gold.withValues(alpha: 0.30),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.visibility_outlined,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Read-only account access',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'AMI E-Passbook allows you to securely view your account information and transaction history.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppTheme.goldLight,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 29,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'No transactions available',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Your recent account activity will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BALANCE DETAIL
// ============================================================

class _BalanceDetail extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _BalanceDetail({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// INFORMATION CARD
// ============================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppTheme.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.goldLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 21,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TRANSACTION CARD
// ============================================================

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final String title;
  final IconData icon;
  final Color iconColor;

  const _TransactionCard({
    required this.transaction,
    required this.title,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(
                transaction: transaction,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.border,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Transaction icon
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 23,
                ),
              ),

              const SizedBox(width: 13),

              // Transaction information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(
                          Icons.tag_rounded,
                          size: 12,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            transaction.transactionId,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Amount + date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'LKR ${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${transaction.date.day.toString().padLeft(2, '0')}/'
                    '${transaction.date.month.toString().padLeft(2, '0')}/'
                    '${transaction.date.year}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 6),

              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

