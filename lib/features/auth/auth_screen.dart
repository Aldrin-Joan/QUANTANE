// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';

class AuthScreen extends ConsumerStatefulWidget {

  const AuthScreen({
    super.key,
    required this.isUpgrade,
  });
  final bool isUpgrade;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late bool _isLoginMode;
  late AnimationController _fadeController;
  late AnimationController _backgroundGlowController;

  @override
  void initState() {
    super.initState();
    _isLoginMode = !widget.isUpgrade;

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeController.forward();

    _backgroundGlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _backgroundGlowController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
    _fadeController.reset();
    _fadeController.forward();
  }

  Future<void> _handleEmailAuth(AuthState authState) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (widget.isUpgrade) {
        await ref.read(authServiceProvider.notifier).linkEmail(email, password);
        _showSnackbar('Account upgraded successfully!', isError: false);
      } else {
        if (_isLoginMode) {
          await ref
              .read(authServiceProvider.notifier)
              .signInWithEmail(email, password);
          _showSnackbar('Logged in successfully!', isError: false);
        } else {
          await ref
              .read(authServiceProvider.notifier)
              .signUpWithEmail(email, password);
          _showSnackbar('Account registered successfully!', isError: false);
        }
      }
      if (mounted) {
        context.go('/settings');
      }
    } catch (e) {
      _showSnackbar(e.toString(), isError: true);
    }
  }

  Future<void> _handleGoogleAuth() async {
    try {
      if (widget.isUpgrade) {
        await ref.read(authServiceProvider.notifier).linkGoogle();
        _showSnackbar('Account upgraded with Google!', isError: false);
      } else {
        await ref.read(authServiceProvider.notifier).signInWithGoogle();
        _showSnackbar('Logged in with Google successfully!', isError: false);
      }
      if (mounted) {
        context.go('/settings');
      }
    } catch (e) {
      _showSnackbar(e.toString(), isError: true);
    }
  }

  void _showSnackbar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? AppColors.dangerColor : AppColors.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          // Animated Background Ambient Glow
          AnimatedBuilder(
            animation: _backgroundGlowController,
            builder: (context, child) {
              final angle = _backgroundGlowController.value * 2.0 * 3.14159;
              final xOffset = 80.0 * (angle < 3.14159 ? 1.0 : -1.0);
              return Positioned(
                top: -100 + xOffset,
                right: -100 - xOffset,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.12),
                        blurRadius: 100,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentColor.withOpacity(0.06),
                    blurRadius: 80,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),

          // Main Scroll View Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Premium Brand/Header
                    const Icon(
                      LucideIcons.shield_check,
                      size: 64,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.isUpgrade
                          ? 'Secure Your Account'
                          : (_isLoginMode ? 'Welcome Back' : 'Get Started'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isUpgrade
                          ? 'Save your guest database to a secure cloud account'
                          : (_isLoginMode
                              ? 'Enter your credentials to access your cloud sync'
                              : 'Create an account to synchronize vehicles & analytics'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Elegant Glassmorphic Container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGlassGradient,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: FadeTransition(
                          opacity: _fadeController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email Input
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  labelStyle: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                  prefixIcon: const Icon(
                                    LucideIcons.mail,
                                    color: AppColors.textTertiary,
                                    size: 18,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.1),
                                ),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                                validator: (val) {
                                  if (val == null ||
                                      val.isEmpty ||
                                      !val.contains('@')) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Password Input
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                  prefixIcon: const Icon(
                                    LucideIcons.lock,
                                    color: AppColors.textTertiary,
                                    size: 18,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.1),
                                ),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                                validator: (val) {
                                  if (val == null || val.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // Submit Button
                              ElevatedButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : () => _handleEmailAuth(authState),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                  disabledBackgroundColor:
                                      AppColors.primaryMuted,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: authState.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: AppColors.textPrimary,
                                        ),
                                      )
                                    : Text(
                                        widget.isUpgrade
                                            ? 'Link Account & Sync'
                                            : (_isLoginMode
                                                ? 'Sign In'
                                                : 'Register Account'),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider for Alternative Login Providers
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.08),
                            thickness: 1,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.08),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Google Sign-In Option
                    OutlinedButton.icon(
                      onPressed: authState.isLoading ? null : _handleGoogleAuth,
                      icon: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Text(
                          'G',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      label: Text(
                        widget.isUpgrade
                            ? 'Upgrade using Google'
                            : 'Sign in with Google',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.white.withOpacity(0.08)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white.withOpacity(0.02),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Toggle mode or Cancel link
                    if (!widget.isUpgrade)
                      TextButton(
                        onPressed: authState.isLoading ? null : _toggleMode,
                        child: Text(
                          _isLoginMode
                              ? "Don't have an account? Sign Up"
                              : 'Already have an account? Sign In',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/settings');
                        }
                      },
                      child: const Text(
                        'Cancel & Return',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
