import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/models/chat/chat_model.dart';
import 'package:quran_learning_app/provider/chat_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/navigation/app_router.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;

  const ChatConversationScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  ConsumerState<ChatConversationScreen> createState() =>
      _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends ConsumerState<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatConversationProvider);
    final notifier = ref.read(chatConversationProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, width),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.015,
              ),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];

                // Date divider — first message
                if (index == 0) {
                  return Column(
                    children: [
                      _buildDateDivider('Today', width),
                      _MessageBubble(
                        message: message,
                        width: width,
                        height: height,
                      ),
                    ],
                  );
                }
                return _MessageBubble(
                  message: message,
                  width: width,
                  height: height,
                );
              },
            ),
          ),

          // Input bar
          _buildInputBar(context, notifier, width, height),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, double width) {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.white,
          size: width * 0.05,
        ),
        onPressed: () => context.go(AppRoutes.chatList),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: width * 0.045,
            backgroundColor: Colors.white24,
            child: Text(
              widget.userName[0],
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.038,
              ),
            ),
          ),
          SizedBox(width: width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.038,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '● Online',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: width * 0.028,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.call_outlined,
            color: AppColors.white,
            size: width * 0.055,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.videocam_outlined,
            color: AppColors.white,
            size: width * 0.055,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDateDivider(String date, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.03),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Text(
              date,
              style: TextStyle(
                fontSize: width * 0.03,
                color: AppColors.textGrey,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    ChatConversationNotifier notifier,
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.04,
        height * 0.012,
        width * 0.04,
        height * 0.025,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment
          Icon(
            Icons.attach_file_outlined,
            color: AppColors.textGrey,
            size: width * 0.055,
          ),
          SizedBox(width: width * 0.02),

          // Text field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.01,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.textLight),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(fontSize: width * 0.035),
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: AppColors.textLight,
                    fontSize: width * 0.035,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          SizedBox(width: width * 0.02),

          // Send button
          GestureDetector(
            onTap: () {
              if (_messageController.text.trim().isNotEmpty) {
                notifier.sendMessage(_messageController.text);
                _messageController.clear();
                _scrollToBottom();
              }
            },
            child: Container(
              width: width * 0.11,
              height: width * 0.11,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: AppColors.white,
                size: width * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final double width;
  final double height;

  const _MessageBubble({
    required this.message,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isSentByMe;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.01),
        constraints: BoxConstraints(maxWidth: width * 0.72),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.012,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primaryGreen : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.message,
              style: TextStyle(
                fontSize: width * 0.035,
                color: isMine ? AppColors.white : AppColors.textDark,
                height: 1.4,
              ),
            ),
            SizedBox(height: height * 0.004),
            Text(
              message.time,
              style: TextStyle(
                fontSize: width * 0.027,
                color: isMine
                    ? AppColors.white.withOpacity(0.7)
                    : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
