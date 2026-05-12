import 'package:flutter/material.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

class TeacherCard extends StatelessWidget {
  final TeacherListModel teacher;
  final VoidCallback onBook;

  const TeacherCard({super.key, required this.teacher, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Count available days and build schedule summary
    final availableDays = <String>[];
    String sampleTime = '';
    teacher.availability.forEach((day, v) {
      if (v is Map && v['enabled'] == true) {
        availableDays.add(day.substring(0, 3));
        if (sampleTime.isEmpty) {
          sampleTime = '${v['startTime']} - ${v['endTime']}';
        }
      }
    });

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────
          Row(
            children: [
              // Avatar with gradient ring
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.gold],
                  ),
                ),
                child: CircleAvatar(
                  radius: width * 0.07,
                  backgroundColor: AppColors.white,
                  child: CircleAvatar(
                    radius: width * 0.065,
                    backgroundColor: AppColors.primaryGreen.withValues(
                      alpha: 0.1,
                    ),
                    child: Text(
                      teacher.name.isNotEmpty ? teacher.name[0] : '?',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.05,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            teacher.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.04,
                              color: AppColors.textDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.022,
                            vertical: width * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: teacher.isAvailable
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.textLight.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width * 0.018,
                                height: width * 0.018,
                                decoration: BoxDecoration(
                                  color: teacher.isAvailable
                                      ? AppColors.success
                                      : AppColors.textGrey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                teacher.isAvailable ? 'Available' : 'Busy',
                                style: TextStyle(
                                  fontSize: width * 0.025,
                                  fontWeight: FontWeight.w600,
                                  color: teacher.isAvailable
                                      ? AppColors.success
                                      : AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.003),
                    // Country + Experience
                    Row(
                      children: [
                        if (teacher.country.isNotEmpty) ...[
                          Icon(
                            Icons.location_on_outlined,
                            size: width * 0.032,
                            color: AppColors.textGrey,
                          ),
                          SizedBox(width: width * 0.005),
                          Text(
                            teacher.country,
                            style: TextStyle(
                              fontSize: width * 0.028,
                              color: AppColors.textGrey,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                        ],
                        if (teacher.experience.isNotEmpty) ...[
                          Icon(
                            Icons.work_outline,
                            size: width * 0.03,
                            color: AppColors.textGrey,
                          ),
                          SizedBox(width: width * 0.005),
                          Text(
                            teacher.experience,
                            style: TextStyle(
                              fontSize: width * 0.028,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: height * 0.003),
                    // Languages
                    if (teacher.languages.isNotEmpty)
                      Text(
                        teacher.languages.join(' · '),
                        style: TextStyle(
                          fontSize: width * 0.027,
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
          SizedBox(height: height * 0.012),

          // ── Subjects ────────────────────────────────────────────
          // if (teacher.subjects.isNotEmpty) ...[
          //   Wrap(
          //     spacing: width * 0.02,
          //     runSpacing: width * 0.015,
          //     children: teacher.subjects.map((subject) {
          //       return Container(
          //         padding: EdgeInsets.symmetric(
          //           horizontal: width * 0.03,
          //           vertical: width * 0.012,
          //         ),
          //         decoration: BoxDecoration(
          //           color: AppColors.primaryGreen.withValues(alpha: 0.08),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: Text(
          //           subject,
          //           style: TextStyle(
          //             fontSize: width * 0.028,
          //             color: AppColors.primaryGreen,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // SizedBox(height: height * 0.012),
          // ],

          // ── Schedule info ───────────────────────────────────────
          if (availableDays.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.035,
                vertical: height * 0.01,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.textLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: width * 0.04,
                    color: AppColors.primaryGreen,
                  ),
                  SizedBox(width: width * 0.02),
                  // Day chips
                  Expanded(
                    child: Wrap(
                      spacing: width * 0.012,
                      children:
                          ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map(
                            (d) {
                              final isActive = availableDays.contains(d);
                              return Container(
                                width: width * 0.075,
                                padding: EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primaryGreen
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    d,
                                    style: TextStyle(
                                      fontSize: width * 0.022,
                                      fontWeight: FontWeight.w700,
                                      color: isActive
                                          ? AppColors.white
                                          : AppColors.textLight,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                    ),
                  ),
                ],
              ),
            ),

          if (sampleTime.isNotEmpty) ...[
            SizedBox(height: height * 0.006),
            Row(
              children: [
                SizedBox(width: width * 0.01),
                Icon(
                  Icons.access_time_rounded,
                  size: width * 0.033,
                  color: AppColors.gold,
                ),
                SizedBox(width: width * 0.015),
                Text(
                  sampleTime,
                  style: TextStyle(
                    fontSize: width * 0.028,
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: height * 0.014),

          // ── Book Button ─────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: teacher.isAvailable ? onBook : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.textLight,
                padding: EdgeInsets.symmetric(vertical: height * 0.015),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    teacher.isAvailable
                        ? Icons.calendar_today_rounded
                        : Icons.block,
                    size: width * 0.04,
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    teacher.isAvailable ? 'Book Class' : 'Unavailable',
                    style: TextStyle(
                      fontSize: width * 0.036,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
