import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/service/class_timer_provider.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class ClassScreen extends ConsumerStatefulWidget {
  final String studentName;
  final String subject;
  final String time;

  const ClassScreen({
    super.key,
    required this.studentName,
    required this.subject,
    required this.time,
  });

  @override
  ConsumerState<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends ConsumerState<ClassScreen> {
  bool _navigatedToEnd = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Parse the time and schedule
      final now = DateTime.now();
      final scheduledAt = _parseTime(widget.time, now);

      ref
          .read(classTimerProvider.notifier)
          .start(scheduledAt: scheduledAt, durationMinutes: 30);
    });
  }

  DateTime _parseTime(String timeStr, DateTime now) {
    try {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1].split(' ')[0]);

      var scheduled = DateTime(now.year, now.month, now.day, hour, minute);

      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      return scheduled;
    } catch (e) {
      return now.add(const Duration(minutes: 30));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(classTimerProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Class ختم ہو گیا → progress screen
    if (timerState.status == ClassStatus.ended && !_navigatedToEnd) {
      _navigatedToEnd = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.pushReplacement(
            AppRoutes.progressNotes,
            extra: {
              'studentName': widget.studentName,
              'studentId': 'student_123',
              'teacherId': 'teacher_456',
            },
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: timerState.status == ClassStatus.waiting
            ? _WaitingScreen(
                studentName: widget.studentName,
                remaining: timerState.remaining,
                time: widget.time,
                w: w,
                h: h,
              )
            : _LiveScreen(
                studentName: widget.studentName,
                subject: widget.subject,
                timerState: timerState,
                w: w,
                h: h,
                onEnd: () {
                  ref.read(classTimerProvider.notifier).endClass();
                },
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WAITING SCREEN - 30 منٹ پہلے سے دیکھیں
// ═══════════════════════════════════════════════════════════════════════════════
class _WaitingScreen extends StatelessWidget {
  final String studentName;
  final Duration remaining;
  final String time;
  final double w, h;

  const _WaitingScreen({
    required this.studentName,
    required this.remaining,
    required this.time,
    required this.w,
    required this.h,
  });

  String _formatTime(Duration d) {
    final hrs = d.inHours;
    final mins = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hrs > 0) return '$hrs:$mins:$secs';
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final isEarly = remaining.inMinutes > 25;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Timer Icon
          Container(
            width: w * 0.35,
            height: w * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withOpacity(0.15),
              border: Border.all(color: AppColors.primaryGreen, width: 3),
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: AppColors.primaryGreen,
              size: w * 0.16,
            ),
          ),
          SizedBox(height: h * 0.06),

          // Class Info
          Text(
            'Class with $studentName',
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.055,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: h * 0.02),
          Text(
            'Scheduled at $time',
            style: TextStyle(color: Colors.white70, fontSize: w * 0.04),
          ),
          SizedBox(height: h * 0.06),

          // Timer Box
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.1,
              vertical: h * 0.03,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Class starts in',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: w * 0.038,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: h * 0.01),
                Text(
                  _formatTime(remaining),
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: w * 0.12,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Courier',
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.05),

          // Early Join Warning
          if (isEarly)
            Container(
              margin: EdgeInsets.symmetric(horizontal: w * 0.06),
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: w * 0.05,
                  ),
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Text(
                      'You joined early. Class will start at the scheduled time.',
                      style: TextStyle(
                        color: Colors.orange.shade200,
                        fontSize: w * 0.032,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              margin: EdgeInsets.symmetric(horizontal: w * 0.06),
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: w * 0.05,
                  ),
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Text(
                      'Ready! Class will start automatically when the time comes.',
                      style: TextStyle(
                        color: Colors.green.shade200,
                        fontSize: w * 0.032,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: h * 0.06),

          // Back Button
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white54),
            label: Text(
              'Go Back',
              style: TextStyle(color: Colors.white54, fontSize: w * 0.04),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIVE SCREEN - جب class شروع ہو گئی
// ═══════════════════════════════════════════════════════════════════════════════
class _LiveScreen extends StatelessWidget {
  final String studentName;
  final String subject;
  final ClassTimerState timerState;
  final double w, h;
  final VoidCallback onEnd;

  const _LiveScreen({
    required this.studentName,
    required this.subject,
    required this.timerState,
    required this.w,
    required this.h,
    required this.onEnd,
  });

  String _formatTimer(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Top Bar - Timer & Info
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.015,
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Student Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subject,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: w * 0.032,
                      ),
                    ),
                  ],
                ),

                // Timer
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    _formatTimer(timerState.classTimeLeft),
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Video/Content Area
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: w * 0.4,
                      height: w * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white10,
                      ),
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white30,
                        size: w * 0.2,
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                    Text(
                      'Agora Video Feed\nWill appear here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white30,
                        fontSize: w * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Controls
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
              border: Border(
                top: BorderSide(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mic
                _ControlButton(
                  icon: Icons.mic,
                  label: 'Mic',
                  onPress: () {},
                  w: w,
                ),
                // Camera
                _ControlButton(
                  icon: Icons.videocam,
                  label: 'Camera',
                  onPress: () {},
                  w: w,
                ),
                // Chat
                _ControlButton(
                  icon: Icons.chat,
                  label: 'Chat',
                  onPress: () {},
                  w: w,
                ),
                // End Call
                _ControlButton(
                  icon: Icons.call_end,
                  label: 'End',
                  onPress: onEnd,
                  isEnd: true,
                  w: w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPress;
  final bool isEnd;
  final double w;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPress,
    this.isEnd = false,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPress,
          child: Container(
            width: w * 0.12,
            height: w * 0.12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEnd ? Colors.red.withOpacity(0.8) : Colors.white10,
              border: Border.all(
                color: isEnd ? Colors.red : Colors.white.withOpacity(0.3),
              ),
            ),
            child: Icon(
              icon,
              color: isEnd ? Colors.white : Colors.white70,
              size: w * 0.06,
            ),
          ),
        ),
        SizedBox(height: w * 0.01),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: w * 0.03),
        ),
      ],
    );
  }
}
