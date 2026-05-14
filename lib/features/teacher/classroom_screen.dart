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

// ─────────────────────────────────────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFF0A0A14);
  static const surface = Color(0xFF111827);
  static const green = Color(0xFF2D9C6A);
  static const greenLight = Color(0xFF5DC994);
  static const redDark = Color(0xFFC62828);
  static const redLight = Color(0xFFEF9A9A);
  static const white = Colors.white;
  static const white85 = Color(0xD9FFFFFF);
  static const white45 = Color(0x73FFFFFF);
  static const white12 = Color(0x1FFFFFFF);
  static const white09 = Color(0x17FFFFFF);
}

// ─────────────────────────────────────────────────────────────────────────────
// ClassroomScreen — unchanged logic, only UI delegates replaced
// ─────────────────────────────────────────────────────────────────────────────
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

  late AgoraNotifier _agoraNotifier;

  @override
  void initState() {
    super.initState();
    _agoraNotifier = ref.read(agoraProvider.notifier);
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
    } catch (_) {}
  }

  @override
  void dispose() {
    _agoraNotifier.leaveCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(classTimerProvider);
    final agoraState = ref.watch(agoraProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Auto-navigate when class ends
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

    // Auto-join Agora when live
    if (timerState.status == ClassStatus.live && !_agoraJoined) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _joinAgora());
    }

    if (!_sessionReady) {
      return const Scaffold(
        backgroundColor: _C.bg,
        body: SafeArea(
          child: Center(child: CircularProgressIndicator(color: _C.green)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _C.bg,
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
  final String otherName, time, scheduledLine;
  final Duration remaining;
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
    return hrs > 0 ? '$hrs:$mins:$secs' : '$mins:$secs';
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : (name.isNotEmpty ? name[0].toUpperCase() : '?');
  }

  @override
  Widget build(BuildContext context) {
    final soon = remaining.inMinutes > 25;

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.055,
          ).copyWith(top: h * 0.04, bottom: h * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Top bar ─────────────────────────────────────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryGreen.withOpacity(0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primaryGreen,
                        size: 15,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.primaryGreen.withOpacity(0.22),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Scheduled',
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.055),

              // ── Avatar ──────────────────────────────────────────────────
              SizedBox(
                width: w * 0.42,
                height: w * 0.42,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: w * 0.42,
                      height: w * 0.42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: w * 0.32,
                      height: w * 0.32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGreen.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: w * 0.23,
                      height: w * 0.23,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.lightGreen, AppColors.darkGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _initials(otherName),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: w * 0.072,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.025),

              Text(
                otherName,
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: w * 0.062,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                scheduledLine.isNotEmpty ? scheduledLine : time,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: w * 0.034,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: h * 0.045),

              // ── Countdown card ───────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: h * 0.032,
                  horizontal: w * 0.06,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.07),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'CLASS STARTS IN',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: w * 0.029,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.6,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Text(
                      _format(remaining),
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: w * 0.145,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Courier',
                        letterSpacing: 3,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.022),

              // ── Status banner ────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(w * 0.038),
                decoration: BoxDecoration(
                  color: soon
                      ? AppColors.pending.withOpacity(0.06)
                      : AppColors.success.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: soon
                        ? AppColors.pending.withOpacity(0.25)
                        : AppColors.success.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: soon
                            ? AppColors.pending.withOpacity(0.12)
                            : AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        soon
                            ? Icons.schedule_rounded
                            : Icons.check_circle_rounded,
                        color: soon ? AppColors.pending : AppColors.success,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: Text(
                        soon
                            ? 'You joined early. Video will connect automatically when the class begins.'
                            : 'All set! Class will begin automatically when the time arrives.',
                        style: TextStyle(
                          color: soon ? AppColors.pending : AppColors.success,
                          fontSize: w * 0.032,
                          height: 1.55,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.028),

              // ── Subject chip ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.primaryGreen,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Quran Learning Session',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: w * 0.032,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIVE SCREEN — Professional redesign
// ═══════════════════════════════════════════════════════════════════════════════
class _LiveScreen extends StatelessWidget {
  final AgoraState agoraState;
  final ClassTimerState timerState;
  final String otherName, channelName;
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

  String _initial(String n) => n.isNotEmpty ? n[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Remote video / placeholder ─────────────────────────────────────
        Positioned.fill(
          child: agoraState.isJoined && agoraState.remoteUids.isNotEmpty
              ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: AgoraService.engine,
                    canvas: VideoCanvas(uid: agoraState.remoteUids.first),
                    connection: RtcConnection(channelId: channelName),
                  ),
                )
              : _RemotePlaceholder(
                  name: otherName,
                  isJoined: agoraState.isJoined,
                  w: w,
                  h: h,
                ),
        ),

        // ── Gradient scrim top ─────────────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: h * 0.28,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.80), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // ── Gradient scrim bottom ──────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: h * 0.32,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.92)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // ── Top bar ────────────────────────────────────────────────────────
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

        // ── Local PiP ──────────────────────────────────────────────────────
        if (agoraState.isJoined &&
            !agoraState.isCameraOff &&
            !agoraState.isScreenSharing)
          Positioned(
            top: h * 0.105,
            right: w * 0.04,
            child: _LocalPip(
              initial: _initial(isTeacher ? 'You' : otherName),
              w: w,
              h: h,
            ),
          ),

        // ── Session info pill ───────────────────────────────────────────────
        Positioned(
          bottom: h * 0.175,
          left: w * 0.04,
          right: w * 0.04,
          child: _SessionInfoPill(
            durationMinutes: timerState.classTimeLeft.inMinutes,
            w: w,
          ),
        ),

        // ── Participant strip ───────────────────────────────────────────────
        if (agoraState.remoteUids.isNotEmpty)
          Positioned(
            bottom: h * 0.135,
            left: 0,
            right: 0,
            child: _ParticipantStrip(
              localInitial: isTeacher ? 'T' : 'S',
              remoteInitial: _initial(otherName),
              remoteMicMuted: false,
              w: w,
            ),
          ),

        // ── Control bar ────────────────────────────────────────────────────
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

        // ── Error toast ─────────────────────────────────────────────────────
        if (agoraState.error != null)
          Positioned(
            top: h * 0.13,
            left: w * 0.05,
            right: w * 0.05,
            child: _ErrorToast(message: agoraState.error!, w: w),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Remote placeholder
// ─────────────────────────────────────────────────────────────────────────────
class _RemotePlaceholder extends StatelessWidget {
  final String name;
  final bool isJoined;
  final double w, h;

  const _RemotePlaceholder({
    required this.name,
    required this.isJoined,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.bg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pulsing avatar rings
            SizedBox(
              width: w * 0.32,
              height: w * 0.32,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: w * 0.32,
                    height: w * 0.32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _C.green.withOpacity(0.12),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(
                    width: w * 0.26,
                    height: w * 0.26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _C.green.withOpacity(0.22),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(
                    width: w * 0.2,
                    height: w * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _C.green.withOpacity(0.15),
                      border: Border.all(
                        color: _C.green.withOpacity(0.35),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: _C.greenLight,
                          fontSize: w * 0.09,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.022),
            Text(
              isJoined ? 'Waiting for $name…' : 'Initialising Classroom…',
              style: TextStyle(
                color: _C.white45,
                fontSize: w * 0.034,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (!isJoined) ...[
              SizedBox(height: h * 0.025),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: _C.green,
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Local PiP
// ─────────────────────────────────────────────────────────────────────────────
class _LocalPip extends StatelessWidget {
  final String initial;
  final double w, h;

  const _LocalPip({required this.initial, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w * 0.27,
      height: h * 0.17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
        color: const Color(0xFF1B3A5C),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            SizedBox.expand(
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: AgoraService.engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            ),
            // "You" label bottom
            Positioned(
              bottom: 6,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'You',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Session info pill
// ─────────────────────────────────────────────────────────────────────────────
class _SessionInfoPill extends StatelessWidget {
  final int durationMinutes;
  final double w;

  const _SessionInfoPill({required this.durationMinutes, required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.09)),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_book_rounded, color: _C.green, size: 14),
          const SizedBox(width: 7),
          Text(
            'Quran Learning',
            style: TextStyle(
              color: _C.white45,
              fontSize: w * 0.03,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            '${durationMinutes}m remaining',
            style: TextStyle(
              color: _C.white85,
              fontSize: w * 0.03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Participant thumbnail strip
// ─────────────────────────────────────────────────────────────────────────────
class _ParticipantStrip extends StatelessWidget {
  final String localInitial, remoteInitial;
  final bool remoteMicMuted;
  final double w;

  const _ParticipantStrip({
    required this.localInitial,
    required this.remoteInitial,
    required this.remoteMicMuted,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Thumb(
          initial: remoteInitial,
          color: _C.greenLight,
          micMuted: remoteMicMuted,
          w: w,
        ),
        const SizedBox(width: 8),
        _Thumb(
          initial: localInitial,
          color: const Color(0xFF60A5FA),
          micMuted: false,
          w: w,
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  final String initial;
  final Color color;
  final bool micMuted;
  final double w;

  const _Thumb({
    required this.initial,
    required this.color,
    required this.micMuted,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: w * 0.12,
          height: w * 0.12,
          decoration: BoxDecoration(
            color: _C.white12,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _C.white09),
          ),
          child: Center(
            child: Text(
              initial,
              style: TextStyle(
                color: color,
                fontSize: w * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (micMuted)
          Positioned(
            bottom: 3,
            right: 3,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: _C.redDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic_off_rounded,
                color: Colors.white,
                size: 9,
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
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.035, w * 0.04, w * 0.045),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // LIVE badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _C.redDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: _C.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: _C.white,
                        fontSize: w * 0.025,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: w * 0.025),

              // Name
              Expanded(
                child: Text(
                  otherName,
                  style: TextStyle(
                    color: _C.white,
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Timer pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _C.white12,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: _C.white45,
                      size: w * 0.033,
                    ),
                    SizedBox(width: w * 0.01),
                    Text(
                      _timeLeft(),
                      style: TextStyle(
                        color: _C.white,
                        fontSize: w * 0.032,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ),

              // Screen share badge
              if (isScreenSharing) ...[
                SizedBox(width: w * 0.02),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.screen_share_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sharing',
                        style: TextStyle(
                          color: _C.white,
                          fontSize: w * 0.025,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: h * 0.012),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: timerState.progress,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(_C.green),
              minHeight: 3,
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.04,
      ).copyWith(top: h * 0.016, bottom: h * 0.034),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _CtrlBtn(
            icon: agoraState.isMicMuted
                ? Icons.mic_off_rounded
                : Icons.mic_rounded,
            label: agoraState.isMicMuted ? 'Unmute' : 'Mute',
            isActive: agoraState.isMicMuted,
            onTap: onMic,
            w: w,
          ),
          _CtrlBtn(
            icon: agoraState.isCameraOff
                ? Icons.videocam_off_rounded
                : Icons.videocam_rounded,
            label: agoraState.isCameraOff ? 'Cam On' : 'Cam Off',
            isActive: agoraState.isCameraOff,
            onTap: onCamera,
            w: w,
          ),

          // End call — prominent centre button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onEnd,
                child: Container(
                  width: w * 0.165,
                  height: w * 0.165,
                  decoration: const BoxDecoration(
                    color: _C.redDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.call_end_rounded,
                    color: _C.white,
                    size: w * 0.075,
                  ),
                ),
              ),
              SizedBox(height: w * 0.012),
              Text(
                'End',
                style: TextStyle(
                  color: _C.redLight,
                  fontSize: w * 0.025,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          _CtrlBtn(
            icon: agoraState.isScreenSharing
                ? Icons.stop_screen_share_rounded
                : Icons.screen_share_rounded,
            label: agoraState.isScreenSharing ? 'Stop' : 'Share',
            isActive: agoraState.isScreenSharing,
            activeColor: Colors.blue,
            onTap: onScreenShare,
            w: w,
          ),
          _CtrlBtn(
            icon: Icons.flip_camera_ios_rounded,
            label: 'Flip',
            isActive: false,
            onTap: onSwitch,
            w: w,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Control button widget
// ─────────────────────────────────────────────────────────────────────────────
class _CtrlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;
  final double w;

  const _CtrlBtn({
    required this.icon,
    required this.label,
    required this.isActive,
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
            width: w * 0.125,
            height: w * 0.125,
            decoration: BoxDecoration(
              color: isActive ? activeColor.withOpacity(0.22) : _C.white12,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? activeColor.withOpacity(0.4)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? activeColor : _C.white85,
              size: w * 0.054,
            ),
          ),
          SizedBox(height: w * 0.012),
          Text(
            label,
            style: TextStyle(
              color: _C.white45,
              fontSize: w * 0.024,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error toast
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorToast extends StatelessWidget {
  final String message;
  final double w;

  const _ErrorToast({required this.message, required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
      decoration: BoxDecoration(
        color: const Color(0xFFB71C1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.white70,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: _C.white, fontSize: w * 0.031),
            ),
          ),
        ],
      ),
    );
  }
}
