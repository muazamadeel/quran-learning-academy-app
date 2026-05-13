// // lib/features/teacher/screens/dashboard_screen.dart

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:quran_learning_app/core/navigation/app_router.dart';
// import 'package:quran_learning_app/core/theme/app_theme.dart';
// import 'package:quran_learning_app/core/widgets/app_drawer.dart';
// import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';
// import 'package:quran_learning_app/models/teacher_class_model.dart';

// import 'package:quran_learning_app/provider/teacher_dashboard_provider.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final teacherAsync = ref.watch(teacherProfileProvider);
//     final stats = ref.watch(dashboardStatsProvider);
//     final upcoming = ref.watch(filteredUpcomingProvider);
//     final completed =
//         ref.watch(completedClassesProvider).asData?.value ??
//         <TeacherClassModel>[];

//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryGreen,
//         elevation: 0,
//         title: Text(
//           'Dashboard',
//           style: TextStyle(
//             color: AppColors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: w * 0.045,
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
//       body: teacherAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text('Error: $e')),
//         data: (teacher) => SingleChildScrollView(
//           padding: EdgeInsets.all(w * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Welcome Card ──────────────────────────────────────────
//               _WelcomeCard(name: teacher?.name ?? '', w: w, h: h),
//               SizedBox(height: h * 0.02),

//               // ── Search Bar ────────────────────────────────────────────
//               _SearchBar(w: w, h: h),
//               SizedBox(height: h * 0.02),

//               // ── 4 Stats Cards ─────────────────────────────────────────
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2,
//                 crossAxisSpacing: w * 0.03,
//                 mainAxisSpacing: w * 0.03,
//                 childAspectRatio: 1.25,
//                 children: [
//                   _StatsCard(
//                     title: 'Overall Classes',
//                     value:
//                         '${stats['upcomingCount']! + stats['completedCount']!}',
//                     icon: Icons.menu_book_outlined,
//                     color: const Color(0xFF1565C0),
//                     w: w,
//                   ),
//                   _StatsCard(
//                     title: "Today's Classes",
//                     value: '${stats['todayClasses']}',
//                     icon: Icons.today_outlined,
//                     color: const Color(0xFFE65100),
//                     w: w,
//                   ),
//                   _StatsCard(
//                     title: 'Upcoming',
//                     value: '${stats['upcomingCount']}',
//                     icon: Icons.schedule_outlined,
//                     color: const Color(0xFF2E7D32),
//                     w: w,
//                   ),
//                   _StatsCard(
//                     title: 'Completed',
//                     value: '${stats['completedCount']}',
//                     icon: Icons.check_circle_outline,
//                     color: const Color(0xFF6A1B9A),
//                     w: w,
//                   ),
//                 ],
//               ),
//               SizedBox(height: h * 0.028),

//               // ── Upcoming Section ──────────────────────────────────────
//               _SectionHeader(
//                 title: 'Upcoming Classes',
//                 icon: Icons.schedule,
//                 w: w,
//               ),
//               SizedBox(height: h * 0.012),
//               if (upcoming.isEmpty)
//                 _EmptyState(message: 'No upcoming classes', w: w)
//               else
//                 ...upcoming.whereType<TeacherClassModel>().map(
//                   (cls) => _UpcomingCard(
//                     cls: cls,
//                     w: w,
//                     h: h,
//                     onJoin: () => context.go(
//                       AppRoutes.classroom,
//                       extra: {
//                         'studentName': cls.studentName,
//                         'subject': cls.subject,
//                         'time': DateFormat('hh:mm a').format(cls.scheduledAt),
//                       },
//                     ),
//                   ),
//                 ),

//               SizedBox(height: h * 0.028),

//               // ── Completed Section ─────────────────────────────────────
//               _SectionHeader(
//                 title: 'Completed Classes',
//                 icon: Icons.check_circle_outline,
//                 w: w,
//               ),
//               SizedBox(height: h * 0.012),
//               if (completed.isEmpty)
//                 _EmptyState(message: 'No completed classes yet', w: w)
//               else
//                 ...completed.map((cls) => _CompletedCard(cls: cls, w: w, h: h)),

