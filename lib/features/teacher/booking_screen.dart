import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/features/teacher/widget/booking_card.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';
import 'package:quran_learning_app/provider/booking_provider.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingProvider);
    final notifier = ref.read(bookingProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        title: Text(
          'Bookings',
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
          _buildTopCurve(),
          SizedBox(height: height * 0.01),
          _buildTabBar(context, state.selectedTab, notifier, width, height),
          SizedBox(height: height * 0.01),
          Expanded(
            child: state.currentList.isEmpty
                ? _buildEmptyState(state.selectedTab, width, height)
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      width * 0.04,
                      height * 0.01,
                      width * 0.04,
                      height * 0.02,
                    ),
                    itemCount: state.currentList.length,
                    itemBuilder: (context, index) {
                      final booking = state.currentList[index];
                      return BookingCard(
                        booking: booking,
                        onAccept: booking.status == 'pending'
                            ? () => notifier.acceptBooking(booking.id)
                            : null,
                        onReject: booking.status == 'pending'
                            ? () => _showRejectDialog(
                                context,
                                booking.id,
                                notifier,
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 1),
    );
  }

  Widget _buildTopCurve() {
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

  Widget _buildTabBar(
    BuildContext context,
    int selectedTab,
    BookingNotifier notifier,
    double width,
    double height,
  ) {
    final tabs = ['Pending', 'Confirmed', 'Completed'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.04),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => notifier.changeTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: height * 0.013),
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
                    fontSize: width * 0.033,
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

  Widget _buildEmptyState(int tab, double width, double height) {
    final messages = [
      'No pending bookings',
      'No confirmed bookings',
      'No completed classes yet',
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: width * 0.16,
            color: AppColors.textLight,
          ),
          SizedBox(height: height * 0.02),
          Text(
            messages[tab],
            style: TextStyle(
              fontSize: width * 0.04,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(
    BuildContext context,
    String bookingId,
    BookingNotifier notifier,
  ) {
    final width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reject Booking',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: width * 0.042,
          ),
        ),
        content: Text(
          'Are you sure you want to reject this booking?',
          style: TextStyle(fontSize: width * 0.035),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: width * 0.035,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.rejectBooking(bookingId);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rejected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Reject', style: TextStyle(fontSize: width * 0.035)),
          ),
        ],
      ),
    );
  }
}
