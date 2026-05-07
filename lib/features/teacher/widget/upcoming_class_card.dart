import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';

import 'package:quran_learning_app/models/teacher_class_model.dart';

class UpcomingClassCard extends StatefulWidget {
  final TeacherClassModel classModel;
  final VoidCallback onJoin;

  const UpcomingClassCard({
    super.key,
    required this.classModel,
    required this.onJoin,
  });

  @override
  State<UpcomingClassCard> createState() => _UpcomingClassCardState();
}

class _UpcomingClassCardState extends State<UpcomingClassCard> {
  Timer? _timer;
  Duration _timeLeft = const Duration();

  @override
  void initState() {
    super.initState();
    if (widget.classModel.status != 'completed') {
      // Mock duration for dummy data - random between 10 to 60 mins
      _timeLeft = Duration(
        minutes: 15 + (widget.classModel.id.hashCode % 45),
        seconds: 0,
      );
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTimeLeft {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(_timeLeft.inHours);
    String minutes = twoDigits(_timeLeft.inMinutes.remainder(60));
    String seconds = twoDigits(_timeLeft.inSeconds.remainder(60));
    if (_timeLeft.inHours > 0) {
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isCompleted = widget.classModel.status == 'completed';

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
            backgroundColor: isCompleted
                ? Colors.grey.withValues(alpha: 0.1)
                : AppColors.primaryGreen.withValues(alpha: 0.1),
            child: Text(
              widget.classModel.studentName[0],
              style: TextStyle(
                color: isCompleted ? Colors.grey : AppColors.primaryGreen,
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
                  widget.classModel.studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.038,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: height * 0.005),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.classModel.scheduledAt.hour}:${widget.classModel.scheduledAt.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: width * 0.032,
                          color: AppColors.textGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (!isCompleted)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 12,
                              color: AppColors.primaryGreen,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _formattedTimeLeft,
                              style: TextStyle(
                                fontSize: width * 0.028,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: width * 0.02),

          // Join button
          if (!isCompleted)
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
              child: Text('Join', style: TextStyle(fontSize: width * 0.035)),
            )
          else
            Icon(
              Icons.check_circle,
              color: AppColors.primaryGreen,
              size: width * 0.07,
            ),
        ],
      ),
    );
  }
}
