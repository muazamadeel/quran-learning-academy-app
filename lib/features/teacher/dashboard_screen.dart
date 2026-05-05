import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/features/teacher/widget/stats_card.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';
import 'package:quran_learning_app/features/teacher/widget/upcoming_class_card.dart';
import 'package:quran_learning_app/provider/teacher_provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/navigation/app_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teacherDashboardProvider);
    final teacher = state.teacher;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: teacher == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(teacher.name, width, height),
                  SizedBox(height: height * 0.025),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: width * 0.03,
                      mainAxisSpacing: width * 0.03,
                      childAspectRatio: 1.2, // ✅ replace fixed height
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final List<StatsCard> cards = [
                        StatsCard(
                          title: 'Total Students',
                          value: '${teacher.totalStudents}',
                          icon: Icons.people_outline,
                        ),
                        StatsCard(
                          title: "Today's Classes",
                          value: '${teacher.todayClasses}',
                          icon: Icons.menu_book_outlined,
                        ),
                        StatsCard(
                          title: 'Month Earnings',
                          value: '\$${teacher.monthEarnings.toInt()}',
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                        StatsCard(
                          title: 'Rating',
                          value: '${teacher.rating}',
                          icon: Icons.star_outline,
                        ),
                      ];
                      return cards[index];
                    },
                  ),

                  SizedBox(height: height * 0.025),
                  Text(
                    'Upcoming Classes',
                    style: TextStyle(
                      fontSize: width * 0.042,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  ...state.upcomingClasses.map(
                    (cls) => UpcomingClassCard(
                      classModel: cls,
                      onJoin: () {
                        context.go(
                          AppRoutes.classroom,
                          extra: {
                            'studentName': cls.studentName,
                            'subject': cls.subject,
                            'time': cls.time,
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),
    );
  }

  Widget _buildWelcomeCard(String name, double width, double height) {
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
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
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
}
