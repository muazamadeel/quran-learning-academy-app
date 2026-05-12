import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';
import 'package:quran_learning_app/provider/student/student_dashboard_provider.dart';
import 'package:quran_learning_app/features/teacher/widget/student_bottom_nav.dart';
import 'package:quran_learning_app/features/teacher/widget/student_class_card.dart';
import 'package:quran_learning_app/core/widgets/app_drawer.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentDashboardProvider);
    final authState = ref.watch(authProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.045,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.lightGold,
            ),
            onPressed: () => context.go(AppRoutes.subscription),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : RefreshIndicator(
              color: AppColors.primaryGreen,
              onRefresh: () =>
                  ref.read(studentDashboardProvider.notifier).refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Welcome Card ──────────────────────────────────
                    _WelcomeCard(
                      name:
                          authState.user?.name ??
                          state.student?.name ??
                          'Student',
                      w: w,
                      h: h,
                    ),
                    SizedBox(height: h * 0.015),

                    // ── Trial Banner ──────────────────────────────────
                    _TrialBanner(daysLeft: state.trialDaysLeft, w: w, h: h),
                    SizedBox(height: h * 0.025),

                    // ── Available Teachers ────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Teachers',
                          style: TextStyle(
                            fontSize: w * 0.042,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.teacherList),
                          child: Text(
                            'See All',
                            style: TextStyle(
                              fontSize: w * 0.033,
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.012),

                    if (state.availableTeachers.isEmpty)
                      _EmptyBox(
                        icon: Icons.person_search_outlined,
                        message: 'No teachers available yet',
                        w: w,
                        h: h,
                      )
                    else
                      // Horizontal scroll list
                      SizedBox(
                        height: h * 0.22,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.availableTeachers.length,
                          separatorBuilder: (_, _) => SizedBox(width: w * 0.03),
                          itemBuilder: (context, index) {
                            final teacher = state.availableTeachers[index];
                            return _TeacherCard(teacher: teacher, w: w, h: h);
                          },
                        ),
                      ),
                    SizedBox(height: h * 0.025),

                    // ── Upcoming Classes ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming Classes',
                          style: TextStyle(
                            fontSize: w * 0.042,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.studentSchedule),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: w * 0.033,
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.012),

                    if (state.upcomingClasses.isEmpty)
                      _EmptyBox(
                        icon: Icons.calendar_today_outlined,
                        message: 'No upcoming classes',
                        subtitle: 'Book a class with a teacher to get started!',
                        w: w,
                        h: h,
                      )
                    else
                      ...state.upcomingClasses.map(
                        (cls) => StudentClassCard(
                          classModel: cls,
                          onJoin: () {
                            context.push(
                              AppRoutes.studentClassroom,
                              extra: {
                                'channelName': cls.id,
                                'otherPersonName': cls.teacherName,
                                'time': cls.time,
                                'scheduledAt': cls.scheduledAt,
                                'date': cls.date,
                                'slotTime': cls.time,
                                'durationMinutes': cls.durationMinutes ?? 30,
                                'studentId': cls.studentId ?? '',
                                'teacherId': cls.teacherId ?? '',
                                'studentName': authState.user?.name ??
                                    state.student?.name ??
                                    'Student',
                                'isTeacher': false,
                              },
                            );
                          },
                        ),
                      ),

                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const StudentBottomNav(currentIndex: 0),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WELCOME CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _WelcomeCard extends StatelessWidget {
  final String name;
  final double w, h;
  const _WelcomeCard({required this.name, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'As-salamu Alaykum!',
                  style: TextStyle(color: Colors.white70, fontSize: w * 0.032),
                ),
                SizedBox(height: h * 0.005),
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: h * 0.006),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.03,
                    vertical: w * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '📖 Ready to Learn',
                    style: TextStyle(
                      color: AppColors.lightGold,
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: w * 0.075,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: AppColors.white, size: w * 0.08),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TRIAL BANNER
// ═══════════════════════════════════════════════════════════════════════════════
class _TrialBanner extends StatelessWidget {
  final int daysLeft;
  final double w, h;
  const _TrialBanner({
    required this.daysLeft,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    final isUrgent = daysLeft <= 7;
    final color = isUrgent ? AppColors.rejected : AppColors.gold;

    return GestureDetector(
      onTap: () => context.go(AppRoutes.subscription),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.3),
              color.withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: w * 0.11,
              height: w * 0.11,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUrgent
                    ? Icons.warning_amber_rounded
                    : Icons.access_time_rounded,
                color: AppColors.white,
                size: w * 0.06,
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUrgent ? '⚠️ Trial Ending Soon!' : '🎁 Free Trial Active',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.037,
                    ),
                  ),
                  SizedBox(height: h * 0.003),
                  Text(
                    daysLeft > 0
                        ? '$daysLeft day${daysLeft == 1 ? '' : 's'} remaining'
                        : 'Your free trial has ended',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: w * 0.029,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
              size: w * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TEACHER CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _TeacherCard extends StatelessWidget {
  final TeacherListModel teacher;
  final double w, h;
  const _TeacherCard({required this.teacher, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    int availableDays = 0;
    teacher.availability.forEach((_, v) {
      if (v is Map && v['enabled'] == true) availableDays++;
    });

    return GestureDetector(
      onTap: () =>
          context.go(AppRoutes.studentBooking, extra: {'teacher': teacher}),
      child: Container(
        width: w * 0.42,
        padding: EdgeInsets.all(w * 0.035),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: w * 0.05,
                  backgroundColor: AppColors.primaryGreen.withValues(
                    alpha: 0.1,
                  ),
                  backgroundImage: teacher.profileImage.isNotEmpty
                      ? NetworkImage(teacher.profileImage)
                      : null,
                  child: teacher.profileImage.isEmpty
                      ? Text(
                          teacher.name.isNotEmpty ? teacher.name[0] : '?',
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.04,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: w * 0.02),
                Expanded(
                  child: Text(
                    teacher.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.033,
                      color: AppColors.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.006),

            if (teacher.country.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: w * 0.032,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(width: w * 0.01),
                  Expanded(
                    child: Text(
                      teacher.country,
                      style: TextStyle(
                        fontSize: w * 0.027,
                        color: AppColors.textGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            SizedBox(height: h * 0.004),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: w * 0.032,
                  color: AppColors.success,
                ),
                SizedBox(width: w * 0.01),
                Text(
                  '$availableDays days/week',
                  style: TextStyle(
                    fontSize: w * 0.027,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go(
                  AppRoutes.studentBooking,
                  extra: {'teacher': teacher},
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: h * 0.01),
                  elevation: 0,
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.w600,
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

// ═══════════════════════════════════════════════════════════════════════════════
// EMPTY BOX
// ═══════════════════════════════════════════════════════════════════════════════
class _EmptyBox extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;
  final double w, h;

  const _EmptyBox({
    required this.icon,
    required this.message,
    required this.w,
    required this.h,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.06),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: w * 0.12, color: AppColors.textLight),
          SizedBox(height: h * 0.01),
          Text(
            message,
            style: TextStyle(
              fontSize: w * 0.035,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: h * 0.005),
            Text(
              subtitle!,
              style: TextStyle(fontSize: w * 0.03, color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