//               SizedBox(height: h * 0.02),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════════
// // SEARCH BAR
// // ═══════════════════════════════════════════════════════════════════════════════
// class _SearchBar extends ConsumerWidget {
//   final double w, h;
//   const _SearchBar({required this.w, required this.h});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final query = ref.watch(searchQueryProvider);
//     return TextField(
//       onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
//       decoration: InputDecoration(
//         hintText: 'Search upcoming classes...',
//         hintStyle: TextStyle(color: Colors.grey[400], fontSize: w * 0.035),
//         prefixIcon: Icon(
//           Icons.search,
//           color: AppColors.primaryGreen,
//           size: w * 0.055,
//         ),
//         suffixIcon: query.isNotEmpty
//             ? IconButton(
//                 icon: Icon(Icons.close, size: w * 0.045, color: Colors.grey),
//                 onPressed: () =>
//                     ref.read(searchQueryProvider.notifier).state = '',
//               )
//             : null,
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: EdgeInsets.symmetric(vertical: h * 0.015),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: Colors.grey.shade200),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
//         ),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════════
// // WELCOME CARD
// // ═══════════════════════════════════════════════════════════════════════════════
// class _WelcomeCard extends StatelessWidget {
//   final String name;
//   final double w, h;
//   const _WelcomeCard({required this.name, required this.w, required this.h});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [AppColors.primaryGreen, AppColors.lightGreen],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryGreen.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Welcome Back!',
//                   style: TextStyle(color: Colors.white70, fontSize: w * 0.032),
//                 ),
//                 SizedBox(height: h * 0.004),
//                 Text(
//                   name,
//                   style: TextStyle(
//                     color: AppColors.white,
//                     fontSize: w * 0.05,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//                 SizedBox(height: h * 0.004),
//                 Text(
//                   DateFormat('EEEE, d MMMM').format(DateTime.now()),
//                   style: TextStyle(color: Colors.white60, fontSize: w * 0.028),
//                 ),
//               ],
//             ),
//           ),
//           CircleAvatar(
//             radius: w * 0.075,
//             backgroundColor: Colors.white24,
//             child: Icon(Icons.person, color: AppColors.white, size: w * 0.08),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════════
// // STATS CARD
// // ═══════════════════════════════════════════════════════════════════════════════
// class _StatsCard extends StatelessWidget {
//   final String title, value;
//   final IconData icon;
//   final Color color;
//   final double w;

//   const _StatsCard({
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//     required this.w,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(w * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             padding: EdgeInsets.all(w * 0.02),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: w * 0.055),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: w * 0.06,
//                   fontWeight: FontWeight.w800,
//                   color: AppColors.textDark,
//                 ),
//               ),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: w * 0.028,
//                   color: Colors.grey[500],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════════
// // SECTION HEADER
// // ═══════════════════════════════════════════════════════════════════════════════
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final double w;
//   const _SectionHeader({
//     required this.title,
//     required this.icon,
//     required this.w,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: AppColors.primaryGreen, size: w * 0.05),
//         SizedBox(width: w * 0.02),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: w * 0.042,
//             fontWeight: FontWeight.w700,
//             color: AppColors.textDark,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════════
// // UPCOMING CARD — live countdown timer
// // ═══════════════════════════════════════════════════════════════════════════════
// class _UpcomingCard extends StatefulWidget {
//   final TeacherClassModel cls;
//   final double w, h;
//   final VoidCallback onJoin;

//   const _UpcomingCard({
//     required this.cls,
//     required this.w,
//     required this.h,
//     required this.onJoin,
//   });

//   @override
//   State<_UpcomingCard> createState() => _UpcomingCardState();
// }

// class _UpcomingCardState extends State<_UpcomingCard> {
//   late Timer _timer;
//   late Duration _remaining;

//   @override
//   void initState() {
//     super.initState();
//     _calc();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (mounted) setState(_calc);
//     });
//   }

