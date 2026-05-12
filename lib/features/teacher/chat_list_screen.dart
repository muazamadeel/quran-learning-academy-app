import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';
import 'package:quran_learning_app/features/teacher/widget/student_bottom_nav.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';
import 'package:quran_learning_app/provider/chat_provider.dart';
import 'package:quran_learning_app/models/chat/chat_model.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatListProvider);
    final authState = ref.watch(authProvider);
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
          'Messages',
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
          // Top curve
          Container(
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
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.01,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: TextStyle(fontSize: width * 0.035),
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(
                    color: AppColors.textLight,
                    fontSize: width * 0.035,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textGrey,
                    size: width * 0.05,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.018,
                  ),
                ),
              ),
            ),
          ),

          // Chat list
          Expanded(
            child: chatAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              ),
              data: (state) {
                // Search filter
                final filteredUsers = _searchQuery.isEmpty
                    ? state.chatUsers
                    : state.chatUsers
                          .where(
                            (u) => u.name.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ),
                          )
                          .toList();

                if (filteredUsers.isEmpty) {
                  return _buildEmptyState(width, height);
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return _ChatUserTile(
                      user: user,
                      width: width,
                      height: height,
                      onTap: () {
                        context.push(
                          AppRoutes.chatConversation,
                          extra: {
                            'roomId': user.id,
                            'userId': user.userId,
                            'userName': user.name,
                            'userAvatar': user.avatarUrl,
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: authState.isStudent
          ? const StudentBottomNav(currentIndex: 4)
          : const TeacherBottomNav(currentIndex: 3),
    );
  }

  Widget _buildEmptyState(double width, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width * 0.2,
            height: width * 0.2,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: width * 0.1,
              color: AppColors.primaryGreen,
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: width * 0.042,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: height * 0.008),
          Text(
            'Chats appear after a booking is confirmed',
            style: TextStyle(
              fontSize: width * 0.033,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CHAT USER TILE
// ─────────────────────────────────────────────────────────────────────────────

class _ChatUserTile extends StatelessWidget {
  final ChatUser user;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _ChatUserTile({
    required this.user,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.012),
        padding: EdgeInsets.all(width * 0.035),
        decoration: BoxDecoration(
          color: user.unreadCount > 0
              ? AppColors.primaryGreen.withValues(alpha: 0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: user.unreadCount > 0
              ? Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.35),
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: width * 0.065,
              backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
              backgroundImage: user.avatarUrl.isNotEmpty
                  ? NetworkImage(user.avatarUrl)
                  : null,
              child: user.avatarUrl.isEmpty
                  ? Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.05,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: width * 0.03),

            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: user.unreadCount > 0
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: width * 0.038,
                            color: AppColors.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.015,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user.role[0].toUpperCase() + user.role.substring(1),
                          style: TextStyle(
                            fontSize: width * 0.022,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.004),
                  Text(
                    user.lastMessage.isEmpty
                        ? 'No messages yet'
                        : user.lastMessage,
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: user.unreadCount > 0
                          ? AppColors.textDark
                          : AppColors.textGrey,
                      fontWeight: user.unreadCount > 0
                          ? FontWeight.w500
                          : FontWeight.normal,
                      fontStyle: user.lastMessage.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            SizedBox(width: width * 0.02),

            // Time + unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.time,
                  style: TextStyle(
                    fontSize: width * 0.028,
                    color: user.unreadCount > 0
                        ? AppColors.primaryGreen
                        : AppColors.textGrey,
                    fontWeight: user.unreadCount > 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                SizedBox(height: height * 0.005),
                if (user.unreadCount > 0)
                  Container(
                    constraints: BoxConstraints(
                      minWidth: width * 0.055,
                      minHeight: width * 0.055,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.018,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      user.unreadCount > 99 ? '99+' : '${user.unreadCount}',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: width * 0.026,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
