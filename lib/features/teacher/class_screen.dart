import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/chat/chat_model.dart';
import 'package:quran_learning_app/provider/chat_provider.dart';
import 'package:quran_learning_app/provider/class_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════
// CLASS SCREEN — Teacher's Virtual Classroom
// ═══════════════════════════════════════════════════════════════════════════

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
  Timer? _timer;
  int _seconds = 0;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(classProvider.notifier)
          .initClass(widget.studentName, widget.subject, widget.time);
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
    _notesController.dispose();
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
            _buildNotesSection(state.notes, width, height),
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
            onTap: () => context.go(AppRoutes.dashboard),
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
                  widget.studentName,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  widget.subject,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: width * 0.03,
                  ),
                ),
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
              widget.studentName.isNotEmpty ? widget.studentName[0] : '?',
              style: TextStyle(
                color: AppColors.white,
                fontSize: width * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            widget.studentName,
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

  Widget _buildNotesSection(String notes, double width, double height) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.012,
      ),
      child: TextField(
        controller: _notesController,
        style: TextStyle(color: AppColors.white, fontSize: width * 0.033),
        maxLines: 2,
        onChanged: (val) => ref.read(classProvider.notifier).updateNotes(val),
        decoration: InputDecoration(
          hintText: 'Add notes about the class...',
          hintStyle: TextStyle(color: Colors.white38, fontSize: width * 0.033),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(width * 0.03),
        ),
      ),
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
            onTap: () {
              // Open chat overlay or navigate to chat room
            },
          ),
          _ControlButton(
            icon: Icons.call_end,
            label: 'End',
            isActive: false,
            isEnd: true,
            width: width,
            height: height,
            onTap: () => _showEndCallDialog(context),
          ),
        ],
      ),
    );
  }

  void _showEndCallDialog(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'End Class',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: width * 0.042,
          ),
        ),
        content: Text(
          'Are you sure you want to end this class?',
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
              Navigator.pop(ctx);
              context.go(
                AppRoutes.progressNotes,
                extra: {'studentName': widget.studentName, 'studentId': '1'},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rejected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('End Class', style: TextStyle(fontSize: width * 0.035)),
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

// ═══════════════════════════════════════════════════════════════════════════
// CHAT ROOM SCREEN — The actual messaging UI
// ═══════════════════════════════════════════════════════════════════════════

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String studentName;
  final String studentImage;
  final String studentId;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.studentName,
    required this.studentImage,
    required this.studentId,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final String _myUid = FirebaseAuth.instance.currentUser!.uid;

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatActionsProvider.notifier).markMessagesRead(widget.roomId);
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _msgCtrl.clear();

    try {
      await ref
          .read(chatActionsProvider.notifier)
          .sendMessage(roomId: widget.roomId, text: text);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send: $e'),
            backgroundColor: AppColors.rejected,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final messagesAsync = ref.watch(messagesProvider(widget.roomId));

    ref.listen(messagesProvider(widget.roomId), (prev, next) {
      if (next.hasValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context, w, h),
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (messages) {
                if (messages.isEmpty) return _buildEmptyChat(w, h);
                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: h * 0.015,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    final isMe = msg.senderId == _myUid;
                    final showDate =
                        i == 0 ||
                        !_isSameDay(messages[i - 1].createdAt, msg.createdAt);

                    return Column(
                      children: [
                        if (showDate) _buildDateChip(msg.createdAt, w),
                        _MessageBubble(msg: msg, isMe: isMe, w: w, h: h),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildInputBar(w, h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double w, double h) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + h * 0.01,
        bottom: h * 0.015,
        left: w * 0.03,
        right: w * 0.04,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkGreen, AppColors.primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: w * 0.02),
          CircleAvatar(
            radius: w * 0.055,
            backgroundColor: Colors.white24,
            backgroundImage: widget.studentImage.isNotEmpty
                ? NetworkImage(widget.studentImage)
                : null,
            child: widget.studentImage.isEmpty
                ? Text(
                    widget.studentName.isNotEmpty
                        ? widget.studentName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                  widget.studentName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Student',
                  style: TextStyle(color: Colors.white70, fontSize: w * 0.028),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(double w, double h) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.waving_hand_rounded,
            size: w * 0.1,
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
          ),
          SizedBox(height: h * 0.01),
          Text(
            'Say Assalam u Alaikum! 👋',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(DateTime? date, double w) {
    if (date == null) return const SizedBox.shrink();
    final label = _isToday(date)
        ? 'Today'
        : _isYesterday(date)
        ? 'Yesterday'
        : DateFormat('MMM d, yyyy').format(date);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * 0.02),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: w * 0.028,
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(double w, double h) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        w * 0.04,
        h * 0.01,
        w * 0.04,
        MediaQuery.of(context).padding.bottom + h * 0.01,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgCtrl,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.02),
          IconButton(
            icon: Icon(Icons.send_rounded, color: AppColors.primaryGreen),
            onPressed: _send,
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime? a, DateTime? b) =>
      a?.year == b?.year && a?.month == b?.month && a?.day == b?.day;
  bool _isToday(DateTime d) => _isSameDay(d, DateTime.now());
  bool _isYesterday(DateTime d) =>
      _isSameDay(d, DateTime.now().subtract(const Duration(days: 1)));
}

class _MessageBubble extends StatelessWidget {
  final MessageModel msg;
  final bool isMe;
  final double w, h;

  const _MessageBubble({
    required this.msg,
    required this.isMe,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.01),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(color: isMe ? Colors.white : AppColors.textDark),
            ),

            Text(DateFormat('hh:mm a').format(msg.createdAt ?? DateTime.now())),
          ],
        ),
      ),
    );
  }
}
