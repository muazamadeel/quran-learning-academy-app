import 'package:cloud_firestore/cloud_firestore.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CHAT USER — chat list mein har row
// ─────────────────────────────────────────────────────────────────────────────

class ChatUser {
  final String id; // roomId = teacherId_studentId
  final String userId; // student uid
  final String name; // student name
  final String role; // 'student'
  final String avatarUrl;
  final String lastMessage;
  final String time; // formatted string e.g. "9:30 AM"
  final int unreadCount;
  final DateTime? lastMessageAt;

  const ChatUser({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.lastMessageAt,
  });

  factory ChatUser.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final ts = d['lastMessageAt'] as Timestamp?;
    final dt = ts?.toDate();

    return ChatUser(
      id: doc.id,
      userId: d['studentId'] as String? ?? '',
      name: d['studentName'] as String? ?? '',
      role: 'student',
      avatarUrl: d['studentImage'] as String? ?? '',
      lastMessage: d['lastMessage'] as String? ?? '',
      time: dt != null ? _formatTime(dt) : '',
      unreadCount: d['unreadCount'] as int? ?? 0,
      lastMessageAt: dt,
    );
  }

  static String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final p = dt.hour < 12 ? 'AM' : 'PM';
      return '$h:$m $p';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MESSAGE MODEL
// Fields: messageId, senderId, text, createdAt, isRead
// isSentByMe — tumhare existing screen mein use hota tha,
//              ab ChatRoomScreen mein senderId == myUid check karo
// ─────────────────────────────────────────────────────────────────────────────

class MessageModel {
  final String messageId;
  final String senderId;
  final String text; // 'message' ki jagah 'text' use karo
  final DateTime? createdAt;
  final bool isRead;

  const MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    this.createdAt,
    this.isRead = false,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return MessageModel(
      messageId: doc.id,
      senderId: d['senderId'] as String? ?? '',
      text: d['text'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
      isRead: d['isRead'] as bool? ?? false,
    );
  }
}
