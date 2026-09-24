
import 'package:ami_e_passbook_app/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showMessage('Please enter your email address.');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Please enter your password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('LOGIN SUCCESS');
      debugPrint(
        'Logged-in UID: ${FirebaseAuth.instance.currentUser?.uid}',
      );

      // AuthGate in main.dart handles navigation.
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed. Please try again.';

      switch (e.code) {
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'user-not-found':
          message = 'No account was found with this email.';
          break;

        case 'wrong-password':
          message = 'Incorrect password.';
          break;

        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;

        case 'user-disabled':
          message = 'This account has been disabled.';
          break;

        case 'too-many-requests':
          message =
              'Too many login attempts. Please try again later.';
          break;

        case 'network-request-failed':
          message =
              'Network error. Please check your internet connection.';
          break;
      }

      _showMessage(message);
    } catch (e) {
      _showMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage(
        'Enter your email address first.',
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      _showMessage(
        'Password reset email sent. Please check your inbox.',
      );
    } on FirebaseAuthException catch (e) {
      String message =
          'Unable to send password reset email.';

      if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.code == 'user-not-found') {
        message =
            'No account was found with this email.';
      }

      _showMessage(message);
    } catch (e) {
      _showMessage(
        'Something went wrong. Please try again.',
      );
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // ==================================================
            // BACKGROUND DECORATION
            // ==================================================

            Positioned(
              top: -100,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(
                    alpha: 0.055,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(
                    alpha: 0.07,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ==================================================
            // MAIN CONTENT
            // ==================================================

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  28,
                  22,
                  28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 460,
                  ),
                  child: Column(
                    children: [
                      // ==================================================
                      // BRAND ICON
                      // ==================================================

                      Container(
                        width: 82,
                        height: 82,
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
                          borderRadius:
                              BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary
                                  .withValues(alpha: 0.20),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_rounded,
                              color: Colors.white,
                              size: 40,
                            ),

                            Positioned(
                              right: 16,
                              bottom: 14,
                              child: Icon(
                                Icons.star_rounded,
                                color: AppTheme.gold,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // BRAND NAME
                      // ==================================================

                      const Text(
                        'AMI E-Passbook',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryDark,
                          letterSpacing: -0.7,
                        ),
                      ),

                      const SizedBox(height: 7),

                      const Text(
                        'Secure access to your account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==================================================
                      // LOGIN CARD
                      // ==================================================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          22,
                          24,
                          22,
                          22,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius:
                              BorderRadius.circular(26),
                          border: Border.all(
                            color: AppTheme.border,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary
                                  .withValues(alpha: 0.07),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // ==================================================
                            // CARD HEADER
                            // ==================================================

                            Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: AppTheme.goldLight,
                                    borderRadius:
                                        BorderRadius.circular(13),
                                  ),
                                  child: const Icon(
                                    Icons.lock_person_outlined,
                                    color: AppTheme.primary,
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome Back',
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight:
                                              FontWeight.w800,
                                          color:
                                              AppTheme.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Sign in to continue',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 26),

                            // ==================================================
                            // EMAIL
                            // ==================================================

                            const Text(
                              'Email Address',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            TextField(
                              controller: _emailController,
                              keyboardType:
                                  TextInputType.emailAddress,
                              textInputAction:
                                  TextInputAction.next,
                              decoration: InputDecoration(
                                hintText:
                                    'Enter your email',
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  size: 21,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ==================================================
                            // PASSWORD
                            // ==================================================

                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            TextField(
                              controller:
                                  _passwordController,
                              obscureText:
                                  _obscurePassword,
                              textInputAction:
                                  TextInputAction.done,
                              onSubmitted: (_) {
                                if (!_isLoading) {
                                  _login();
                                }
                              },
                              decoration: InputDecoration(
                                hintText:
                                    'Enter your password',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 21,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword =
                                          !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons
                                            .visibility_outlined
                                        : Icons
                                            .visibility_off_outlined,
                                    size: 21,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            // ==================================================
                            // FORGOT PASSWORD
                            // ==================================================

                            Align(
                              alignment:
                                  Alignment.centerRight,
                              child: TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : _forgotPassword,
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 6,
                                  ),
                                ),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color:
                                        AppTheme.primary,
                                    fontWeight:
                                        FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // ==================================================
                            // LOGIN BUTTON
                            // ==================================================

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.primary,
                                  foregroundColor:
                                      Colors.white,
                                  disabledBackgroundColor:
                                      AppTheme.primaryLight
                                          .withValues(alpha: 0.55),
                                  elevation: 0,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 23,
                                        height: 23,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Sign In',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight:
                                                  FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(width: 9),
                                          Icon(
                                            Icons
                                                .arrow_forward_rounded,
                                            size: 19,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // SECURITY BADGE
                      // ==================================================

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius:
                              BorderRadius.circular(15),
                          border: Border.all(
                            color: AppTheme.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppTheme.success
                                    .withValues(alpha: 0.10),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_user_outlined,
                                size: 16,
                                color: AppTheme.success,
                              ),
                            ),

                            const SizedBox(width: 9),

                            const Flexible(
                              child: Text(
                                'Your banking information is protected',
                                style: TextStyle(
                                  color:
                                      AppTheme.textSecondary,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // FOOTER
                      // ==================================================

                      const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 14,
                            color: AppTheme.gold,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'AMI E-Passbook • Secure Read-Only Access',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

