import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';
import 'package:quran_learning_app/provider/student/student_provider.dart';
import 'package:quran_learning_app/features/teacher/widget/student_bottom_nav.dart';
import 'package:quran_learning_app/features/teacher/widget/student_class_card.dart';
import 'package:quran_learning_app/core/widgets/app_drawer.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentDashboardProvider);
    final authState = ref.watch(authProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          // Subscription icon
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
          : SingleChildScrollView(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Welcome Card ────────────────────────────────
                  _buildWelcomeCard(
                    context,
                    authState.user?.name ?? state.student?.name ?? 'Student',
                    width,
                    height,
                  ),
                  SizedBox(height: height * 0.015),

                  // ── Trial Banner ────────────────────────────────
                  _buildTrialBanner(
                    context,
                    state.trialDaysLeft,
                    width,
                    height,
                  ),
                  SizedBox(height: height * 0.025),

                  // ── Choose Your Course ──────────────────────────
                  Text(
                    'Choose Your Course',
                    style: TextStyle(
                      fontSize: width * 0.042,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: height * 0.012),
                  _buildCourseGrid(context, width, height),
                  SizedBox(height: height * 0.025),

                  // ── Available Teachers ──────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Teachers',
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.teacherList),
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: width * 0.033,
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.012),

                  if (state.availableTeachers.isEmpty)
                    _buildNoTeachers(width, height)
                  else
                    SizedBox(
                      height: height * 0.22,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.availableTeachers.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(width: width * 0.03),
                        itemBuilder: (context, index) {
                          final teacher = state.availableTeachers[index];
                          return _buildTeacherCard(
                            context,
                            teacher,
                            width,
                            height,
                          );
                        },
                      ),
                    ),
                  SizedBox(height: height * 0.025),

                  // ── Upcoming Classes ────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Classes',
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.studentSchedule),
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: width * 0.033,
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.012),

                  if (state.upcomingClasses.isEmpty)
                    _buildNoClasses(width, height)
                  else
                    ...state.upcomingClasses.map(
                      (cls) => StudentClassCard(
                        classModel: cls,
                        onJoin: () {
                          context.go(
                            AppRoutes.studentClassroom,
                            extra: {
                              'teacherName': cls.teacherName,
                              'subject': cls.subject,
                              'time': cls.time,
                            },
                          );
                        },
                      ),
                    ),
                  SizedBox(height: height * 0.02),
                ],
              ),
            ),
      bottomNavigationBar: const StudentBottomNav(currentIndex: 0),
    );
  }

  // ── Welcome Card ────────────────────────────────────────────────────────
  Widget _buildWelcomeCard(
    BuildContext context,
    String name,
    double width,
    double height,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.02,
      ),
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
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: width * 0.032,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: height * 0.006),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: width * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '📖 Ready to Learn',
                    style: TextStyle(
                      color: AppColors.lightGold,
                      fontSize: width * 0.028,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: width * 0.075,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.person,
              color: AppColors.white,
              size: width * 0.08,
            ),
          ),
        ],
      ),
    );
  }

  // ── Trial Banner ────────────────────────────────────────────────────────
  Widget _buildTrialBanner(
    BuildContext context,
    int daysLeft,
    double width,
    double height,
  ) {
    final isUrgent = daysLeft <= 7;

    return GestureDetector(
      onTap: () => context.go(AppRoutes.subscription),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUrgent
                ? [
                    AppColors.rejected.withValues(alpha: 0.3),
                    AppColors.rejected.withValues(alpha: 0.3),
                  ]
                : [
                    AppColors.gold.withValues(alpha: 0.3),
                    AppColors.gold.withValues(alpha: 0.3),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: (isUrgent ? AppColors.rejected : AppColors.gold)
                  .withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: width * 0.11,
              height: width * 0.11,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUrgent
                    ? Icons.warning_amber_rounded
                    : Icons.access_time_rounded,
                color: AppColors.white,
                size: width * 0.06,
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUrgent ? '⚠️ Trial Ending Soon!' : '🎁 Free Trial Active',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.037,
                    ),
                  ),
                  SizedBox(height: height * 0.003),
                  Text(
                    'Your 30 days free trial${daysLeft > 0 ? " — $daysLeft days remaining" : " has ended"}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: width * 0.029,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
              size: width * 0.04,
            ),
          ],
        ),
      ),
    );
  }

  // ── Teacher Card (horizontal scroll) ────────────────────────────────────
  Widget _buildTeacherCard(
    BuildContext context,
    TeacherListModel teacher,
    double width,
    double height,
  ) {
    // Count available days
    int availableDays = 0;
    teacher.availability.forEach((_, v) {
      if (v is Map && v['enabled'] == true) availableDays++;
    });

    return GestureDetector(
      onTap: () {
        context.go(AppRoutes.studentBooking, extra: {'teacher': teacher});
      },
      child: Container(
        width: width * 0.42,
        padding: EdgeInsets.all(width * 0.035),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + name
            Row(
              children: [
                CircleAvatar(
                  radius: width * 0.05,
                  backgroundColor: AppColors.primaryGreen.withValues(
                    alpha: 0.1,
                  ),
                  child: Text(
                    teacher.name.isNotEmpty ? teacher.name[0] : '?',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: Text(
                    teacher.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.033,
                      color: AppColors.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.008),

            // Country
            if (teacher.country.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: width * 0.032,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(width: width * 0.01),
                  Expanded(
                    child: Text(
                      teacher.country,
                      style: TextStyle(
                        fontSize: width * 0.027,
                        color: AppColors.textGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            SizedBox(height: height * 0.005),

            // Available days
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: width * 0.032,
                  color: AppColors.success,
                ),
                SizedBox(width: width * 0.01),
                Text(
                  '$availableDays days/week',
                  style: TextStyle(
                    fontSize: width * 0.027,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Book button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go(
                    AppRoutes.studentBooking,
                    extra: {'teacher': teacher},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  elevation: 0,
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: width * 0.03,
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

  // ── Empty states ────────────────────────────────────────────────────────
  Widget _buildNoTeachers(double width, double height) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.06),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_search_outlined,
            size: width * 0.12,
            color: AppColors.textLight,
          ),
          SizedBox(height: height * 0.01),
          Text(
            'No teachers available yet',
            style: TextStyle(
              fontSize: width * 0.035,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoClasses(double width, double height) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.06),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: width * 0.12,
            color: AppColors.textLight,
          ),
          SizedBox(height: height * 0.01),
          Text(
            'No upcoming classes',
            style: TextStyle(
              fontSize: width * 0.035,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: height * 0.005),
          Text(
            'Book a class with a teacher to get started!',
            style: TextStyle(
              fontSize: width * 0.03,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  // ── Course Grid ────────────────────────────────────────────────────────
  Widget _buildCourseGrid(BuildContext context, double width, double height) {
    const courses = [
      {
        'name': 'Tajweed',
        'icon': Icons.record_voice_over_rounded,
        'color1': Color(0xFF1B8A4F),
        'color2': Color(0xFF2ECC71),
        'desc': 'Correct Pronunciation',
      },
      {
        'name': 'Hifz',
        'icon': Icons.favorite_rounded,
        'color1': Color(0xFFE74C3C),
        'color2': Color(0xFFFF6B6B),
        'desc': 'Quran Memorization',
      },
      {
        'name': 'Quran Reading',
        'icon': Icons.auto_stories_rounded,
        'color1': Color(0xFF2980B9),
        'color2': Color(0xFF3498DB),
        'desc': 'Learn to Read',
      },
      {
        'name': 'Tafseer',
        'icon': Icons.lightbulb_rounded,
        'color1': Color(0xFFF39C12),
        'color2': Color(0xFFFFC107),
        'desc': 'Understanding Quran',
      },
      {
        'name': 'Arabic Language',
        'icon': Icons.translate_rounded,
        'color1': Color(0xFF8E44AD),
        'color2': Color(0xFFAB47BC),
        'desc': 'Learn Arabic',
      },
      {
        'name': 'Noorani Qaida',
        'icon': Icons.abc_rounded,
        'color1': Color(0xFF00897B),
        'color2': Color(0xFF26A69A),
        'desc': 'Basic Foundations',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: width * 0.025,
        mainAxisSpacing: width * 0.025,
        childAspectRatio: 0.82,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return GestureDetector(
          onTap: () {
            context.go(
              AppRoutes.teacherList,
              extra: {'course': course['name']},
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [course['color1'] as Color, course['color2'] as Color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (course['color1'] as Color).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.11,
                  height: width * 0.11,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    course['icon'] as IconData,
                    color: AppColors.white,
                    size: width * 0.055,
                  ),
                ),
                SizedBox(height: height * 0.008),
                Text(
                  course['name'] as String,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: width * 0.028,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  course['desc'] as String,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: width * 0.02,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



