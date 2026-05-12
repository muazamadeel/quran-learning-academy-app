// lib/features/classroom/classroom_screen.dart

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/service/agora_service.dart';
import 'package:quran_learning_app/core/service/class_timer_provider.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/core/utils/booking_schedule_utils.dart';
import 'package:quran_learning_app/provider/agora_riverpod_provider.dart';
import 'package:intl/intl.dart';

class ClassroomScreen extends ConsumerStatefulWidget {
  final String channelName;
  final String otherPersonName;
  final String time;
  final int localUid;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String studentId;
  final String teacherId;
  final String studentName;
  final bool isTeacher;

  const ClassroomScreen({
    super.key,
    required this.channelName,
    required this.otherPersonName,
    required this.time,
    required this.localUid,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.studentId,
    required this.teacherId,
    required this.studentName,
    required this.isTeacher,
  });

  @override
  ConsumerState<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends ConsumerState<ClassroomScreen> {
  bool _agoraJoined = false;
  bool _navigatedToEnd = false;
  bool _markedCompleted = false;
  bool _sessionReady = false;
  String _scheduledDisplay = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrapSession());
  }

  Future<void> _bootstrapSession() async {
    ref.read(classTimerProvider.notifier).reset();
    var start = widget.scheduledAt;
    var duration = widget.durationMinutes;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.channelName)
          .get();
      if (doc.exists) {
        final d = doc.data()!;
        final parsed = parseBookingScheduledAt(d);
        if (parsed != null) start = parsed;
        final dm = (d['durationMinutes'] as num?)?.toInt();
        if (dm != null && dm > 0) duration = dm;
      }
    } catch (_) {}
    if (!mounted) return;
    _scheduledDisplay = DateFormat('EEE, MMM d • hh:mm a').format(start);
    ref
        .read(classTimerProvider.notifier)
        .start(scheduledAt: start, durationMinutes: duration);
    setState(() => _sessionReady = true);
  }

  Future<void> _joinAgora() async {
    if (_agoraJoined) return;
    _agoraJoined = true;
    await ref
        .read(agoraProvider.notifier)
        .joinCall(channelName: widget.channelName, uid: widget.localUid);
  }

  Future<void> _endCall() async {
    await _markBookingCompleted();
    await ref.read(agoraProvider.notifier).leaveCall();
    ref.read(classTimerProvider.notifier).endClass();
  }

  Future<void> _markBookingCompleted() async {
    if (_markedCompleted || widget.channelName.isEmpty) return;
    _markedCompleted = true;
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.channelName)
          .update({
            'status': 'completed',
            'completedAt': FieldValue.serverTimestamp(),
          });
    } catch (_) {
      // Do not block meeting UX for Firestore update failures.
    }
  }

  @override
  void dispose() {
    ref.read(agoraProvider.notifier).leaveCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(classTimerProvider);
    final agoraState = ref.watch(agoraProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Class end → progress screen
    if (timerState.status == ClassStatus.ended && !_navigatedToEnd) {
      _navigatedToEnd = true;
      _markBookingCompleted();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.pushReplacement(
            AppRoutes.classEnd,
            extra: {
              'studentId': widget.studentId,
              'teacherId': widget.teacherId,
              'studentName': widget.studentName,
              'isTeacher': widget.isTeacher,
              'durationMinutes': widget.durationMinutes,
            },
          );
        }
      });
    }

    // Class live → Agora join
    if (timerState.status == ClassStatus.live && !_agoraJoined) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _joinAgora());
    }

    if (!_sessionReady) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: timerState.status == ClassStatus.waiting
            ? _WaitingScreen(
                otherName: widget.otherPersonName,
                remaining: timerState.remaining,
                time: widget.time,
                scheduledLine: _scheduledDisplay,
                w: w,
                h: h,
              )
            : _LiveScreen(
                agoraState: agoraState,
                timerState: timerState,
                otherName: widget.otherPersonName,
                channelName: widget.channelName,
                isTeacher: widget.isTeacher,
                onMic: () => ref.read(agoraProvider.notifier).toggleMic(),
                onCamera: () => ref.read(agoraProvider.notifier).toggleCamera(),
                onSwitch: () => ref.read(agoraProvider.notifier).switchCamera(),
                onScreenShare: () =>
                    ref.read(agoraProvider.notifier).toggleScreenShare(),
                onEnd: _endCall,
                w: w,
                h: h,
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WAITING SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class _WaitingScreen extends StatelessWidget {
  final String otherName;
  final Duration remaining;
  final String time;
  final String scheduledLine;
  final double w, h;

  const _WaitingScreen({
    required this.otherName,
    required this.remaining,
    required this.time,
    required this.scheduledLine,
    required this.w,
    required this.h,
  });

  String _format(Duration d) {
    final hrs = d.inHours;
    final mins = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hrs > 0) return '${hrs}h ${mins}m ${secs}s';
    return '${mins}m ${secs}s';
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: w * 0.3,
            height: w * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withOpacity(0.15),
              border: Border.all(color: AppColors.primaryGreen, width: 2),
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: AppColors.primaryGreen,
              size: w * 0.14,
            ),
          ),
          SizedBox(height: h * 0.04),
          Text(
            'Your class time',
            style: TextStyle(color: Colors.white54, fontSize: w * 0.032),
          ),
          SizedBox(height: h * 0.006),
          Text(
            scheduledLine.isNotEmpty ? scheduledLine : time,
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.042,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          if (time.isNotEmpty && scheduledLine.isNotEmpty) ...[
            SizedBox(height: h * 0.004),
            Text(
              'Slot: $time',
              style: TextStyle(color: Colors.white60, fontSize: w * 0.03),
            ),
          ],
          SizedBox(height: h * 0.01),
          Text(
            'with $otherName',
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.05,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: h * 0.05),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.08,
              vertical: h * 0.025,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.4),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Class starts in',
                  style: TextStyle(color: Colors.white54, fontSize: w * 0.032),
                ),
                SizedBox(height: h * 0.008),
                Text(
                  _format(remaining),
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: w * 0.09,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.04),
          Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.08),
            padding: EdgeInsets.all(w * 0.04),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                SizedBox(width: w * 0.02),
                Expanded(
                  child: Text(
                    'You joined before start time. Wait here — video will connect automatically when the class begins.',
                    style: TextStyle(
                      color: Colors.amber.shade200,
                      fontSize: w * 0.03,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.04),
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white54),
            label: Text(
              'Go Back',
              style: TextStyle(color: Colors.white54, fontSize: w * 0.035),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIVE SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class _LiveScreen extends StatelessWidget {
  final AgoraState agoraState;
  final ClassTimerState timerState;
  final String otherName;
  final String channelName;
  final bool isTeacher;
  final VoidCallback onMic, onCamera, onSwitch, onScreenShare, onEnd;
  final double w, h;

  const _LiveScreen({
    required this.agoraState,
    required this.timerState,
    required this.otherName,
    required this.channelName,
    required this.isTeacher,
    required this.onMic,
    required this.onCamera,
    required this.onSwitch,
    required this.onScreenShare,
    required this.onEnd,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Remote Video
        if (agoraState.isJoined && agoraState.remoteUids.isNotEmpty)
          SizedBox.expand(
            child: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: AgoraService.engine,
                canvas: VideoCanvas(uid: agoraState.remoteUids.first),
                connection: RtcConnection(channelId: channelName),
              ),
            ),
          )
        else if (agoraState.isJoined && agoraState.remoteUids.isEmpty)
          Container(
            color: const Color(0xFF1A1A2E),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: w * 0.12,
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                    child: Text(
                      otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: w * 0.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  Text(
                    'Waiting for $otherName...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: w * 0.035,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            color: const Color(0xFF1A1A2E),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryGreen),
                  SizedBox(height: 16),
                  Text(
                    'Initializing Classroom...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

        // Local PiP
        if (agoraState.isJoined && !agoraState.isCameraOff && !agoraState.isScreenSharing)
          Positioned(
            top: h * 0.02,
            right: w * 0.04,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: w * 0.28,
                height: h * 0.18,
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: AgoraService.engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              ),
            ),
          ),

        // Top bar with timer + progress bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(
            otherName: otherName,
            timerState: timerState,
            isScreenSharing: agoraState.isScreenSharing,
            w: w,
            h: h,
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _ControlBar(
            agoraState: agoraState,
            onMic: onMic,
            onCamera: onCamera,
            onSwitch: onSwitch,
            onScreenShare: onScreenShare,
            onEnd: onEnd,
            w: w,
            h: h,
          ),
        ),

        if (agoraState.error != null)
          Positioned(
            top: h * 0.12,
            left: w * 0.05,
            right: w * 0.05,
            child: Container(
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                agoraState.error!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TOP BAR
// ═══════════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final String otherName;
  final ClassTimerState timerState;
  final bool isScreenSharing;
  final double w, h;

  const _TopBar({
    required this.otherName,
    required this.timerState,
    required this.isScreenSharing,
    required this.w,
    required this.h,
  });

  String _timeLeft() {
    final d = timerState.classTimeLeft;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.75), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // LIVE badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              SizedBox(width: w * 0.02),
              Text(
                otherName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.white70,
                      size: w * 0.035,
                    ),
                    SizedBox(width: w * 0.01),
                    Text(
                      _timeLeft(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.033,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isScreenSharing) ...[
                SizedBox(width: w * 0.02),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.screen_share,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sharing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.026,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: h * 0.008),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: timerState.progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryGreen,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONTROL BAR
// ═══════════════════════════════════════════════════════════════════════════════
class _ControlBar extends StatelessWidget {
  final AgoraState agoraState;
  final VoidCallback onMic, onCamera, onSwitch, onScreenShare, onEnd;
  final double w, h;

  const _ControlBar({
    required this.agoraState,
    required this.onMic,
    required this.onCamera,
    required this.onSwitch,
    required this.onScreenShare,
    required this.onEnd,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.025),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Btn(
            icon: agoraState.isMicMuted ? Icons.mic_off : Icons.mic,
            label: agoraState.isMicMuted ? 'Unmute' : 'Mute',
            active: agoraState.isMicMuted,
            onTap: onMic,
            w: w,
          ),
          _Btn(
            icon: agoraState.isCameraOff ? Icons.videocam_off : Icons.videocam,
            label: agoraState.isCameraOff ? 'Cam On' : 'Cam Off',
            active: agoraState.isCameraOff,
            onTap: onCamera,
            w: w,
          ),
          // End Call
          GestureDetector(
            onTap: onEnd,
            child: Container(
              width: w * 0.16,
              height: w * 0.16,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.call_end, color: Colors.white, size: w * 0.07),
            ),
          ),
          _Btn(
            icon: agoraState.isScreenSharing
                ? Icons.stop_screen_share
                : Icons.screen_share,
            label: agoraState.isScreenSharing ? 'Stop' : 'Share',
            active: agoraState.isScreenSharing,
            activeColor: Colors.blue,
            onTap: onScreenShare,
            w: w,
          ),
          _Btn(
            icon: Icons.flip_camera_ios,
            label: 'Flip',
            active: false,
            onTap: onSwitch,
            w: w,
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;
  final double w;

  const _Btn({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    required this.w,
    this.activeColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w * 0.12,
            height: w * 0.12,
            decoration: BoxDecoration(
              color: active
                  ? activeColor.withOpacity(0.2)
                  : Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: active ? activeColor : Colors.white,
              size: w * 0.055,
            ),
          ),
          SizedBox(height: w * 0.012),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: w * 0.024),
          ),
        ],
      ),
    );
  }
}
