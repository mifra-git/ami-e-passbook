import 'package:flutter/material.dart';

import '../models/account.dart';
import '../theme/app_theme.dart';

class AccountsScreen extends StatelessWidget {
  final Account account;

  const AccountsScreen({
    super.key,
    required this.account,
  });

  String _maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) {
      return accountNumber;
    }

    return '****${accountNumber.substring(accountNumber.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Accounts'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textPrimary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ----------------------------------------------------------
            // PAGE HEADER
            // ----------------------------------------------------------
            const Text(
              'My Account',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'View your account information and balance',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------------
            // MAIN ACCOUNT CARD
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
                    color: AppTheme.primary.withValues(
                      alpha: 0.18,
                    ),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // ----------------------------------------------------
                  // ACCOUNT TYPE HEADER
                  // ----------------------------------------------------
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,

                        decoration: BoxDecoration(
                          color: AppTheme.goldLight,
                          borderRadius:
                              BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.account_balance_outlined,
                          color: AppTheme.primary,
                          size: 25,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${account.accountType} Account',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 3),

                            const Text(
                              'Active account',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.10,
                          ),
                          borderRadius:
                              BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),

                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: AppTheme.gold,
                              size: 15,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ----------------------------------------------------
                  // ACCOUNT NUMBER
                  // ----------------------------------------------------
                  const Text(
                    'Account Number',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Text(
                        _maskAccountNumber(
                          account.accountNumber,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Icon(
                        Icons.lock_outline,
                        color: AppTheme.gold,
                        size: 17,
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // ----------------------------------------------------
                  // BALANCE
                  // ----------------------------------------------------
                  const Text(
                    'Available Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'LKR ${account.balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    height: 1,
                    color: Colors.white.withValues(
                      alpha: 0.12,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.white70,
                        size: 15,
                      ),

                      SizedBox(width: 6),

                      Text(
                        'Read-only account information',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ----------------------------------------------------------
            // ACCOUNT DETAILS TITLE
            // ----------------------------------------------------------
            const Text(
              'Account Details',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Your registered account information',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 14),

            // ----------------------------------------------------------
            // ACCOUNT DETAILS CARD
            // ----------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 5,
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
                  accountInfoRow(
                    'Account Number',
                    account.accountNumber,
                    icon: Icons.credit_card_outlined,
                  ),

                  accountInfoRow(
                    'Account Type',
                    account.accountType,
                    icon: Icons.account_balance_outlined,
                  ),

                  accountInfoRow(
                    'Balance',
                    'LKR ${account.balance.toStringAsFixed(2)}',
                    icon: Icons.account_balance_wallet_outlined,
                    valueColor: AppTheme.primary,
                  ),

                  accountInfoRow(
                    'Status',
                    'Active',
                    icon: Icons.verified_outlined,
                    valueColor: AppTheme.success,
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ----------------------------------------------------------
            // SECURITY / READ-ONLY NOTICE
            // ----------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: AppTheme.goldLight.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.gold.withValues(
                    alpha: 0.35,
                  ),
                ),
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Container(
                    width: 38,
                    height: 38,

                    decoration: BoxDecoration(
                      color: AppTheme.goldLight,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),

                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Secure account information',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Your account information is displayed for viewing only. No account operations can be performed from this screen.',
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
                const Icon(
                  Icons.shield_outlined,
                  size: 15,
                  color: AppTheme.textSecondary,
                ),

                const SizedBox(width: 6),

                Text(
                  'AMI E-Passbook • Secure read-only banking',
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

  Widget accountInfoRow(
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
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Container(
                width: 34,
                height: 34,

                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius:
                      BorderRadius.circular(10),
                ),

                child: Icon(
                  icon,
                  size: 17,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 7,
                  ),
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

              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 7,
                  ),
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: valueColor ??
                          AppTheme.textPrimary,
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

