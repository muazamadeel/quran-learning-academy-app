import 'package:flutter/material.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

class StudentClassCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isCompleted = classModel.status == 'completed';

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
              classModel.teacherName[0],
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
                SizedBox(height: height * 0.004),
                Row(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: width * 0.03,
                      color: AppColors.gold,
                    ),
                    SizedBox(width: width * 0.01),
                    Text(
                      classModel.subject,
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.003),
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
              ],
            ),
          ),
          SizedBox(width: width * 0.02),
          if (!isCompleted)
            ElevatedButton(
              onPressed: onJoin,
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
              child: Text('Join', style: TextStyle(fontSize: width * 0.035)),
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
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
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

