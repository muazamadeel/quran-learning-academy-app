import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/features/teacher/widget/student_bottom_nav.dart';
import 'package:quran_learning_app/features/teacher/widget/student_class_card.dart';
import 'package:quran_learning_app/provider/student/student_schedule_provider.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

class StudentScheduleScreen extends ConsumerWidget {
  const StudentScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentScheduleProvider);
    final authState = ref.watch(authProvider);
    final notifier = ref.read(studentScheduleProvider.notifier);
    final upcomingAsync = ref.watch(upcomingBookingsProvider);
    final completedAsync = ref.watch(completedBookingsProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Tab ke hisaab se current list
    final currentAsync = state.selectedTab == 0
        ? upcomingAsync
        : completedAsync;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        title: Text(
          'My Schedule',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.045,
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
      body: Column(
        children: [
          _buildTopCurve(),
          SizedBox(height: height * 0.01),
          _buildTabBar(context, state.selectedTab, notifier, width, height),
          SizedBox(height: height * 0.01),
          Expanded(
            child: currentAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: width * 0.035,
                  ),
                ),
              ),
              data: (list) => list.isEmpty
                  ? _buildEmptyState(state.selectedTab, width, height)
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        width * 0.04,
                        height * 0.01,
                        width * 0.04,
                        height * 0.02,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final cls = list[index];
                        return StudentClassCard(
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
                                'studentName': authState.user?.name ?? 'Student',
                                'isTeacher': false,
                              },
                            );
                          },
                          onCancel: state.selectedTab == 0
                              ? () => _showCancelDialog(
                                  context,
                                  cls.id,
                                  notifier,
                                  width,
                                )
                              : null,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StudentBottomNav(currentIndex: 2),
    );
  }

  Widget _buildTopCurve() {
    return Container(
      color: AppColors.primaryGreen,
      child: Container(
        height: 24,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(
    BuildContext context,
    int selectedTab,
    StudentScheduleNotifier notifier,
    double width,
    double height,
  ) {
    final tabs = ['Upcoming', 'Completed'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.04),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => notifier.changeTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: height * 0.013),
                decoration: BoxDecoration(
                  color: selectedTab == index
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w600,
                    color: selectedTab == index
                        ? AppColors.white
                        : AppColors.textGrey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(int tab, double width, double height) {
    final messages = ['No upcoming classes', 'No completed classes yet'];
    final icons = [Icons.calendar_today_outlined, Icons.check_circle_outline];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icons[tab], size: width * 0.16, color: AppColors.textLight),
          SizedBox(height: height * 0.02),
          Text(
            messages[tab],
            style: TextStyle(
              fontSize: width * 0.04,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    String classId,
    StudentScheduleNotifier notifier,
    double width,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel Class',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: width * 0.042,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this class?',
          style: TextStyle(fontSize: width * 0.035),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Keep',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: width * 0.035,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.cancelClass(classId);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rejected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Cancel Class',
              style: TextStyle(fontSize: width * 0.035),
            ),
          ),
        ],
      ),
    );
  }
}
