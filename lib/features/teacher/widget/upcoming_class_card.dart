import 'package:flutter/material.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/teacher/teacher_model.dart';

class UpcomingClassCard extends StatelessWidget {
  final UpcomingClassModel classModel;
  final VoidCallback onJoin;

  const UpcomingClassCard({
    super.key,
    required this.classModel,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.all(width * 0.035),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: width * 0.06,
            backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
            child: Text(
              classModel.studentName[0],
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.045,
              ),
            ),
          ),
          SizedBox(width: width * 0.03),

          // Expanded — overflow fix
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classModel.studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.038,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: height * 0.005),
                Text(
                  classModel.time,
                  style: TextStyle(
                    fontSize: width * 0.032,
                    color: AppColors.textGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          SizedBox(width: width * 0.02),

          // Join button
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
          ),
        ],
      ),
    );
  }
}
