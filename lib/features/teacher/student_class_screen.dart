import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/provider/class_provider.dart';

class StudentClassScreen extends ConsumerStatefulWidget {
  final String teacherName;
  // final String subject;
  final String time;

  const StudentClassScreen({
    super.key,
    required this.teacherName,
    // required this.subject,
    required this.time,
  });

  @override
  ConsumerState<StudentClassScreen> createState() => _StudentClassScreenState();
}

class _StudentClassScreenState extends ConsumerState<StudentClassScreen> {
  Timer? _timer;
  int _seconds = 0;
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(classProvider.notifier)
          .initClass(widget.teacherName, widget.time);
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      final h = (_seconds ~/ 3600).toString().padLeft(2, '0');
      final m = ((_seconds % 3600) ~/ 60).toString().padLeft(2, '0');
      final s = (_seconds % 60).toString().padLeft(2, '0');
      ref.read(classProvider.notifier).updateElapsedTime('$h:$m:$s');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(classProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, state.elapsedTime, width, height),
            Expanded(
              child: Stack(
                children: [
                  _buildMainVideo(width, height),
                  Positioned(
                    top: height * 0.02,
                    right: width * 0.04,
                    child: _buildSmallVideo(state.isVideoOn, width, height),
                  ),
                ],
              ),
            ),
            _buildControls(context, state, width, height),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    String elapsedTime,
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.015,
      ),
      color: Colors.black,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go(AppRoutes.studentDashboard),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
              size: width * 0.05,
            ),
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.teacherName,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                // Text(
                //   widget.subject,
                //   style: TextStyle(
                //     color: Colors.white54,
                //     fontSize: width * 0.03,
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.008,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              elapsedTime,
              style: TextStyle(
                color: AppColors.white,
                fontSize: width * 0.033,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: width * 0.02),
          Icon(
            Icons.notifications_outlined,
            color: AppColors.white,
            size: width * 0.055,
          ),
        ],
      ),
    );
  }

  Widget _buildMainVideo(double width, double height) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A2E),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: width * 0.13,
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.3),
            child: Text(
              widget.teacherName[0],
              style: TextStyle(
                color: AppColors.white,
                fontSize: width * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            widget.teacherName,
            style: TextStyle(
              color: AppColors.white,
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            'Video Stream',
            style: TextStyle(color: Colors.white38, fontSize: width * 0.033),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallVideo(bool isVideoOn, double width, double height) {
    return Container(
      width: width * 0.23,
      height: height * 0.15,
      decoration: BoxDecoration(
        color: isVideoOn
            ? AppColors.primaryGreen.withValues(alpha: 0.3)
            : Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white, width: 1.5),
      ),
      child: isVideoOn
          ? Icon(Icons.person, color: AppColors.white, size: width * 0.1)
          : Icon(Icons.videocam_off, color: Colors.white54, size: width * 0.08),
    );
  }

  Widget _buildControls(
    BuildContext context,
    ClassState state,
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.02,
      ),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: state.isMuted ? Icons.mic_off : Icons.mic,
            label: state.isMuted ? 'Unmute' : 'Mute',
            isActive: !state.isMuted,
            width: width,
            height: height,
            onTap: () => ref.read(classProvider.notifier).toggleMute(),
          ),
          _ControlButton(
            icon: state.isVideoOn ? Icons.videocam : Icons.videocam_off,
            label: 'Video',
            isActive: state.isVideoOn,
            width: width,
            height: height,
            onTap: () => ref.read(classProvider.notifier).toggleVideo(),
          ),
          _ControlButton(
            icon: Icons.screen_share_outlined,
            label: 'Share',
            isActive: state.isScreenSharing,
            width: width,
            height: height,
            onTap: () => ref.read(classProvider.notifier).toggleScreenShare(),
          ),
          _ControlButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            isActive: false,
            width: width,
            height: height,
            onTap: () {},
          ),
          _ControlButton(
            icon: Icons.call_end,
            label: 'Leave',
            isActive: false,
            isEnd: true,
            width: width,
            height: height,
            onTap: () => _showLeaveDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLeaveDialog(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Leave Class',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: width * 0.042,
          ),
        ),
        content: Text(
          'Are you sure you want to leave this class?',
          style: TextStyle(fontSize: width * 0.035),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Stay',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: width * 0.035,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.studentDashboard);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rejected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Leave', style: TextStyle(fontSize: width * 0.035)),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isEnd;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.width,
    required this.height,
    this.isEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width * 0.13,
            height: width * 0.13,
            decoration: BoxDecoration(
              color: isEnd
                  ? AppColors.rejected
                  : isActive
                  ? AppColors.primaryGreen
                  : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: width * 0.055),
          ),
          SizedBox(height: height * 0.008),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: width * 0.028),
          ),
        ],
      ),
    );
  }
}
