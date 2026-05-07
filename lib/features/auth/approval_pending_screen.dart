import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

class ApprovalPendingScreen extends ConsumerStatefulWidget {
  const ApprovalPendingScreen({super.key});

  @override
  ConsumerState<ApprovalPendingScreen> createState() =>
      _ApprovalPendingScreenState();
}

class _ApprovalPendingScreenState extends ConsumerState<ApprovalPendingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
    );

    // Listen for approval status changes in real-time
    _listenForApproval();
  }

  void _listenForApproval() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) {
      if (!mounted) return;
      final data = doc.data();
      if (data != null && data['isApproved'] == true) {
        // Teacher has been approved!
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 You have been approved! Welcome aboard!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );
        context.go(AppRoutes.dashboard);
      }
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    await ref.read(authProvider.notifier).signOut();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.darkGreen,
              AppColors.primaryGreen,
              AppColors.lightGreen,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                SizedBox(height: h * 0.08),

                // ── Animated icon ─────────────────────────────────
                ScaleTransition(
                  scale: _pulseAnim,
                  child: Container(
                    width: w * 0.3,
                    height: w * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.hourglass_top_rounded,
                      size: w * 0.14,
                      color: AppColors.lightGold,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.04),

                // ── Title ─────────────────────────────────────────
                Text(
                  'Approval Pending',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: w * 0.06,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: h * 0.015),

                // ── Subtitle ──────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                  child: Text(
                    'Your data has been submitted for approval.\nYou will be notified once approved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: w * 0.036,
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.05),

                // ── Info card ─────────────────────────────────────
                Container(
                  margin: EdgeInsets.symmetric(horizontal: w * 0.08),
                  padding: EdgeInsets.all(w * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      _infoRow(
                        Icons.check_circle_outline,
                        'Profile Created',
                        AppColors.success,
                        w,
                      ),
                      SizedBox(height: h * 0.015),
                      _infoRow(
                        Icons.check_circle_outline,
                        'Availability Set',
                        AppColors.success,
                        w,
                      ),
                      SizedBox(height: h * 0.015),
                      _infoRow(
                        Icons.pending_outlined,
                        'Admin Approval',
                        AppColors.pending,
                        w,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Waiting indicator ─────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: w * 0.04,
                      height: w * 0.04,
                      child: const CircularProgressIndicator(
                        color: AppColors.lightGold,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Text(
                      'Waiting for approval...',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: w * 0.032,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.03),

                // ── Sign out button ───────────────────────────────
                TextButton.icon(
                  onPressed: _signOut,
                  icon: Icon(
                    Icons.logout_rounded,
                    color: Colors.white60,
                    size: w * 0.045,
                  ),
                  label: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: w * 0.035,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color, double w) {
    return Row(
      children: [
        Icon(icon, color: color, size: w * 0.055),
        SizedBox(width: w * 0.03),
        Text(
          text,
          style: TextStyle(
            color: AppColors.white,
            fontSize: w * 0.036,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

