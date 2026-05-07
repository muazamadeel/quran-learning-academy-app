import 'package:flutter/material.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/availabilty/availabilty_model.dart';

class DayAvailabilityTile extends StatelessWidget {
  final DayAvailabilityModel day;
  final int index;
  final VoidCallback onToggle;
  final Function(String) onTimeChanged;

  const DayAvailabilityTile({
    super.key,
    required this.day,
    required this.index,
    required this.onToggle,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.018,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Day name — fixed width proportional
          SizedBox(
            width: width * 0.24,
            child: Text(
              day.day,
              style: TextStyle(
                fontSize: width * 0.037,
                fontWeight: FontWeight.w600,
                color: day.isEnabled ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ),

          // Time range — Expanded overflow fix
          Expanded(
            child: Text(
              day.isEnabled ? day.timeRange : 'Not Available',
              style: TextStyle(
                fontSize: width * 0.03,
                color: day.isEnabled ? AppColors.textGrey : AppColors.textLight,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          // Toggle switch
          Transform.scale(
            scale: width < 360 ? 0.75 : 0.85,
            child: Switch(
              value: day.isEnabled,
              onChanged: (_) => onToggle(),
              activeThumbColor: AppColors.white,
              activeTrackColor: AppColors.primaryGreen,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

