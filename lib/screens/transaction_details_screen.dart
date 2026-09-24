import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../theme/app_theme.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  String getTransactionName(TransactionType type) {
    switch (type) {
      case TransactionType.loan:
        return 'Getting Loan';

      case TransactionType.savings:
        return 'Savings';

      case TransactionType.loanRepayment:
        return 'Loan Repayment';
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatTime(DateTime date) {
    final String hour =
        (date.hour % 12 == 0 ? 12 : date.hour % 12)
            .toString()
            .padLeft(2, '0');

    final String minute =
        date.minute.toString().padLeft(2, '0');

    final String second =
        date.second.toString().padLeft(2, '0');

    final String period =
        date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute:$second $period';
  }

  IconData getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.loan:
        return Icons.account_balance_wallet_outlined;

      case TransactionType.savings:
        return Icons.savings_outlined;

      case TransactionType.loanRepayment:
        return Icons.payments_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String transactionName =
        getTransactionName(transaction.type);

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textPrimary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

        child: Column(
          children: [
            // ----------------------------------------------------------
            // TRANSACTION HEADER
            // ----------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary,
                    AppTheme.primaryLight,
                  ],
                ),

                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                children: [
                  // Icon
                  Container(
                    width: 72,
                    height: 72,

                    decoration: BoxDecoration(
                      color: AppTheme.goldLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.gold,
                        width: 2,
                      ),
                    ),

                    child: Icon(
                      getTransactionIcon(transaction.type),
                      size: 34,
                      color: AppTheme.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    transactionName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Transaction completed successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Amount
                  Text(
                    'LKR ${transaction.amount.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Completed badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),

                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppTheme.gold,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ----------------------------------------------------------
            // TRANSACTION INFORMATION
            // ----------------------------------------------------------
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transaction Information',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.border,
                ),
              ),

              child: Column(
                children: [
                  detailRow(
                    'Transaction ID',
                    transaction.transactionId,
                    icon: Icons.tag_outlined,
                  ),

                  detailRow(
                    'Transaction Type',
                    transactionName,
                    icon: Icons.category_outlined,
                  ),

                  detailRow(
                    'Description',
                    transaction.description,
                    icon: Icons.description_outlined,
                  ),

                  detailRow(
                    'Amount',
                    'LKR ${transaction.amount.toStringAsFixed(2)}',
                    icon: Icons.payments_outlined,
                    valueColor: AppTheme.primary,
                  ),

                  detailRow(
                    'Debit',
                    'LKR ${transaction.debit.toStringAsFixed(2)}',
                    icon: Icons.arrow_upward_rounded,
                    valueColor: transaction.debit > 0
                        ? AppTheme.error
                        : AppTheme.textPrimary,
                  ),

                  detailRow(
                    'Credit',
                    'LKR ${transaction.credit.toStringAsFixed(2)}',
                    icon: Icons.arrow_downward_rounded,
                    valueColor: transaction.credit > 0
                        ? AppTheme.success
                        : AppTheme.textPrimary,
                  ),

                  detailRow(
                    'Balance After Transaction',
                    'LKR ${transaction.balance.toStringAsFixed(2)}',
                    icon: Icons.account_balance_wallet_outlined,
                    valueColor: AppTheme.primary,
                  ),

                  detailRow(
                    'Reference',
                    transaction.reference,
                    icon: Icons.link_outlined,
                  ),

                  detailRow(
                    'Date',
                    formatDate(transaction.date),
                    icon: Icons.calendar_today_outlined,
                  ),

                  detailRow(
                    'Time',
                    formatTime(transaction.date),
                    icon: Icons.access_time_outlined,
                  ),

                  detailRow(
                    'Status',
                    'Completed',
                    icon: Icons.verified_outlined,
                    valueColor: AppTheme.success,
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ----------------------------------------------------------
            // READ-ONLY NOTICE
            // ----------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: AppTheme.goldLight.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.gold.withValues(alpha: 0.35),
                ),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,

                    decoration: BoxDecoration(
                      color: AppTheme.goldLight,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Icon(
                      Icons.lock_outline,
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
                          'Read-only information',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'This transaction information is provided for viewing only. No banking operation can be performed from this screen.',
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

            const SizedBox(height: 24),

            // ----------------------------------------------------------
            // FOOTER
            // ----------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),

                const SizedBox(width: 6),

                Text(
                  'AMI E-Passbook • Secure transaction information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(
    String title,
    String value, {
    required IconData icon,
    Color? valueColor,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 34,
                height: 34,

                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Icon(
                  icon,
                  size: 17,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(width: 12),

              // Title
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Value
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: valueColor ?? AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (!isLast)
          const Divider(
            height: 1,
            color: AppTheme.border,
          ),
      ],
    );
  }
}

