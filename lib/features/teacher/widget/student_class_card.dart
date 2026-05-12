import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

class StudentClassCard extends StatefulWidget {
  final StudentUpcomingClassModel classModel;
  final VoidCallback onJoin;
  final VoidCallback? onCancel;

  const StudentClassCard({
    super.key,
    required this.classModel,
    required this.onJoin,
    this.onCancel,
  });

  @override
  State<StudentClassCard> createState() => _StudentClassCardState();
}

class _StudentClassCardState extends State<StudentClassCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _countdownLabel() {
    final at = widget.classModel.scheduledAt;
    if (at == null) return '';
    final diff = at.difference(DateTime.now());
    if (diff.isNegative) {
      if (diff.abs() <= const Duration(minutes: 30)) {
        return 'Class window open';
      }
      return '';
    }
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    final s = diff.inSeconds.remainder(60);
    if (h > 0) return 'Starts in ${h}h ${m}m';
    if (m > 0) return 'Starts in ${m}m ${s}s';
    return 'Starts in ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final classModel = widget.classModel;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isCompleted = classModel.status == 'completed';
    final initial = classModel.teacherName.isNotEmpty
        ? classModel.teacherName[0].toUpperCase()
        : '?';
    final countdown = _countdownLabel();

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.all(width * 0.035),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: width * 0.06,
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
            child: Text(
              initial,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.045,
              ),
            ),
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classModel.teacherName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.038,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: height * 0.006),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: width * 0.03,
                      color: AppColors.textGrey,
                    ),
                    SizedBox(width: width * 0.01),
                    Expanded(
                      child: Text(
                        '${classModel.date}, ${classModel.time}',
                        style: TextStyle(
                          fontSize: width * 0.03,
                          color: AppColors.textGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                if (countdown.isNotEmpty) ...[
                  SizedBox(height: height * 0.004),
                  Text(
                    countdown,
                    style: TextStyle(
                      fontSize: width * 0.027,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: width * 0.02),
          if (!isCompleted)
            Column(
              children: [
                ElevatedButton(
                  onPressed: widget.onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.012,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Join',
                    style: TextStyle(fontSize: width * 0.035),
                  ),
                ),
                if (widget.onCancel != null) ...[
                  SizedBox(height: height * 0.006),
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: width * 0.028,
                        color: AppColors.rejected,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: width * 0.015,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  fontSize: width * 0.03,
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
