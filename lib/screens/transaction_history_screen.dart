import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../theme/app_theme.dart';
import 'transaction_details_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final List<Transaction> transactions;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final bool isLoadingMore;
  final bool hasMoreTransactions;

  const TransactionHistoryScreen({
    super.key,
    required this.transactions,
    required this.onRefresh,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasMoreTransactions,
  });

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends State<TransactionHistoryScreen> {
  TransactionType? selectedType;

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

  IconData getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.loan:
        return Icons.account_balance_outlined;

      case TransactionType.savings:
        return Icons.savings_outlined;

      case TransactionType.loanRepayment:
        return Icons.payments_outlined;
    }
  }

  List<Transaction> get filteredTransactions {
    if (selectedType == null) {
      return widget.transactions;
    }

    return widget.transactions
        .where(
          (transaction) => transaction.type == selectedType,
        )
        .toList();
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color getTransactionColor(TransactionType type) {
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
    final List<Transaction> displayedTransactions =
        filteredTransactions;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            onPressed: widget.onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh transactions',
          ),
        ],
      ),

      body: Column(
        children: [
          // ----------------------------------------------------------
          // SUMMARY HEADER
          // ----------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary,
                    AppTheme.primaryLight,
                  ],
                ),

                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),

              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,

                    decoration: BoxDecoration(
                      color: AppTheme.goldLight,
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.receipt_long_outlined,
                      color: AppTheme.primary,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Transaction History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          selectedType == null
                              ? 'All transactions'
                              : getTransactionName(
                                  selectedType!,
                                ),
                          style: TextStyle(
                            color:
                                Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            Colors.white.withValues(alpha: 0.16),
                      ),
                    ),

                    child: Text(
                      '${displayedTransactions.length}',
                      style: const TextStyle(
                        color: AppTheme.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ----------------------------------------------------------
          // TRANSACTION FILTERS
          // ----------------------------------------------------------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),

            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All',
                  type: null,
                ),

                const SizedBox(width: 8),

                _buildFilterChip(
                  label: 'Loan',
                  type: TransactionType.loan,
                ),

                const SizedBox(width: 8),

                _buildFilterChip(
                  label: 'Savings',
                  type: TransactionType.savings,
                ),

                const SizedBox(width: 8),

                _buildFilterChip(
                  label: 'Loan Repayment',
                  type: TransactionType.loanRepayment,
                ),
              ],
            ),
          ),

          // ----------------------------------------------------------
          // TRANSACTION LIST
          // ----------------------------------------------------------
          Expanded(
            child: RefreshIndicator(
              color: AppTheme.primary,
              backgroundColor: Colors.white,
              onRefresh: widget.onRefresh,

              child: displayedTransactions.isEmpty
                  ? _buildEmptyState()
                  : NotificationListener<ScrollNotification>(
                      onNotification:
                          (ScrollNotification notification) {
                        if (notification.metrics.pixels >=
                                notification.metrics.maxScrollExtent -
                                    100 &&
                            !widget.isLoadingMore &&
                            widget.hasMoreTransactions) {
                          widget.onLoadMore();
                        }

                        return false;
                      },

                      child: ListView.builder(
                        physics:
                            const AlwaysScrollableScrollPhysics(),

                        padding: const EdgeInsets.fromLTRB(
                          16,
                          4,
                          16,
                          24,
                        ),

                        itemCount: displayedTransactions.length +
                            (widget.isLoadingMore ||
                                    widget.hasMoreTransactions
                                ? 1
                                : 0),

                        itemBuilder: (context, index) {
                          // ------------------------------------------------
                          // LOADING / LOAD MORE INDICATOR
                          // ------------------------------------------------
                          if (index ==
                              displayedTransactions.length) {
                            if (widget.isLoadingMore) {
                              return const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (widget.hasMoreTransactions) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  8,
                                  12,
                                  8,
                                  24,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 18,
                                      color:
                                          AppTheme.textSecondary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Scroll to load older transactions',
                                      style: TextStyle(
                                        color:
                                            AppTheme.textSecondary,
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return const SizedBox.shrink();
                          }

                          final Transaction transaction =
                              displayedTransactions[index];

                          return _buildTransactionCard(
                            context,
                            transaction,
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TRANSACTION CARD
  // ------------------------------------------------------------
  Widget _buildTransactionCard(
    BuildContext context,
    Transaction transaction,
  ) {
    final Color transactionColor =
        getTransactionColor(transaction.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(20),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TransactionDetailsScreen(
                  transaction: transaction,
                ),
              ),
            );
          },

          child: Padding(
            padding: const EdgeInsets.all(17),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ----------------------------------------------------
                // HEADER
                // ----------------------------------------------------
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Container(
                      width: 48,
                      height: 48,

                      decoration: BoxDecoration(
                        color: transactionColor.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: Icon(
                        getTransactionIcon(
                          transaction.type,
                        ),
                        color: transactionColor,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            getTransactionName(
                              transaction.type,
                            ),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            transaction.description.isEmpty
                                ? 'No description'
                                : transaction.description,

                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: AppTheme.textSecondary,
                              ),

                              const SizedBox(width: 5),

                              Text(
                                formatDate(transaction.date),
                                style: const TextStyle(
                                  color:
                                      AppTheme.textSecondary,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.textSecondary,
                      size: 22,
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                const Divider(
                  height: 1,
                  color: AppTheme.border,
                ),

                const SizedBox(height: 10),

                // ----------------------------------------------------
                // DEBIT
                // ----------------------------------------------------
                _transactionInfoRow(
                  'Debit',
                  transaction.debit > 0
                      ? 'LKR ${transaction.debit.toStringAsFixed(2)}'
                      : '-',
                  valueColor: transaction.debit > 0
                      ? AppTheme.error
                      : AppTheme.textSecondary,
                ),

                // ----------------------------------------------------
                // CREDIT
                // ----------------------------------------------------
                _transactionInfoRow(
                  'Credit',
                  transaction.credit > 0
                      ? 'LKR ${transaction.credit.toStringAsFixed(2)}'
                      : '-',
                  valueColor: transaction.credit > 0
                      ? AppTheme.success
                      : AppTheme.textSecondary,
                ),

                // ----------------------------------------------------
                // BALANCE
                // ----------------------------------------------------
                _transactionInfoRow(
                  'Balance',
                  'LKR ${transaction.balance.toStringAsFixed(2)}',
                  valueColor: AppTheme.primary,
                ),

                // ----------------------------------------------------
                // REFERENCE
                // ----------------------------------------------------
                _transactionInfoRow(
                  'Reference',
                  transaction.reference.isEmpty
                      ? transaction.transactionId
                      : transaction.reference,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TRANSACTION INFO ROW
  // ------------------------------------------------------------
  Widget _transactionInfoRow(
    String title,
    String value, {
    Color? valueColor,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5,
        bottom: isLast ? 4 : 5,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 78,

            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,

              style: TextStyle(
                color:
                    valueColor ?? AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------
  Widget _buildEmptyState() {
    final String message = selectedType == null
        ? 'No transactions available'
        : 'No ${getTransactionName(selectedType!)} transactions available';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      children: [
        SizedBox(
          height: 330,

          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Container(
                    width: 76,
                    height: 76,

                    decoration: BoxDecoration(
                      color: AppTheme.goldLight,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.receipt_long_outlined,
                      size: 36,
                      color: AppTheme.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'No Transactions',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 18),

                  OutlinedButton.icon(
                    onPressed: widget.onRefresh,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 18,
                    ),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // FILTER CHIP
  // ------------------------------------------------------------
  Widget _buildFilterChip({
    required String label,
    required TransactionType? type,
  }) {
    final bool isSelected = selectedType == type;

    return ChoiceChip(
      label: Text(label),

      selected: isSelected,

      onSelected: (bool selected) {
        setState(() {
          selectedType = selected ? type : null;
        });
      },

      backgroundColor: Colors.white,

      selectedColor: AppTheme.goldLight,

      side: BorderSide(
        color: isSelected
            ? AppTheme.gold
            : AppTheme.border,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),

      labelStyle: TextStyle(
        color: isSelected
            ? AppTheme.primary
            : AppTheme.textSecondary,

        fontSize: 12,

        fontWeight: isSelected
            ? FontWeight.w700
            : FontWeight.w500,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 7,
      ),

      showCheckmark: false,
    );
  }
}

