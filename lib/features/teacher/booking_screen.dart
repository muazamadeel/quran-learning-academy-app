import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';
import 'package:quran_learning_app/models/booking/booking_model.dart';
import 'package:quran_learning_app/provider/booking_provider.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(bookingSelectedTabProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final AsyncValue<List<BookingModel>> asyncList = switch (selectedTab) {
      0 => ref.watch(confirmedBookingsProvider),
      1 => ref.watch(completedBookingsProvider),
      _ => ref.watch(confirmedBookingsProvider),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(
          'Bookings',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.045,
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
          _TopCurve(),
          SizedBox(height: h * 0.01),
          _TabBar(selectedTab: selectedTab, w: w, h: h),
          SizedBox(height: h * 0.01),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(confirmedBookingsProvider);
                ref.invalidate(completedBookingsProvider);
              },
              color: AppColors.primaryGreen,
              child: asyncList.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                ),
                error: (e, _) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: h * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading bookings\n$e',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: w * 0.035,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref.invalidate(confirmedBookingsProvider);
                              ref.invalidate(completedBookingsProvider);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                data: (list) => list.isEmpty
                    ? _EmptyState(tab: selectedTab, w: w, h: h)
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          w * 0.04,
                          h * 0.01,
                          w * 0.04,
                          h * 0.02,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final booking = list[index];
                          return switch (selectedTab) {
                            0 => _ConfirmedBookingCard(
                              booking: booking,
                              w: w,
                              h: h,
                            ),
                            1 => _CompletedBookingCard(
                              booking: booking,
                              w: w,
                              h: h,
                            ),
                            _ => const SizedBox.shrink(),
                          };
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 1),
    );
  }
}

class _TopCurve extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _TabBar extends ConsumerWidget {
  final int selectedTab;
  final double w, h;

  const _TabBar({required this.selectedTab, required this.w, required this.h});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ['Confirmed', 'Completed'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.04),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(bookingSelectedTabProvider.notifier).update(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: h * 0.013),
                decoration: BoxDecoration(
                  color: selectedTab == index
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: w * 0.033,
                    fontWeight: FontWeight.w600,
                    color: selectedTab == index
                        ? AppColors.white
                        : AppColors.textGrey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmedBookingCard extends StatelessWidget {
  final BookingModel booking;
  final double w, h;

  const _ConfirmedBookingCard({
    required this.booking,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.04),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.blue, width: 4)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                _Avatar(
                  name: booking.studentName,
                  imageUrl: booking.studentImage,
                  color: Colors.blue,
                  w: w,
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.studentName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: w * 0.038,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Confirmed',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.012,
            ),
            child: Row(
              children: [
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: booking.date,
                  w: w,
                ),
                SizedBox(width: w * 0.05),
                _InfoRow(
                  icon: Icons.access_time,
                  text: booking.teacherSlotTime.isNotEmpty
                      ? booking.teacherSlotTime
                      : booking.time,
                  w: w,
                ),
                if (booking.durationMinutes != null) ...[
                  SizedBox(width: w * 0.05),
                  _InfoRow(
                    icon: Icons.timer_outlined,
                    text: '${booking.durationMinutes} min',
                    w: w,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedBookingCard extends StatelessWidget {
  final BookingModel booking;
  final double w, h;

  const _CompletedBookingCard({
    required this.booking,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.04),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.green, width: 4)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                _Avatar(
                  name: booking.studentName,
                  imageUrl: booking.studentImage,
                  color: Colors.green,
                  w: w,
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.studentName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: w * 0.038,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
                Icon(Icons.check_circle, color: Colors.green, size: w * 0.05),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.012,
            ),
            child: Row(
              children: [
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: booking.date,
                  w: w,
                ),
                SizedBox(width: w * 0.05),
                _InfoRow(
                  icon: Icons.access_time,
                  text: booking.teacherSlotTime.isNotEmpty
                      ? booking.teacherSlotTime
                      : booking.time,
                  w: w,
                ),
              ],
            ),
          ),
          if (booking.studentRating != null)
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, h * 0.012),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: w * 0.04),
                  const SizedBox(width: 4),
                  Text(
                    booking.studentRating!.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (booking.studentReview != null &&
                      booking.studentReview!.isNotEmpty) ...[
                    SizedBox(width: w * 0.02),
                    Expanded(
                      child: Text(
                        booking.studentReview!,
                        style: TextStyle(
                          fontSize: w * 0.03,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final Color color;
  final double w;

  const _Avatar({
    required this.name,
    required this.imageUrl,
    required this.color,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: w * 0.055,
      backgroundColor: color.withValues(alpha: 0.12),
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: imageUrl.isEmpty
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: w * 0.04,
              ),
            )
          : null,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double w;

  const _InfoRow({required this.icon, required this.text, required this.w});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: w * 0.033, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: w * 0.032, color: Colors.grey[500]),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final int tab;
  final double w, h;

  const _EmptyState({required this.tab, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    final messages = ['No confirmed bookings', 'No completed classes yet'];
    final icons = [Icons.check_circle_outline, Icons.history_outlined];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icons[tab], size: w * 0.16, color: AppColors.textLight),
          SizedBox(height: h * 0.02),
          Text(
            messages[tab],
            style: TextStyle(
              fontSize: w * 0.04,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
