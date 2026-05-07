import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── IMPORTANT: Yeh file lib/provider/chat_provider.dart mein rakho ──────────
// chat_model.dart lib/models/chat/ mein rakho
import 'package:quran_learning_app/models/chat/chat_model.dart';

final _db = FirebaseFirestore.instance;
String get _uid => FirebaseAuth.instance.currentUser!.uid;

/// roomId = teacherId_studentId (deterministic)
String buildRoomId(String teacherId, String studentId) =>
    '${teacherId}_$studentId';

// ─────────────────────────────────────────────────────────────────────────────
// CHAT LIST STATE
// ─────────────────────────────────────────────────────────────────────────────

class ChatListState {
  final List<ChatUser> chatUsers;
  final bool isLoading;
  final String? error;

  const ChatListState({
    this.chatUsers = const [],
    this.isLoading = false,
    this.error,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. CHAT LIST PROVIDER — ref.watch(chatListProvider)
// ─────────────────────────────────────────────────────────────────────────────

final chatListProvider =
    StreamNotifierProvider<ChatListNotifier, ChatListState>(
      ChatListNotifier.new,
    );

class ChatListNotifier extends StreamNotifier<ChatListState> {
  @override
  Stream<ChatListState> build() {
    return _db
        .collection('chats')
        .where('teacherId', isEqualTo: _uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snap) {
          final users = snap.docs
              .map((doc) => ChatUser.fromFirestore(doc))
              .toList();
          return ChatListState(chatUsers: users, isLoading: false);
        });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. MESSAGES STREAM — ref.watch(messagesProvider(roomId))
// ─────────────────────────────────────────────────────────────────────────────

final messagesProvider = StreamProvider.family<List<MessageModel>, String>((
  ref,
  roomId,
) {
  return _db
      .collection('chats')
      .doc(roomId)
      .collection('messages')
      .orderBy(
        'createdAt',
        descending: false,
      ) // ascending: false nahi, descending: false
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((doc) => MessageModel.fromFirestore(doc)).toList(),
      );
});

// ─────────────────────────────────────────────────────────────────────────────
// 3. CHAT ACTIONS — room create, message send, read mark
// ─────────────────────────────────────────────────────────────────────────────

final chatActionsProvider = AsyncNotifierProvider<ChatActionsNotifier, void>(
  ChatActionsNotifier.new,
);

class ChatActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Booking confirm hone pe call karo — room exist kare to ignore
  Future<String> createOrGetRoom({
    required String teacherId,
    required String teacherName,
    required String studentId,
    required String studentName,
    required String studentImage,
  }) async {
    final roomId = buildRoomId(teacherId, studentId);
    final roomRef = _db.collection('chats').doc(roomId);
    final snap = await roomRef.get();

    if (!snap.exists) {
      await roomRef.set({
        'teacherId': teacherId,
        'studentId': studentId,
        'teacherName': teacherName,
        'studentName': studentName,
        'studentImage': studentImage,
        'lastMessage': '',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return roomId;
  }

  /// Message send karo
  Future<void> sendMessage({
    required String roomId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final batch = _db.batch();

    final msgRef = _db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .doc();

    batch.set(msgRef, {
      'senderId': _uid,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    batch.update(_db.collection('chats').doc(roomId), {
      'lastMessage': text.trim(),
      'lastMessageAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Room kholne pe student ke messages read mark karo
  Future<void> markMessagesRead(String roomId) async {
    final snap = await _db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: _uid)
        .get();

    if (snap.docs.isEmpty) return;

    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    batch.update(_db.collection('chats').doc(roomId), {'unreadCount': 0});
    await batch.commit();
  }
}
