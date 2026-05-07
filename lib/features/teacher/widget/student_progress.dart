import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/features/teacher/widget/student_bottom_nav.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
import 'package:quran_learning_app/provider/student/student_progress_provider.dart';

class StudentProgressScreen extends ConsumerWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentProgressProvider);
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
        title: Text(
          'My Progress',
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
          Container(
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
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                width * 0.04,
                height * 0.01,
                width * 0.04,
                height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow(
                    state.totalClassesCompleted,
                    state.currentStreak,
                    width,
                    height,
                  ),
                  SizedBox(height: height * 0.025),
                  Text(
                    'Progress Notes',
                    style: TextStyle(
                      fontSize: width * 0.042,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  if (state.progressNotes.isEmpty)
                    _buildEmptyState(width, height)
                  else
                    ...state.progressNotes.map(
                      (note) => _buildProgressCard(note, width, height),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StudentBottomNav(currentIndex: 3),
    );
  }

  Widget _buildSummaryRow(
    int totalClasses,
    int streak,
    double width,
    double height,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.check_circle_outline,
            label: 'Classes Done',
            value: '$totalClasses',
            color: AppColors.primaryGreen,
            width: width,
            height: height,
          ),
        ),
        SizedBox(width: width * 0.03),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.local_fire_department_outlined,
            label: 'Day Streak',
            value: '$streak',
            color: AppColors.gold,
            width: width,
            height: height,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double width,
    required double height,
  }) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.025),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: width * 0.055),
          ),
          SizedBox(width: width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: width * 0.028,
                    color: AppColors.textGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    StudentProgressModel note,
    double width,
    double height,
  ) {
    Color ratingColor;
    switch (note.rating) {
      case 'Excellent':
        ratingColor = AppColors.success;
        break;
      case 'Good':
        ratingColor = AppColors.primaryGreen;
        break;
      case 'Average':
        ratingColor = AppColors.pending;
        break;
      default:
        ratingColor = AppColors.rejected;
    }

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: width * 0.055,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                child: Text(
                  note.teacherName[0],
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                  ),
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.teacherName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.037,
                        color: AppColors.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: width * 0.03,
                          color: AppColors.gold,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          note.subject,
                          style: TextStyle(
                            fontSize: width * 0.029,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: width * 0.025),
                        Icon(
                          Icons.access_time,
                          size: width * 0.03,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: width * 0.01),
                        Expanded(
                          child: Text(
                            note.date,
                            style: TextStyle(
                              fontSize: width * 0.029,
                              color: AppColors.textGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025,
                  vertical: width * 0.012,
                ),
                decoration: BoxDecoration(
                  color: ratingColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ratingColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  note.rating,
                  style: TextStyle(
                    fontSize: width * 0.028,
                    color: ratingColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.012),
          _buildNoteRow(
            Icons.notes_outlined,
            'Progress',
            note.progressNote,
            width,
          ),
          SizedBox(height: height * 0.008),
          _buildNoteRow(
            Icons.book_outlined,
            'Covered',
            note.whatWasCovered,
            width,
          ),
          SizedBox(height: height * 0.008),
          _buildNoteRow(
            Icons.assignment_outlined,
            'Homework',
            note.homework,
            width,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteRow(
    IconData icon,
    String label,
    String value,
    double width,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: width * 0.035, color: AppColors.textGrey),
        SizedBox(width: width * 0.02),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontSize: width * 0.031,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: width * 0.031,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(double width, double height) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: height * 0.05),
          Icon(
            Icons.bar_chart_outlined,
            size: width * 0.16,
            color: AppColors.textLight,
          ),
          SizedBox(height: height * 0.02),
          Text(
            'No progress notes yet',
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

