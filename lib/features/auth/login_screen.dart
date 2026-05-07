import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).signIn(
          email: _emailCtrl.text,
          password: _passCtrl.text,
        );
    if (ok && mounted) {
      final auth = ref.read(authProvider);
      context.go(
          auth.isStudent ? AppRoutes.studentDashboard : AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Top header ──────────────────────────────────────
            Container(
              width: double.infinity,
              height: h * 0.35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.darkGreen, AppColors.primaryGreen],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: w * 0.2,
                      height: w * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5),
                      ),
                      child: Icon(Icons.menu_book_rounded,
                          size: w * 0.1, color: AppColors.lightGold),
                    ),
                    SizedBox(height: h * 0.015),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: w * 0.055,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                          color: Colors.white70, fontSize: w * 0.035),
                    ),
                  ],
                ),
              ),
            ),

            // ── Form card ───────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.06, vertical: h * 0.04),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error banner
                    if (auth.error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(w * 0.03),
                        decoration: BoxDecoration(
                          color: AppColors.rejected.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                                  AppColors.rejected.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: AppColors.rejected, size: w * 0.045),
                            SizedBox(width: w * 0.02),
                            Expanded(
                              child: Text(auth.error!,
                                  style: TextStyle(
                                      color: AppColors.rejected,
                                      fontSize: w * 0.032)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                    ],

                    // Email
                    _label('Email Address', w),
                    SizedBox(height: h * 0.008),
                    _field(
                      controller: _emailCtrl,
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      w: w,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    SizedBox(height: h * 0.022),

                    // Password
                    _label('Password', w),
                    SizedBox(height: h * 0.008),
                    _field(
                      controller: _passCtrl,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      w: w,
                      obscure: _obscurePass,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textGrey,
                          size: w * 0.05,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        return null;
                      },
                    ),
                    SizedBox(height: h * 0.04),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.065,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: AppColors.white, strokeWidth: 2.5))
                            : Text('Sign In',
                                style: TextStyle(
                                    fontSize: w * 0.042,
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // Sign up link
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.signup),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: w * 0.035),
                            children: [
                              TextSpan(
                                  text: "Don't have an account? ",
                                  style:
                                      TextStyle(color: AppColors.textGrey)),
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, double w) => Text(
        text,
        style: TextStyle(
            fontSize: w * 0.035,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required double w,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: w * 0.038, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textLight, fontSize: w * 0.035),
        prefixIcon:
            Icon(icon, color: AppColors.primaryGreen, size: w * 0.05),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryGreen, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.rejected, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.rejected, width: 1.8),
        ),
      ),
    );
  }
}

