import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _fade =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _scale = Tween<double>(begin: 0.65, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _navigateBasedOnAuth(AuthState authState) {
    if (authState.isAuthenticated) {
      if (authState.isTeacher) {
        if (authState.user!.isApproved) {
          context.go(AppRoutes.dashboard);
        } else if (authState.user!.availability.isNotEmpty) {
          // Has set availability but not approved yet
          context.go(AppRoutes.approvalPending);
        } else {
          // New teacher, needs to set availability
          context.go(AppRoutes.teacherAvailability);
        }
      } else {
        context.go(AppRoutes.studentDashboard);
      }
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (!next.isLoading) {
        _navigateBasedOnAuth(next);
      }
    });

    final authState = ref.watch(authProvider);
    if (!authState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _navigateBasedOnAuth(authState);
        }
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.darkGreen, AppColors.primaryGreen, AppColors.lightGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, child) => Opacity(
                opacity: _fade.value,
                child: Transform.scale(scale: _scale.value, child: child),
              ),
              child: Column(
                children: [
                  Container(
                    width: w * 0.28,
                    height: w * 0.28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3), width: 2),
                    ),
                    child: Icon(Icons.menu_book_rounded,
                        size: w * 0.14, color: AppColors.lightGold),
                  ),
                  SizedBox(height: h * 0.03),
                  Text(
                    'Quran Learning Academy',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: w * 0.052,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: h * 0.008),
                  Text(
                    'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                    style: TextStyle(
                        color: Colors.white70, fontSize: w * 0.04),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.08),
            const CircularProgressIndicator(
                color: AppColors.lightGold, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}

