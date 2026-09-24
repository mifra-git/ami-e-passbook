import 'package:ami_e_passbook_app/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/account.dart';

class ProfileScreen extends StatelessWidget {
  final Account account;
  final Future<void> Function() onLogout;

  const ProfileScreen({
    super.key,
    required this.account,
    required this.onLogout,
  });

  Future<void> _showLogoutDialog(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: AppTheme.primary,
                size: 23,
              ),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout from AMI E-Passbook?',
            style: TextStyle(
              color: AppTheme.textSecondary,
              height: 1.45,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String email =
        user?.email ?? 'No email available';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Manage your account information',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // PROFILE HEADER CARD
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(
                      alpha: 0.20,
                    ),
                    blurRadius: 22,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circle
                  Positioned(
                    right: -45,
                    top: -55,
                    child: Container(
                      width: 145,
                      height: 145,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.05,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Decorative circle
                  Positioned(
                    right: 35,
                    bottom: -75,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(
                          alpha: 0.08,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      // Profile icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.12,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.gold.withValues(
                              alpha: 0.65,
                            ),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Account Holder',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              account.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Row(
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AppTheme.gold,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  account.accountType,
                                  style: const TextStyle(
                                    color: AppTheme.goldLight,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // ACCOUNT SUMMARY
            // ==================================================

            const Text(
              'Account Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 13),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: AppTheme.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(
                      alpha: 0.025,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Balance',
                      value:
                          'LKR ${account.balance.toStringAsFixed(2)}',
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 45,
                    color: AppTheme.border,
                  ),

                  Expanded(
                    child: _SummaryItem(
                      icon: Icons.verified_rounded,
                      label: 'Status',
                      value: 'Active',
                      valueColor: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ==================================================
            // PERSONAL / ACCOUNT INFORMATION
            // ==================================================

            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 13),

            _InfoCard(
              icon: Icons.email_outlined,
              title: 'Email Address',
              value: email,
            ),

            const SizedBox(height: 11),

            _InfoCard(
              icon: Icons.credit_card_outlined,
              title: 'Account Number',
              value: account.accountNumber,
            ),

            const SizedBox(height: 11),

            _InfoCard(
              icon: Icons.account_balance_outlined,
              title: 'Account Type',
              value: account.accountType,
            ),

            const SizedBox(height: 11),

            _InfoCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Available Balance',
              value:
                  'LKR ${account.balance.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 26),

            // ==================================================
            // READ-ONLY NOTICE
            // ==================================================

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
                    alpha: 0.30,
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
                      color: AppTheme.gold.withValues(
                        alpha: 0.18,
                      ),
                      borderRadius:
                          BorderRadius.circular(12),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Read-only account',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your account information is available for viewing only. Banking transactions cannot be performed through this application.',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // LOGOUT BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 20,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // FOOTER
            // ==================================================

            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 15,
                        color: AppTheme.gold,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'AMI E-Passbook',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Secure read-only account information',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SUMMARY ITEM
// ============================================================

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.goldLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
            size: 20,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor ?? AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
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
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppTheme.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(
              alpha: 0.02,
            ),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppTheme.goldLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.border,
            size: 20,
          ),
        ],
      ),
    );
  }
}

