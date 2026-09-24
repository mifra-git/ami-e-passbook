import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/transaction.dart';
import '../services/firestore_service.dart';

import 'home_screen.dart';
import 'accounts_screen.dart';
import 'transaction_history_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  Account? account;

  List<Transaction> transactions = [];

  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreTransactions = true;

  String? errorMessage;

  DocumentSnapshot<Map<String, dynamic>>? lastTransactionDocument;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ------------------------------------------------------------
  // LOAD ACCOUNT AND FIRST PAGE OF TRANSACTIONS
  // ------------------------------------------------------------

  Future<void> _loadUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
        transactions = [];
        lastTransactionDocument = null;
        hasMoreTransactions = true;
      });
    }

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          errorMessage = 'No user is currently logged in.';
        });

        return;
      }

      debugPrint('Logged-in UID: ${user.uid}');

      final Account? loadedAccount =
          await _firestoreService.getCurrentAccount();

      if (loadedAccount == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          errorMessage = 'User account information was not found.';
        });

        return;
      }

      final TransactionPage transactionPage =
          await _firestoreService.getTransactions();

      debugPrint(
        'Loaded ${transactionPage.transactions.length} transactions.',
      );

      if (!mounted) return;

      setState(() {
        account = loadedAccount;
        transactions = transactionPage.transactions;
        lastTransactionDocument = transactionPage.lastDocument;
        hasMoreTransactions = transactionPage.hasMore;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      debugPrint('Error loading banking data: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Unable to load banking information.';
      });
    }
  }

  // ------------------------------------------------------------
  // LOAD OLDER TRANSACTIONS
  // ------------------------------------------------------------

  Future<void> loadMoreTransactions() async {
    if (isLoadingMore ||
        !hasMoreTransactions ||
        lastTransactionDocument == null) {
      return;
    }

    setState(() {
      isLoadingMore = true;
    });

    try {
      final TransactionPage transactionPage =
          await _firestoreService.getTransactions(
        startAfter: lastTransactionDocument,
      );

      if (!mounted) return;

      setState(() {
        transactions.addAll(transactionPage.transactions);
        lastTransactionDocument = transactionPage.lastDocument;
        hasMoreTransactions = transactionPage.hasMore;
        isLoadingMore = false;
      });
    } catch (e) {
      debugPrint('Error loading older transactions: $e');

      if (!mounted) return;

      setState(() {
        isLoadingMore = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load older transactions.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // REFRESH TRANSACTIONS
  // ------------------------------------------------------------

  Future<void> _refreshTransactions() async {
    try {
      final TransactionPage transactionPage =
          await _firestoreService.getTransactions();

      if (!mounted) return;

      setState(() {
        transactions = transactionPage.transactions;
        lastTransactionDocument = transactionPage.lastDocument;
        hasMoreTransactions = transactionPage.hasMore;
      });
    } catch (e) {
      debugPrint('Error refreshing transactions: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to refresh transactions.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // LOGOUT
  // ------------------------------------------------------------

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Logout error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to logout. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // RETRY
  // ------------------------------------------------------------

  Future<void> _retryLoading() async {
    if (!mounted) return;

    await _loadUserData();
  }

  // ------------------------------------------------------------
  // LOADING SCREEN
  // ------------------------------------------------------------

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF123C73),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF123C73).withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'AMI E-Passbook',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Color(0xFF123C73),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Loading your account...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ERROR SCREEN
  // ------------------------------------------------------------

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'AMI E-Passbook',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  color: Colors.redAccent,
                  size: 42,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                errorMessage ??
                    'Unable to load account information.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _retryLoading,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF123C73),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF123C73),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MODERN BOTTOM NAVIGATION
  // ------------------------------------------------------------

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.08),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 72,

            indicatorColor:
                const Color(0xFF123C73).withValues(alpha: 0.11),

            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            labelTextStyle:
                WidgetStateProperty.resolveWith<TextStyle>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF123C73),
                  );
                }

                return TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                );
              },
            ),

            iconTheme:
                WidgetStateProperty.resolveWith<IconThemeData>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(
                    color: Color(0xFF123C73),
                    size: 25,
                  );
                }

                return IconThemeData(
                  color: Colors.grey.shade600,
                  size: 23,
                );
              },
            ),
          ),

          child: NavigationBar(
            selectedIndex: _currentIndex,

            onDestinationSelected: (int index) {
              if (_currentIndex == index) return;

              setState(() {
                _currentIndex = index;
              });
            },

            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),

              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long_rounded),
                label: 'Transactions',
              ),

              NavigationDestination(
                icon: Icon(Icons.account_balance_outlined),
                selectedIcon: Icon(Icons.account_balance_rounded),
                label: 'Accounts',
              ),

              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // LOADING
    // ----------------------------------------------------------

    if (isLoading) {
      return _buildLoadingScreen();
    }

    // ----------------------------------------------------------
    // ERROR
    // ----------------------------------------------------------

    if (errorMessage != null || account == null) {
      return _buildErrorScreen();
    }

    // ----------------------------------------------------------
    // MAIN PAGES
    // ----------------------------------------------------------

    final List<Widget> pages = [
      HomeScreen(
        account: account!,
        transactions: transactions,
        onRefresh: _refreshTransactions,
      ),

      TransactionHistoryScreen(
        transactions: transactions,
        onRefresh: _refreshTransactions,
        onLoadMore: loadMoreTransactions,
        isLoadingMore: isLoadingMore,
        hasMoreTransactions: hasMoreTransactions,
      ),

      AccountsScreen(
        account: account!,
      ),

      ProfileScreen(
        account: account!,
        onLogout: _logout,
      ),
    ];

    // ----------------------------------------------------------
    // MAIN DASHBOARD
    // ----------------------------------------------------------

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}

