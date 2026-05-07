import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  String _role = 'student';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authProvider.notifier)
        .signUp(
          name: _nameCtrl.text,
          email: _emailCtrl.text,
          password: _passCtrl.text,
          role: _role,
        );
    if (ok && mounted) {
      if (_role == 'teacher') {
        // Teacher goes to availability setup first
        context.go(AppRoutes.teacherAvailability);
      } else {
        context.go(AppRoutes.studentDashboard);
      }
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
            // ── Header ──────────────────────────────────────────
            Container(
              width: double.infinity,
              height: h * 0.28,
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
                      width: w * 0.17,
                      height: w * 0.17,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: w * 0.09,
                        color: AppColors.lightGold,
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: w * 0.052,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: h * 0.004),
                    Text(
                      'Join the Quran Learning Academy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: w * 0.033,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Form ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.06,
                vertical: h * 0.03,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Role Toggle ──────────────────────────────
                    _label('I am a...', w),
                    SizedBox(height: h * 0.01),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.textLight),
                      ),
                      child: Row(
                        children: [
                          _roleTab(
                            'student',
                            'Student',
                            Icons.person_rounded,
                            w,
                          ),
                          _roleTab(
                            'teacher',
                            'Teacher',
                            Icons.school_rounded,
                            w,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.025),

                    // Error banner
                    if (auth.error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(w * 0.03),
                        decoration: BoxDecoration(
                          color: AppColors.rejected.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.rejected.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.rejected,
                              size: w * 0.045,
                            ),
                            SizedBox(width: w * 0.02),
                            Expanded(
                              child: Text(
                                auth.error!,
                                style: TextStyle(
                                  color: AppColors.rejected,
                                  fontSize: w * 0.032,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.018),
                    ],

                    // Full Name
                    _label('Full Name', w),
                    SizedBox(height: h * 0.008),
                    _field(
                      controller: _nameCtrl,
                      hint: 'Ahmed Khan',
                      icon: Icons.person_outline,
                      w: w,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Name is required';
                        }
                        if (v.trim().length < 2) return 'Enter a valid name';
                        return null;
                      },
                    ),
                    SizedBox(height: h * 0.018),

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
                    SizedBox(height: h * 0.018),

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
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: h * 0.018),

                    // Confirm Password
                    _label('Confirm Password', w),
                    SizedBox(height: h * 0.008),
                    _field(
                      controller: _confirmCtrl,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      w: w,
                      obscure: _obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textGrey,
                          size: w * 0.05,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please confirm password';
                        }
                        if (v != _passCtrl.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: h * 0.035),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.065,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: w * 0.042,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: h * 0.025),

                    // Login link
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: w * 0.035),
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(color: AppColors.textGrey),
                              ),
                              TextSpan(
                                text: 'Sign In',
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
                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleTab(String role, String label, IconData icon, double w) {
    final selected = _role == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _role = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: w * 0.03),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: w * 0.045,
                color: selected ? AppColors.white : AppColors.textGrey,
              ),
              SizedBox(width: w * 0.015),
              Text(
                label,
                style: TextStyle(
                  fontSize: w * 0.035,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.white : AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, double w) => Text(
    text,
    style: TextStyle(
      fontSize: w * 0.035,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
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
        prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: w * 0.05),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: w * 0.04,
        ),
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
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rejected, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rejected, width: 1.8),
        ),
      ),
    );
  }
}

