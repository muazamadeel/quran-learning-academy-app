import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/chat/chat_model.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';
import 'package:quran_learning_app/provider/chat_provider.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  // ── Yeh 4 parameters GoRouter extra se aate hain ──────────────────────────
  final String roomId;
  final String userName; // student name
  final String userAvatar; // student image url (empty string agar nahi)
  final String userId; // student uid

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.userName,
    required this.userAvatar,
    required this.userId,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();
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
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _isSending) return;

    _msgCtrl.clear();
    setState(() => _isSending = true);

    try {
      await ref
          .read(chatActionsProvider.notifier)
          .sendMessage(roomId: widget.roomId, text: text);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send: $e'),
            backgroundColor: AppColors.rejected,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
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

    // Naya message aaye to scroll down
    ref.listen(messagesProvider(widget.roomId), (_, x) => _scrollToBottom());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context, w, h),
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGreen,
                  strokeWidth: 2.5,
                ),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              ),
              data: (messages) {
                if (messages.isEmpty) return _buildEmptyChat(w, h);

                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: EdgeInsets.fromLTRB(
                    w * 0.04,
                    h * 0.015,
                    w * 0.04,
                    h * 0.01,
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
          _buildInputBar(context, w, h),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WIDGETS
  // ─────────────────────────────────────────────────────────────────────────

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
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: w * 0.03),
          CircleAvatar(
            radius: w * 0.055,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            backgroundImage: widget.userAvatar.isNotEmpty
                ? NetworkImage(widget.userAvatar)
                : null,
            child: widget.userAvatar.isEmpty
                ? Text(
                    widget.userName.isNotEmpty
                        ? widget.userName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
                  widget.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ref.watch(authProvider).isStudent ? 'Teacher' : 'Student',
                  style: TextStyle(color: Colors.white70, fontSize: w * 0.028),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
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
          Container(
            width: w * 0.22,
            height: w * 0.22,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.waving_hand_rounded,
              size: w * 0.1,
              color: AppColors.primaryGreen.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(height: h * 0.02),
          Text(
            'Say Assalam u Alaikum! 👋',
            style: TextStyle(
              fontSize: w * 0.04,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: h * 0.006),
          Text(
            'Start your conversation with ${widget.userName}',
            style: TextStyle(fontSize: w * 0.03, color: AppColors.textGrey),
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
      padding: EdgeInsets.symmetric(vertical: w * 0.025),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.015,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.08),
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

  Widget _buildInputBar(BuildContext context, double w, double h) {
    return Container(
      padding: EdgeInsets.only(
        left: w * 0.04,
        right: w * 0.03,
        top: h * 0.012,
        bottom: MediaQuery.of(context).padding.bottom + h * 0.012,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                controller: _msgCtrl,
                focusNode: _focusNode,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                minLines: 1,
                style: TextStyle(
                  fontSize: w * 0.035,
                  color: AppColors.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    fontSize: w * 0.035,
                    color: AppColors.textGrey,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: w * 0.04,
                    vertical: w * 0.03,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.025),
          GestureDetector(
            onTap: _isSending ? null : _send,
            child: Container(
              width: w * 0.12,
              height: w * 0.12,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkGreen, AppColors.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _isSending
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: w * 0.055,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isToday(DateTime d) => _isSameDay(d, DateTime.now());
  bool _isYesterday(DateTime d) =>
      _isSameDay(d, DateTime.now().subtract(const Duration(days: 1)));
}

// ─────────────────────────────────────────────────────────────────────────────
// MESSAGE BUBBLE
// ─────────────────────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final MessageModel msg;
  final bool isMe;
  final double w;
  final double h;

  const _MessageBubble({
    required this.msg,
    required this.isMe,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = msg.createdAt != null
        ? DateFormat('h:mm a').format(msg.createdAt!)
        : '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: msg.text));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Message copied'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(
            bottom: h * 0.006,
            left: isMe ? w * 0.12 : 0,
            right: isMe ? 0 : w * 0.12,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.03,
          ),
          decoration: BoxDecoration(
            gradient: isMe
                ? const LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isMe ? null : AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isMe ? 18 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg.text,
                style: TextStyle(
                  fontSize: w * 0.036,
                  color: isMe ? Colors.white : AppColors.textDark,
                  height: 1.4,
                ),
              ),
              SizedBox(height: h * 0.004),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: w * 0.025,
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.textGrey,
                    ),
                  ),
                  if (isMe) ...[
                    SizedBox(width: w * 0.01),
                    Icon(
                      msg.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                      size: w * 0.032,
                      color: msg.isRead
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.55),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
