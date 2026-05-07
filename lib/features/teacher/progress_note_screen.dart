import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/provider/progress_provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/navigation/app_router.dart';

class ProgressNotesScreen extends ConsumerStatefulWidget {
  final String studentName;
  final String studentId;

  const ProgressNotesScreen({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  ConsumerState<ProgressNotesScreen> createState() =>
      _ProgressNotesScreenState();
}

class _ProgressNotesScreenState extends ConsumerState<ProgressNotesScreen> {
  final _progressController = TextEditingController();
  final _coveredController = TextEditingController();
  final _homeworkController = TextEditingController();
  String _selectedRating = 'Good';

  final List<String> _ratings = [
    'Excellent',
    'Good',
    'Average',
    'Needs Improvement',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(progressProvider.notifier)
          .initProgress(widget.studentId, widget.studentName);
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _coveredController.dispose();
    _homeworkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(progressProvider);
    final notifier = ref.read(progressProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        title: Text(
          'Add Progress Note',
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
                height * 0.12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStudentCard(width, height),
                  SizedBox(height: height * 0.025),
                  _buildLabel('Progress', width),
                  _buildTextField(
                    controller: _progressController,
                    hint:
                        'Good progress in recitation. Needs to improve Tajweed on Noon Saakinah.',
                    maxLines: 3,
                    onChanged: notifier.updateProgressNote,
                    width: width,
                  ),
                  SizedBox(height: height * 0.02),
                  _buildLabel('What was covered?', width),
                  _buildTextField(
                    controller: _coveredController,
                    hint: 'Surah Al-Baqarah (Ayat 1-10)',
                    maxLines: 2,
                    onChanged: notifier.updateWhatWasCovered,
                    width: width,
                  ),
                  SizedBox(height: height * 0.02),
                  _buildLabel('Homework', width),
                  _buildTextField(
                    controller: _homeworkController,
                    hint: 'Practice Tajweed - Noon Saakinah rules.',
                    maxLines: 2,
                    onChanged: notifier.updateHomework,
                    width: width,
                  ),
                  SizedBox(height: height * 0.02),
                  _buildLabel('Overall Rating', width),
                  _buildRatingSelector(notifier, width),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildSaveButton(context, state, notifier, width, height),
    );
  }

  Widget _buildStudentCard(double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: width * 0.065,
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
            child: Text(
              widget.studentName[0],
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.055,
              ),
            ),
          ),
          SizedBox(width: width * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: width * 0.042,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Student',
                  style: TextStyle(
                    fontSize: width * 0.033,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, double width) {
    return Padding(
      padding: EdgeInsets.only(bottom: width * 0.02),
      child: Text(
        text,
        style: TextStyle(
          fontSize: width * 0.037,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
    required Function(String) onChanged,
    required double width,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        style: TextStyle(fontSize: width * 0.035),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: width * 0.033,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: EdgeInsets.all(width * 0.035),
        ),
      ),
    );
  }

  Widget _buildRatingSelector(ProgressNotifier notifier, double width) {
    return Wrap(
      spacing: width * 0.025,
      runSpacing: width * 0.025,
      children: _ratings.map((rating) {
        final isSelected = _selectedRating == rating;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedRating = rating);
            notifier.updateRating(rating);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: width * 0.025,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryGreen : AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textLight,
              ),
            ),
            child: Text(
              rating,
              style: TextStyle(
                fontSize: width * 0.033,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textGrey,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    ProgressState state,
    ProgressNotifier notifier,
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.04,
        height * 0.015,
        width * 0.04,
        height * 0.035,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: height * 0.065,
        child: ElevatedButton(
          onPressed: state.isSaving
              ? null
              : () async {
                  await notifier.saveProgress();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Progress note saved!'),
                        backgroundColor: AppColors.primaryGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    context.go(AppRoutes.dashboard);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: state.isSaving
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Save Note',
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