//   void _calc() {
//     final diff = widget.cls.scheduledAt.difference(DateTime.now());
//     _remaining = diff.isNegative ? Duration.zero : diff;
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   String get _countdownText {
//     if (_remaining == Duration.zero) return 'Starting now';
//     final h = _remaining.inHours;
//     final m = _remaining.inMinutes.remainder(60);
//     final s = _remaining.inSeconds.remainder(60);
//     if (h > 0) return '${h}h ${m}m ${s}s';
//     if (m > 0) return '${m}m ${s}s';
//     return '${s}s';
//   }

//   Color get _timerColor {
//     if (_remaining.inMinutes < 5) return Colors.red;
//     if (_remaining.inMinutes < 30) return Colors.orange;
//     return AppColors.primaryGreen;
//   }

//   bool get _isLive =>
//       widget.cls.status == 'live' || _remaining == Duration.zero;

//   @override
//   Widget build(BuildContext context) {
//     final w = widget.w;
//     final h = widget.h;
//     final cls = widget.cls;

//     return Container(
//       margin: EdgeInsets.only(bottom: h * 0.015),
//       padding: EdgeInsets.all(w * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: _isLive
//             ? Border.all(color: AppColors.primaryGreen, width: 1.5)
//             : null,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.07),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Student row
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: w * 0.055,
//                 backgroundColor: AppColors.primaryGreen.withOpacity(0.12),
//                 backgroundImage: cls.studentAvatarUrl != null
//                     ? NetworkImage(cls.studentAvatarUrl!)
//                     : null,
//                 child: cls.studentAvatarUrl == null
//                     ? Text(
//                         cls.studentName.isNotEmpty
//                             ? cls.studentName[0].toUpperCase()
//                             : '?',
//                         style: TextStyle(
//                           color: AppColors.primaryGreen,
//                           fontWeight: FontWeight.bold,
//                           fontSize: w * 0.04,
//                         ),
//                       )
//                     : null,
//               ),
//               SizedBox(width: w * 0.03),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       cls.studentName,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: w * 0.038,
//                         color: AppColors.textDark,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.menu_book_outlined,
//                           size: w * 0.032,
//                           color: Colors.grey[400],
//                         ),
//                         SizedBox(width: 3),
//                         Text(
//                           cls.subject,
//                           style: TextStyle(
//                             fontSize: w * 0.032,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               if (_isLive)
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 6,
//                         height: 6,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'LIVE',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: w * 0.026,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),

//           SizedBox(height: h * 0.01),

//           // Time info
//           Row(
//             children: [
//               Icon(Icons.access_time, size: w * 0.035, color: Colors.grey[400]),
//               SizedBox(width: 4),
//               Text(
//                 DateFormat('EEE, d MMM • hh:mm a').format(cls.scheduledAt),
//                 style: TextStyle(fontSize: w * 0.031, color: Colors.grey[500]),
//               ),
//               if (cls.durationMinutes != null) ...[
//                 Text('  •  ', style: TextStyle(color: Colors.grey[300])),
//                 Text(
//                   '${cls.durationMinutes} min',
//                   style: TextStyle(
//                     fontSize: w * 0.031,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ],
//           ),

//           SizedBox(height: h * 0.012),

//           // Countdown + Join
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: w * 0.03,
//                   vertical: h * 0.007,
//                 ),
//                 decoration: BoxDecoration(
//                   color: _timerColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.timer_outlined,
//                       size: w * 0.034,
//                       color: _timerColor,
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       _isLive ? 'Class is live!' : 'Starts in $_countdownText',
//                       style: TextStyle(
//                         color: _timerColor,
//                         fontSize: w * 0.029,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               ElevatedButton(
//                 onPressed: widget.onJoin,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryGreen,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: w * 0.04,
//                     vertical: h * 0.009,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   _isLive ? 'Join Now' : 'Join',
//                   style: TextStyle(
//                     fontSize: w * 0.033,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════════
// // COMPLETED CARD — rating & review
// // ═══════════════════════════════════════════════════════════════════════════════
// class _CompletedCard extends StatelessWidget {
//   final TeacherClassModel cls;
//   final double w, h;
//   const _CompletedCard({required this.cls, required this.w, required this.h});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: h * 0.015),
//       padding: EdgeInsets.all(w * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: w * 0.05,
//                 backgroundColor: Colors.grey[100],
//                 backgroundImage: cls.studentAvatarUrl != null
//                     ? NetworkImage(cls.studentAvatarUrl!)
//                     : null,
//                 child: cls.studentAvatarUrl == null
//                     ? Text(
//                         cls.studentName.isNotEmpty
//                             ? cls.studentName[0].toUpperCase()
//                             : '?',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.bold,
//                           fontSize: w * 0.035,
//                         ),
//                       )
//                     : null,
//               ),
//               SizedBox(width: w * 0.03),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       cls.studentName,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: w * 0.037,
//                         color: AppColors.textDark,
//                       ),
//                     ),
//                     Text(
//                       cls.subject,
//                       style: TextStyle(
//                         fontSize: w * 0.03,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   'Done',
//                   style: TextStyle(
//                     color: Colors.green.shade700,
//                     fontSize: w * 0.028,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: h * 0.008),

//           // Date
//           Row(
//             children: [
//               Icon(
//                 Icons.calendar_today_outlined,
//                 size: w * 0.03,
//                 color: Colors.grey[400],
//               ),
//               SizedBox(width: 4),
//               Text(
//                 DateFormat('EEE, d MMM yyyy • hh:mm a').format(cls.scheduledAt),
//                 style: TextStyle(fontSize: w * 0.029, color: Colors.grey[500]),
//               ),
//             ],
//           ),

//           // Rating
//           if (cls.studentRating != null) ...[
//             SizedBox(height: h * 0.008),
//             Row(
//               children: [
//                 ...List.generate(5, (i) {
//                   final filled = i < cls.studentRating!.floor();
//                   final half = !filled && i < cls.studentRating!;
//                   return Icon(
//                     half
//                         ? Icons.star_half
//                         : filled
//                         ? Icons.star
//                         : Icons.star_border,
//                     color: Colors.amber,
//                     size: w * 0.04,
//                   );
//                 }),
//                 SizedBox(width: w * 0.015),
//                 Text(
//                   cls.studentRating!.toStringAsFixed(1),
//                   style: TextStyle(
//                     fontSize: w * 0.032,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.amber.shade700,
//                   ),
//                 ),
//               ],
//             ),
//           ],

//           // Review
//           if (cls.studentReview != null && cls.studentReview!.isNotEmpty) ...[
//             SizedBox(height: h * 0.008),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(w * 0.03),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(
//                     Icons.format_quote,
//                     size: w * 0.038,
//                     color: Colors.grey[300],
//                   ),
//                   SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       cls.studentReview!,
//                       style: TextStyle(
//                         fontSize: w * 0.031,
//                         color: Colors.grey[600],
//                         fontStyle: FontStyle.italic,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],

//           if (cls.studentRating == null) ...[
//             SizedBox(height: h * 0.006),
//             Text(
//               'No review yet',
//               style: TextStyle(
//                 fontSize: w * 0.029,
//                 color: Colors.grey[400],
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════════
// // EMPTY STATE
// // ═══════════════════════════════════════════════════════════════════════════════
// class _EmptyState extends StatelessWidget {
//   final String message;
//   final double w;
//   const _EmptyState({required this.message, required this.w});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(vertical: w * 0.1),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.inbox_outlined, size: w * 0.12, color: Colors.grey[300]),
//           SizedBox(height: w * 0.02),
//           Text(
//             message,
//             style: TextStyle(color: Colors.grey[400], fontSize: w * 0.034),
//           ),
//         ],
//       ),
//     );
//   }
// }
// lib/features/teacher/screens/dashboard_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/core/widgets/app_drawer.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';
import 'package:quran_learning_app/models/teacher_class_model.dart';
import 'package:quran_learning_app/provider/teacher_dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(teacherNotificationScheduler); // Activate scheduler
    final teacherAsync = ref.watch(teacherProfileProvider);
    final stats = ref.watch(dashboardStatsProvider);
    final upcoming = ref.watch(filteredUpcomingProvider);
    final completed = ref.watch(completedClassesProvider);

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.045,
          ),
        ),
      ),
      body: teacherAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (teacher) => SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeCard(name: teacher?.name ?? '', w: w, h: h),
              SizedBox(height: h * 0.02),
              _SearchBar(w: w, h: h),
              SizedBox(height: h * 0.02),

              // ── 4 Stats Cards ─────────────────────────────────────────
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: w * 0.03,
                mainAxisSpacing: w * 0.03,
                childAspectRatio: 1.25,
                children: [
                  _StatsCard(
                    title: 'Overall Classes',
                    // FIX: overallCount = confirmed + completed
                    value: '${stats['overallCount'] ?? 0}',
                    icon: Icons.menu_book_outlined,
                    color: const Color(0xFF1565C0),
                    w: w,
                  ),
                  _StatsCard(
                    title: "Today's Classes",
                    value: '${stats['todayClasses'] ?? 0}',
                    icon: Icons.today_outlined,
                    color: const Color(0xFFE65100),
                    w: w,
                  ),
                  _StatsCard(
                    title: 'Upcoming',
                    value: '${stats['upcomingCount'] ?? 0}',
                    icon: Icons.schedule_outlined,
                    color: const Color(0xFF2E7D32),
                    w: w,
                  ),
                  _StatsCard(
                    title: 'Completed',
                    value: '${stats['completedCount'] ?? 0}',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF6A1B9A),
                    w: w,
                  ),
                ],
              ),
              SizedBox(height: h * 0.028),

              // ── Upcoming Section ──────────────────────────────────────
              _SectionHeader(
                title: 'Upcoming Classes',
                icon: Icons.schedule,
                w: w,
              ),
              SizedBox(height: h * 0.012),
              if (upcoming.isEmpty)
                _EmptyState(message: 'No upcoming classes', w: w)
              else
                ...upcoming.map(
                  (cls) => _UpcomingCard(
                    cls: cls,
                    w: w,
                    h: h,
                    onJoin: () => context.push(
                      AppRoutes.classroom,
                      extra: {
                        'channelName': cls.id,
                        'otherPersonName': cls.studentName,
                        'time': DateFormat('hh:mm a').format(cls.scheduledAt),
                        'scheduledAt': cls.scheduledAt,
                        'date':
                            '${cls.scheduledAt.year}-${cls.scheduledAt.month.toString().padLeft(2, '0')}-${cls.scheduledAt.day.toString().padLeft(2, '0')}',
                        'slotTime': DateFormat(
                          'h:mm a',
                        ).format(cls.scheduledAt),
                        'durationMinutes': cls.durationMinutes ?? 30,
                        'studentId': cls.studentId ?? '',
                        'teacherId': cls.teacherId ?? '',
                        'studentName': cls.studentName,
                        'isTeacher': true,
                      },
                    ),
                  ),
                ),

              SizedBox(height: h * 0.028),

              // ── Completed Section ─────────────────────────────────────
              _SectionHeader(
                title: 'Completed Classes',
                icon: Icons.check_circle_outline,
                w: w,
              ),
              SizedBox(height: h * 0.012),
              if (completed.isEmpty)
                _EmptyState(message: 'No completed classes yet', w: w)
              else
                ...completed.map((cls) => _CompletedCard(cls: cls, w: w, h: h)),

              SizedBox(height: h * 0.02),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SEARCH BAR
