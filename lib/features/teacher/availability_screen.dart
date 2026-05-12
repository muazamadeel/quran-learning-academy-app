// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:quran_learning_app/core/theme/app_theme.dart';
// import 'package:quran_learning_app/features/teacher/widget/day_availability_tile.dart';
// import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';
// import 'package:quran_learning_app/provider/availability_provider.dart';

// class AvailabilityScreen extends ConsumerWidget {
//   const AvailabilityScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(availabilityProvider);
//     final notifier = ref.read(availabilityProvider.notifier);
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryGreen,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: AppColors.white),
//           onPressed: () {},
//         ),
//         title: Text(
//           'Set Availability',
//           style: TextStyle(
//             color: AppColors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: width * 0.045,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.notifications_outlined,
//               color: AppColors.white,
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildTopCurve(),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.fromLTRB(
//                 width * 0.04,
//                 height * 0.01,
//                 width * 0.04,
//                 height * 0.12,
//               ),
//               itemCount: state.days.length,
//               itemBuilder: (context, index) {
//                 final day = state.days[index];
//                 return DayAvailabilityTile(
//                   day: day,
//                   index: index,
//                   onToggle: () => notifier.toggleDay(index),
//                   onTimeChanged: (time) =>
//                       notifier.updateTimeRange(index, time),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomSheet: _buildSaveButton(context, state, notifier, width, height),
//       bottomNavigationBar: const TeacherBottomNav(currentIndex: 2),
//     );
//   }

//   Widget _buildTopCurve() {
//     return Container(
//       width: double.infinity,
//       color: AppColors.primaryGreen,
//       child: Container(
//         height: 24,
//         decoration: const BoxDecoration(
//           color: AppColors.background,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSaveButton(
//     BuildContext context,
//     AvailabilityState state,
//     AvailabilityNotifier notifier,
//     double width,
//     double height,
//   ) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         width * 0.04,
//         height * 0.015,
//         width * 0.04,
//         height * 0.035,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.08),
//             blurRadius: 12,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SizedBox(
//         width: double.infinity,
//         height: height * 0.065,
//         child: ElevatedButton(
//           onPressed: state.isSaving
//               ? null
//               : () async {
//                   await notifier.saveAvailability();
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: const Text('Availability saved successfully!'),
//                         backgroundColor: AppColors.primaryGreen,
//                         behavior: SnackBarBehavior.floating,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     );
//                   }
//                 },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primaryGreen,
//             foregroundColor: AppColors.white,
//             disabledBackgroundColor: AppColors.textLight,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//             elevation: 0,
//           ),
//           child: state.isSaving
//               ? const SizedBox(
//                   height: 22,
//                   width: 22,
//                   child: CircularProgressIndicator(
//                     color: AppColors.white,
//                     strokeWidth: 2.5,
//                   ),
//                 )
//               : Text(
//                   'Save Availability',
//                   style: TextStyle(
//                     fontSize: width * 0.042,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/features/teacher/widget/day_availability_tile.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';
import 'package:quran_learning_app/provider/availability_provider.dart';

class AvailabilityScreen extends ConsumerWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(availabilityProvider);
    final teacherTz = (state as dynamic).teacherTimezone as String? ?? '';
    final notifier = ref.read(availabilityProvider.notifier);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
          'Set Availability',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.045,
          ),
        ),
        actions: [
          // ── Timezone badge ──────────────────────────────
          if (teacherTz.isNotEmpty)
            Center(
              child: Container(
                margin: EdgeInsets.only(right: w * 0.02),
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.025,
                  vertical: h * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      color: AppColors.white,
                      size: w * 0.035,
                    ),
                    SizedBox(width: w * 0.01),
                    Text(
                      _shortTz(teacherTz),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: w * 0.028,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          // ── Timezone info banner ──────────────────────────
          if (teacherTz.isNotEmpty)
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(w * 0.04, h * 0.012, w * 0.04, 0),
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.012,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.public,
                    color: AppColors.primaryGreen,
                    size: w * 0.045,
                  ),
                  SizedBox(width: w * 0.025),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Timezone',
                          style: TextStyle(
                            fontSize: w * 0.028,
                            color: AppColors.textGrey,
                          ),
                        ),
                        Text(
                          teacherTz,
                          style: TextStyle(
                            fontSize: w * 0.033,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Students will see\ntimes in their zone',
                    style: TextStyle(
                      fontSize: w * 0.025,
                      color: AppColors.textGrey,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.01,
                w * 0.04,
                h * 0.12,
              ),
              itemCount: state.days.length,
              itemBuilder: (context, index) {
                final day = state.days[index];
                return DayAvailabilityTile(
                  day: day,
                  index: index,
                  onToggle: () => notifier.toggleDay(index),
                  onTimeChanged: (time) =>
                      notifier.updateTimeRange(index, time),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: _buildSaveButton(context, state, notifier, w, h),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 2),
    );
  }

  // "America/New_York" → "New York"
  String _shortTz(String tz) {
    final parts = tz.split('/');
    return parts.last.replaceAll('_', ' ');
  }

  Widget _buildTopCurve() {
    return Container(
      width: double.infinity,
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

  Widget _buildSaveButton(
    BuildContext context,
    AvailabilityState state,
    AvailabilityNotifier notifier,
    double w,
    double h,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.015, w * 0.04, h * 0.035),
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
        height: h * 0.065,
        child: ElevatedButton(
          onPressed: state.isSaving
              ? null
              : () async {
                  await notifier.saveAvailability();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Availability saved successfully!'),
                        backgroundColor: AppColors.primaryGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
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
          child: state.isSaving
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Save Availability',
                  style: TextStyle(
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
