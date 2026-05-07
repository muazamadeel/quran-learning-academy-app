import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/features/teacher/widget/student_bottom_nav.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_card.dart';
import 'package:quran_learning_app/provider/student/teacher_list_provider.dart';

class TeacherListScreen extends ConsumerStatefulWidget {
  final String selectedCourse;

  const TeacherListScreen({super.key, this.selectedCourse = ''});

  @override
  ConsumerState<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends ConsumerState<TeacherListScreen> {
  String _activeCourse = '';

  static const List<String> _courses = [
    'All',
    'Tajweed',
    'Hifz',
    'Quran Reading',
    'Tafseer',
    'Arabic Language',
    'Islamic Studies',
    'Noorani Qaida',
  ];

  static const Map<String, IconData> _courseIcons = {
    'All': Icons.apps_rounded,
    'Tajweed': Icons.record_voice_over_rounded,
    'Hifz': Icons.favorite_rounded,
    'Quran Reading': Icons.auto_stories_rounded,
    'Tafseer': Icons.lightbulb_rounded,
    'Arabic Language': Icons.translate_rounded,
    'Islamic Studies': Icons.mosque_rounded,
    'Noorani Qaida': Icons.abc_rounded,
  };

  @override
  void initState() {
    super.initState();
    _activeCourse = widget.selectedCourse.isNotEmpty
        ? widget.selectedCourse
        : 'All';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teacherListProvider);
    final notifier = ref.read(teacherListProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Filter teachers by selected course
    final filteredBySearch = state.filteredTeachers;
    final displayTeachers = _activeCourse == 'All'
        ? filteredBySearch
        : filteredBySearch
              .where((t) => t.subjects.contains(_activeCourse))
              .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.go(AppRoutes.studentDashboard),
        ),
        title: Text(
          _activeCourse == 'All' ? 'Find a Teacher' : '$_activeCourse Teachers',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              children: [
                _buildSearchBar(notifier, width, height),
                SizedBox(height: height * 0.012),
                _buildCourseFilters(width, height),
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : displayTeachers.isEmpty
                ? _buildEmptyState(width, height)
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      width * 0.04,
                      height * 0.01,
                      width * 0.04,
                      height * 0.02,
                    ),
                    itemCount: displayTeachers.length,
                    itemBuilder: (context, index) {
                      final teacher = displayTeachers[index];
                      return TeacherCard(
                        teacher: teacher,
                        onBook: () {
                          context.go(
                            AppRoutes.studentBooking,
                            extra: {'teacher': teacher},
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const StudentBottomNav(currentIndex: 1),
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

  Widget _buildSearchBar(
    TeacherListNotifier notifier,
    double width,
    double height,
  ) {
    return Container(
      height: height * 0.058,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: TextField(
        onChanged: notifier.search,
        style: TextStyle(fontSize: width * 0.035),
        decoration: InputDecoration(
          hintText: 'Search by name...',
          hintStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: width * 0.033,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textGrey,
            size: width * 0.05,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: height * 0.017),
        ),
      ),
    );
  }

  Widget _buildCourseFilters(double width, double height) {
    return SizedBox(
      height: height * 0.048,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _courses.length,
        separatorBuilder: (_, _) => SizedBox(width: width * 0.02),
        itemBuilder: (context, index) {
          final course = _courses[index];
          final isSelected = _activeCourse == course;
          return GestureDetector(
            onTap: () => setState(() => _activeCourse = course),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: width * 0.035),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [AppColors.primaryGreen, AppColors.lightGreen],
                      )
                    : null,
                color: isSelected ? null : AppColors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.textLight,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _courseIcons[course] ?? Icons.book,
                    size: width * 0.035,
                    color: isSelected ? AppColors.white : AppColors.textGrey,
                  ),
                  SizedBox(width: width * 0.012),
                  Text(
                    course,
                    style: TextStyle(
                      fontSize: width * 0.028,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(double width, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: width * 0.16,
            color: AppColors.textLight,
          ),
          SizedBox(height: height * 0.02),
          Text(
            _activeCourse == 'All'
                ? 'No teachers found'
                : 'No $_activeCourse teachers found',
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
}