// ═══════════════════════════════════════════════════════════════════════════════
class _SearchBar extends ConsumerWidget {
  final double w, h;
  const _SearchBar({required this.w, required this.h});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    return TextField(
      onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
      decoration: InputDecoration(
        hintText: 'Search upcoming classes...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: w * 0.035),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.primaryGreen,
          size: w * 0.055,
        ),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, size: w * 0.045, color: Colors.grey),
                onPressed: () =>
                    ref.read(searchQueryProvider.notifier).state = '',
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: h * 0.015),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WELCOME CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _WelcomeCard extends StatelessWidget {
  final String name;
  final double w, h;
  const _WelcomeCard({required this.name, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(color: Colors.white70, fontSize: w * 0.032),
                ),
                SizedBox(height: h * 0.004),
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: h * 0.004),
                Text(
                  DateFormat('EEEE, d MMMM').format(DateTime.now()),
                  style: TextStyle(color: Colors.white60, fontSize: w * 0.028),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: w * 0.075,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: AppColors.white, size: w * 0.08),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATS CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _StatsCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  final double w;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.02),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: w * 0.055),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: w * 0.06,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: w * 0.028,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final double w;
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: w * 0.05),
        SizedBox(width: w * 0.02),
        Text(
          title,
          style: TextStyle(
            fontSize: w * 0.042,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// UPCOMING CARD — live countdown timer
// ═══════════════════════════════════════════════════════════════════════════════
class _UpcomingCard extends StatefulWidget {
  final TeacherClassModel cls;
  final double w, h;
  final VoidCallback onJoin;

  const _UpcomingCard({
    required this.cls,
    required this.w,
    required this.h,
    required this.onJoin,
  });

  @override
  State<_UpcomingCard> createState() => _UpcomingCardState();
}

class _UpcomingCardState extends State<_UpcomingCard> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _calc();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(_calc);
    });
  }

  void _calc() {
    final diff = widget.cls.scheduledAt.difference(DateTime.now());
    _remaining = diff.isNegative ? Duration.zero : diff;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _countdownText {
    if (_remaining == Duration.zero) return 'Starting now';
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  Color get _timerColor {
    if (_remaining.inMinutes < 5) return Colors.red;
    if (_remaining.inMinutes < 30) return Colors.orange;
    return AppColors.primaryGreen;
  }

  bool get _isLive => _remaining == Duration.zero;

  @override
  Widget build(BuildContext context) {
    final w = widget.w;
    final h = widget.h;
    final cls = widget.cls;

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: _isLive
            ? Border.all(color: AppColors.primaryGreen, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: w * 0.055,
                backgroundColor: AppColors.primaryGreen.withOpacity(0.12),
                backgroundImage:
                    (cls.studentAvatarUrl != null &&
                        cls.studentAvatarUrl!.isNotEmpty)
                    ? NetworkImage(cls.studentAvatarUrl!)
                    : null,
                child:
                    (cls.studentAvatarUrl == null ||
                        cls.studentAvatarUrl!.isEmpty)
                    ? Text(
                        cls.studentName.isNotEmpty
                            ? cls.studentName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.04,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cls.studentName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: w * 0.038,
                        color: AppColors.textDark,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: w * 0.032,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 3),
                        Text(
                          cls.subject,
                          style: TextStyle(
                            fontSize: w * 0.032,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isLive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.026,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: h * 0.01),
          Row(
            children: [
              Icon(Icons.access_time, size: w * 0.035, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(
                DateFormat('EEE, d MMM • hh:mm a').format(cls.scheduledAt),
                style: TextStyle(fontSize: w * 0.031, color: Colors.grey[500]),
              ),
              if (cls.durationMinutes != null) ...[
                Text('  •  ', style: TextStyle(color: Colors.grey[300])),
                Text(
                  '${cls.durationMinutes} min',
                  style: TextStyle(
                    fontSize: w * 0.031,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: h * 0.012),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: h * 0.007,
                ),
                decoration: BoxDecoration(
                  color: _timerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: w * 0.034,
                      color: _timerColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isLive ? 'Class is live!' : 'Starts in $_countdownText',
                      style: TextStyle(
                        color: _timerColor,
                        fontSize: w * 0.029,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: widget.onJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.009,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isLive ? 'Join Now' : 'Join',
                  style: TextStyle(
                    fontSize: w * 0.033,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPLETED CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _CompletedCard extends StatelessWidget {
  final TeacherClassModel cls;
  final double w, h;
  const _CompletedCard({required this.cls, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: w * 0.05,
                backgroundColor: Colors.grey[100],
                backgroundImage:
                    (cls.studentAvatarUrl != null &&
                        cls.studentAvatarUrl!.isNotEmpty)
                    ? NetworkImage(cls.studentAvatarUrl!)
                    : null,
                child:
                    (cls.studentAvatarUrl == null ||
                        cls.studentAvatarUrl!.isEmpty)
                    ? Text(
                        cls.studentName.isNotEmpty
                            ? cls.studentName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.035,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cls.studentName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: w * 0.037,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      cls.subject,
                      style: TextStyle(
                        fontSize: w * 0.03,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.008),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: w * 0.03,
                color: Colors.grey[400],
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('EEE, d MMM yyyy • hh:mm a').format(cls.scheduledAt),
                style: TextStyle(fontSize: w * 0.029, color: Colors.grey[500]),
              ),
            ],
          ),
          if (cls.studentRating != null) ...[
            SizedBox(height: h * 0.008),
            Row(
              children: [
                ...List.generate(5, (i) {
                  final filled = i < cls.studentRating!.floor();
                  final half = !filled && i < cls.studentRating!;
                  return Icon(
                    half
                        ? Icons.star_half
                        : filled
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: w * 0.04,
                  );
                }),
                SizedBox(width: w * 0.015),
                Text(
                  cls.studentRating!.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: w * 0.032,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
          ],
          if (cls.studentReview != null && cls.studentReview!.isNotEmpty) ...[
            SizedBox(height: h * 0.008),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote,
                    size: w * 0.038,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      cls.studentReview!,
                      style: TextStyle(
                        fontSize: w * 0.031,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (cls.studentRating == null) ...[
            SizedBox(height: h * 0.006),
            Text(
              'No review yet',
              style: TextStyle(
                fontSize: w * 0.029,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final String message;
  final double w;
  const _EmptyState({required this.message, required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: w * 0.1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: w * 0.12, color: Colors.grey[300]),
          SizedBox(height: w * 0.02),
          Text(
            message,
            style: TextStyle(color: Colors.grey[400], fontSize: w * 0.034),
          ),
        ],
      ),
    );
  }
}
