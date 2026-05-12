// lib/features/classroom/class_end_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/provider/progress_teacher_provider.dart';
import 'package:quran_learning_app/provider/student/progress_student_provider.dart';

class ClassEndScreen extends ConsumerStatefulWidget {
  final String studentId;
  final String teacherId;
  final String studentName;
  final bool isTeacher;
  final int durationMinutes;

  const ClassEndScreen({
    super.key,
    required this.studentId,
    required this.teacherId,
    required this.studentName,
    required this.isTeacher,
    required this.durationMinutes,
  });

  @override
  ConsumerState<ClassEndScreen> createState() => _ClassEndScreenState();
}

class _ClassEndScreenState extends ConsumerState<ClassEndScreen> {
  // Teacher notes controllers
  final _progressController = TextEditingController();
  final _coveredController = TextEditingController();
  final _homeworkController = TextEditingController();
  String _rating = 'Good';
  bool _saving = false;
  bool _saved = false;

  final _ratings = ['Excellent', 'Good', 'Average', 'Needs Improvement'];

  @override
  void dispose() {
    _progressController.dispose();
    _coveredController.dispose();
    _homeworkController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes() async {
    if (_progressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write progress notes')),
      );
      return;
    }

    setState(() => _saving = true);

    await ref
        .read(progressTeacherProvider.notifier)
        .addProgress(
          studentId: widget.studentId,
          studentName: widget.studentName,
          teacherId: widget.teacherId,
          teacherName: '',
          progressNote: _progressController.text.trim(),
          whatWasCovered: _coveredController.text.trim(),
          homework: _homeworkController.text.trim(),
          rating: _rating,
        );

    setState(() {
      _saving = false;
      _saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: widget.isTeacher
            ? _TeacherEndView(
                studentName: widget.studentName,
                durationMinutes: widget.durationMinutes,
                progressController: _progressController,
                coveredController: _coveredController,
                homeworkController: _homeworkController,
                rating: _rating,
                ratings: _ratings,
                saving: _saving,
                saved: _saved,
                onRatingChange: (r) => setState(() => _rating = r),
                onSave: _saveNotes,
                onDone: () => context.go(AppRoutes.dashboard),
                w: w,
                h: h,
              )
            : _StudentEndView(
                studentId: widget.studentId,
                durationMinutes: widget.durationMinutes,
                onDone: () => context.go(AppRoutes.studentDashboard),
                w: w,
                h: h,
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TEACHER END VIEW — notes likhne ka form
// ═══════════════════════════════════════════════════════════════════════════════
class _TeacherEndView extends StatelessWidget {
  final String studentName;
  final int durationMinutes;
  final TextEditingController progressController;
  final TextEditingController coveredController;
  final TextEditingController homeworkController;
  final String rating;
  final List<String> ratings;
  final bool saving;
  final bool saved;
  final Function(String) onRatingChange;
  final VoidCallback onSave;
  final VoidCallback onDone;
  final double w, h;

  const _TeacherEndView({
    required this.studentName,
    required this.durationMinutes,
    required this.progressController,
    required this.coveredController,
    required this.homeworkController,
    required this.rating,
    required this.ratings,
    required this.saving,
    required this.saved,
    required this.onRatingChange,
    required this.onSave,
    required this.onDone,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(w * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(w * 0.05),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: w * 0.18,
                  height: w * 0.18,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: w * 0.1,
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  'Class Completed! 🎉',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: h * 0.006),
                Text(
                  'with $studentName • $durationMinutes minutes',
                  style: TextStyle(color: Colors.white70, fontSize: w * 0.033),
                ),
              ],
            ),
          ),

          SizedBox(height: h * 0.03),

          // ── Notes Form ───────────────────────────────────────────────────
          if (!saved) ...[
            Text(
              'Write Progress Notes',
              style: TextStyle(
                fontSize: w * 0.042,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: h * 0.015),

            _InputField(
              controller: progressController,
              label: 'Student Progress',
              hint: 'How did the student perform today?',
              icon: Icons.trending_up,
              maxLines: 3,
              w: w,
            ),
            SizedBox(height: h * 0.015),

            _InputField(
              controller: coveredController,
              label: 'What Was Covered',
              hint: 'Topics covered in this class...',
              icon: Icons.menu_book_outlined,
              maxLines: 2,
              w: w,
            ),
            SizedBox(height: h * 0.015),

            _InputField(
              controller: homeworkController,
              label: 'Homework',
              hint: 'Homework assigned to student...',
              icon: Icons.assignment_outlined,
              maxLines: 2,
              w: w,
            ),

            SizedBox(height: h * 0.02),

            // Rating chips
            Text(
              'Overall Rating',
              style: TextStyle(
                fontSize: w * 0.038,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: h * 0.01),
            Wrap(
              spacing: w * 0.02,
              children: ratings.map((r) {
                final selected = rating == r;
                return GestureDetector(
                  onTap: () => onRatingChange(r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: h * 0.008,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryGreen : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.primaryGreen
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      r,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.textGrey,
                        fontSize: w * 0.033,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: h * 0.03),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving ? null : onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: h * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Save Notes',
                        style: TextStyle(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ] else ...[
            // ── Notes saved confirmation ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(w * 0.06),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: w * 0.14,
                  ),
                  SizedBox(height: h * 0.015),
                  Text(
                    'Notes Saved!',
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: h * 0.006),
                  Text(
                    'Student can now see their progress.',
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: w * 0.033,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.03),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: h * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Back to Dashboard',
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STUDENT END VIEW — progress dekho
// ═══════════════════════════════════════════════════════════════════════════════
class _StudentEndView extends ConsumerWidget {
  final String studentId;
  final int durationMinutes;
  final VoidCallback onDone;
  final double w, h;

  const _StudentEndView({
    required this.studentId,
    required this.durationMinutes,
    required this.onDone,
    required this.w,
    required this.h,
  });

  Color _ratingColor(String rating) {
    switch (rating) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return AppColors.primaryGreen;
      case 'Average':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressStudentProvider(studentId));

    return SingleChildScrollView(
      padding: EdgeInsets.all(w * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(w * 0.05),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: w * 0.18,
                  height: w * 0.18,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school_outlined,
                    color: Colors.white,
                    size: w * 0.1,
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  'Class Completed! 🎉',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: h * 0.006),
                Text(
                  '$durationMinutes minutes of learning',
                  style: TextStyle(color: Colors.white70, fontSize: w * 0.033),
                ),
              ],
            ),
          ),

          SizedBox(height: h * 0.025),

          Text(
            'Your Progress',
            style: TextStyle(
              fontSize: w * 0.042,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          SizedBox(height: h * 0.015),

          // ── Progress notes from teacher ──────────────────────────────
          progressAsync.when(
            loading: () => Container(
              padding: EdgeInsets.all(w * 0.06),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                  SizedBox(height: h * 0.015),
                  Text(
                    'Waiting for teacher\'s notes...',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: w * 0.033,
                    ),
                  ),
                ],
              ),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (notes) {
              if (notes.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(w * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: w * 0.12,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        'Teacher hasn\'t added notes yet',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: w * 0.033,
                        ),
                      ),
                      Text(
                        'Check back soon!',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: w * 0.028,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Latest note (first one)
              final latest = notes.first;

              return Column(
                children: [
                  // Rating card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(w * 0.04),
                    decoration: BoxDecoration(
                      color: _ratingColor(latest.rating).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _ratingColor(latest.rating).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: w * 0.12,
                          height: w * 0.12,
                          decoration: BoxDecoration(
                            color: _ratingColor(latest.rating).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star_rounded,
                            color: _ratingColor(latest.rating),
                            size: w * 0.06,
                          ),
                        ),
                        SizedBox(width: w * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overall Rating',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: w * 0.03,
                              ),
                            ),
                            Text(
                              latest.rating,
                              style: TextStyle(
                                color: _ratingColor(latest.rating),
                                fontSize: w * 0.045,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.015),

                  // Progress note
                  _NoteCard(
                    icon: Icons.trending_up,
                    title: 'Progress',
                    content: latest.progressNote,
                    color: AppColors.primaryGreen,
                    w: w,
                    h: h,
                  ),

                  SizedBox(height: h * 0.01),

                  // What was covered
                  if (latest.whatWasCovered.isNotEmpty)
                    _NoteCard(
                      icon: Icons.menu_book_outlined,
                      title: 'What Was Covered',
                      content: latest.whatWasCovered,
                      color: Colors.blue,
                      w: w,
                      h: h,
                    ),

                  SizedBox(height: h * 0.01),

                  // Homework
                  if (latest.homework.isNotEmpty)
                    _NoteCard(
                      icon: Icons.assignment_outlined,
                      title: 'Homework',
                      content: latest.homework,
                      color: Colors.orange,
                      w: w,
                      h: h,
                    ),
                ],
              );
            },
          ),

          SizedBox(height: h * 0.03),

          // Done button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: h * 0.018),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Back to Dashboard',
                style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          SizedBox(height: h * 0.02),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// NOTE CARD widget
// ═══════════════════════════════════════════════════════════════════════════════
class _NoteCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;
  final double w, h;

  const _NoteCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: w * 0.045),
              SizedBox(width: w * 0.02),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: w * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.008),
          Text(
            content,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: w * 0.033,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// INPUT FIELD widget
// ═══════════════════════════════════════════════════════════════════════════════
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final double w;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.maxLines,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: w * 0.035),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: w * 0.032),
        prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: w * 0.05),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
