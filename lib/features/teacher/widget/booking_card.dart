import 'package:flutter/material.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/booking/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const BookingCard({
    super.key,
    required this.booking,
    this.onAccept,
    this.onReject,
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            children: [
              CircleAvatar(
                radius: width * 0.06,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                child: Text(
                  booking.studentName[0],
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
                      booking.studentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.038,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: height * 0.004),

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
                            '${booking.date}, ${booking.time}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: width * 0.03,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.003),

                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: width * 0.03,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: width * 0.01),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ACTIONS
          if (booking.status == 'pending') ...[
            SizedBox(height: height * 0.012),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionButton(
                  label: 'Accept',
                  color: AppColors.primaryGreen,
                  width: width,
                  height: height,
                  onTap: onAccept,
                ),
                SizedBox(width: width * 0.02),
                _ActionButton(
                  label: 'Reject',
                  color: AppColors.rejected,
                  width: width,
                  height: height,
                  onTap: onReject,
                ),
              ],
            ),
          ],

          if (booking.status == 'confirmed') ...[
            SizedBox(height: height * 0.012),
            Align(
              alignment: Alignment.centerRight,
              child: _StatusBadge(
                label: 'Confirmed',
                color: AppColors.success,
                width: width,
              ),
            ),
          ],

          if (booking.status == 'completed') ...[
            SizedBox(height: height * 0.012),
            Align(
              alignment: Alignment.centerRight,
              child: _StatusBadge(
                label: 'Completed',
                color: AppColors.textGrey,
                width: width,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.width,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.01,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontSize: width * 0.032,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final double width;

  const _StatusBadge({
    required this.label,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.015,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: width * 0.032,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
