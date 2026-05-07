import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: height * 0.07),

              // Logo / Icon
              Container(
                width: width * 0.28,
                height: width * 0.28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: width * 0.15,
                  color: AppColors.lightGold,
                ),
              ),

              SizedBox(height: height * 0.03),

              // Title
              Text(
                'Quran Learning Academy',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: width * 0.055,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.008),
              Text(
                'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: width * 0.042,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: height * 0.06),

              // "Continue as" label
              Text(
                'Continue as',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                ),
              ),

              SizedBox(height: height * 0.03),

              // Role Cards Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Row(
                  children: [
                    // Teacher Card
                    Expanded(
                      child: _RoleCard(
                        icon: Icons.school_rounded,
                        label: 'Teacher',
                        subtitle: 'Manage your\nclasses & students',
                        onTap: () => context.go(AppRoutes.dashboard),
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    // Student Card
                    Expanded(
                      child: _RoleCard(
                        icon: Icons.person_rounded,
                        label: 'Student',
                        subtitle: 'Book classes &\ntrack progress',
                        onTap: () => context.go(AppRoutes.studentDashboard),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Bottom tagline
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.04),
                child: Text(
                  'Powered by Quran Learning Academy',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: width * 0.028,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: width * 0.07,
            horizontal: width * 0.03,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: AppColors.lightGold,
                  size: width * 0.1,
                ),
              ),
              SizedBox(height: width * 0.04),
              Text(
                widget.label,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: width * 0.015),
              Text(
                widget.subtitle,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: width * 0.028,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

