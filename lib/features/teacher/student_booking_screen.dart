import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
import 'package:quran_learning_app/provider/student/student_booking_provider.dart';

class StudentBookingScreen extends ConsumerStatefulWidget {
  final TeacherListModel teacher;

  const StudentBookingScreen({super.key, required this.teacher});

  @override
  ConsumerState<StudentBookingScreen> createState() =>
      _StudentBookingScreenState();
}

class _StudentBookingScreenState extends ConsumerState<StudentBookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studentBookingProvider.notifier).initWithTeacher(widget.teacher);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentBookingProvider);
    final notifier = ref.read(studentBookingProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.go(AppRoutes.teacherList),
        ),
        title: Text(
          'Book a Class',
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
                  _buildTeacherHeader(width, height),
                  SizedBox(height: height * 0.025),
                  _buildSectionLabel('Select Date', width),
                  SizedBox(height: height * 0.012),
                  _buildDatePicker(state, notifier, width, height),
                  SizedBox(height: height * 0.025),
                  _buildSectionLabel('Select Time Slot', width),
                  SizedBox(height: height * 0.012),
                  _buildSlotGrid(state, notifier, width, height),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildConfirmButton(context, state, notifier, width, height),
    );
  }

  Widget _buildTeacherHeader(double width, double height) {
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
            radius: width * 0.07,
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
            child: Text(
              widget.teacher.name[0],
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
                  widget.teacher.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: width * 0.042,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: height * 0.004),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: width * 0.035,
                      color: AppColors.gold,
                    ),
                    SizedBox(width: width * 0.01),
                    Text(
                      '${widget.teacher.rating}',
                      style: TextStyle(
                        fontSize: width * 0.032,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: width * 0.025),
                    Text(
                      widget.teacher.experience,
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, double width) {
    return Text(
      label,
      style: TextStyle(
        fontSize: width * 0.04,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildDatePicker(
    StudentBookingState state,
    StudentBookingNotifier notifier,
    double width,
    double height,
  ) {
    return SizedBox(
      height: height * 0.065,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.availableDates.length,
        separatorBuilder: (_, _) => SizedBox(width: width * 0.025),
        itemBuilder: (context, index) {
          final date = state.availableDates[index];
          final isSelected = state.selectedDate == date;
          return GestureDetector(
            onTap: () => notifier.selectDate(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.textLight,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: width * 0.03,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.textGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotGrid(
    StudentBookingState state,
    StudentBookingNotifier notifier,
    double width,
    double height,
  ) {
    if (state.isLoadingSlots) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.05),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    if (state.availableSlots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(width * 0.08),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.textLight.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.event_busy_rounded,
                size: width * 0.12, color: AppColors.textLight),
            SizedBox(height: height * 0.01),
            Text(
              'No slots available',
              style: TextStyle(
                fontSize: width * 0.035,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * 0.03,
        mainAxisSpacing: width * 0.03,
        childAspectRatio: 2.2,
      ),
      itemCount: state.availableSlots.length,
      itemBuilder: (context, index) {
        final slot = state.availableSlots[index];
        final isSelected = slot.isSelected;
        final isBooked = !slot.isAvailable;

        return GestureDetector(
          onTap: isBooked ? null : () => notifier.selectSlot(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.025,
              vertical: height * 0.008,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppColors.primaryGreen, AppColors.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected
                  ? null
                  : isBooked
                      ? AppColors.rejected.withValues(alpha: 0.05)
                      : AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                width: isSelected ? 1.5 : 1,
                color: isSelected
                    ? AppColors.primaryGreen
                    : isBooked
                        ? AppColors.rejected.withValues(alpha: 0.2)
                        : AppColors.textLight.withValues(alpha: 0.5),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Clock icon
                Container(
                  width: width * 0.085,
                  height: width * 0.085,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : isBooked
                            ? AppColors.rejected.withValues(alpha: 0.08)
                            : AppColors.primaryGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isBooked
                        ? Icons.event_busy_rounded
                        : isSelected
                            ? Icons.check_circle_rounded
                            : Icons.access_time_rounded,
                    size: width * 0.045,
                    color: isSelected
                        ? AppColors.white
                        : isBooked
                            ? AppColors.rejected.withValues(alpha: 0.5)
                            : AppColors.primaryGreen,
                  ),
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slot.time,
                        style: TextStyle(
                          fontSize: width * 0.028,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.white
                              : isBooked
                                  ? AppColors.textLight
                                  : AppColors.textDark,
                          decoration: isBooked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        isBooked
                            ? 'Booked'
                            : isSelected
                                ? '✓ Selected'
                                : '30 min',
                        style: TextStyle(
                          fontSize: width * 0.023,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : isBooked
                                  ? AppColors.rejected
                                  : AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton(
    BuildContext context,
    StudentBookingState state,
    StudentBookingNotifier notifier,
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
          onPressed: (!state.canBook || state.isBooking)
              ? null
              : () async {
                  await notifier.confirmBooking();
                  if (context.mounted) {
                    _showConfirmDialog(context, state, width);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.textLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: state.isBooking
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    StudentBookingState state,
    double width,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: width * 0.1,
              backgroundColor: AppColors.success.withValues(alpha: 0.1),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: width * 0.12,
              ),
            ),
            SizedBox(height: width * 0.04),
            Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: width * 0.045,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: width * 0.02),
            Text(
              'Your class with ${widget.teacher.name} on ${state.selectedDate} at ${state.selectedSlot?.time} is confirmed.',
              style: TextStyle(
                fontSize: width * 0.033,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: width * 0.05),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.studentSchedule);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: width * 0.035),
                ),
                child: Text(
                  'View Schedule',
                  style: TextStyle(
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

