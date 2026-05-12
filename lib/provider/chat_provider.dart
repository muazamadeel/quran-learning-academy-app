import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quran_learning_app/models/chat/chat_model.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

final _db = FirebaseFirestore.instance;
// roomId = teacherId_studentId (deterministic)
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
// AUTHENTICATED CHAT USERS (Based on bookings)
// ─────────────────────────────────────────────────────────────────────────────

/// Ids of users that the current user is allowed to chat with (based on bookings)
final authorizedParticipantsProvider = StreamProvider<Set<String>>((ref) {
  final authState = ref.watch(authProvider);
  final uid = authState.user?.id ?? '';
  if (uid.isEmpty) return Stream.value({});

  return _db
      .collection('bookings')
      .where('participants', arrayContains: uid)
      .snapshots()
      .map((snap) {
        final ids = <String>{};
        for (final doc in snap.docs) {
          final data = doc.data();
          final teacherId = data['teacherId'] as String? ?? '';
          final studentId = data['studentId'] as String? ?? '';

          if (teacherId == uid) {
            ids.add(studentId);
          } else if (studentId == uid) {
            ids.add(teacherId);
          }
        }
        return ids;
      });
});

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
    final authState = ref.watch(authProvider);
    final uid = authState.user?.id ?? '';
    final authorizedIds = ref.watch(authorizedParticipantsProvider).value ?? {};

    if (uid.isEmpty) return Stream.value(const ChatListState());

    // Secure server-side query using participants array
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snap) {
          final allDocs = snap.docs.where((doc) {
            final d = doc.data();
            final teacherId = d['teacherId'] as String? ?? '';
            final studentId = d['studentId'] as String? ?? '';

            // Check if there is a booking between us (Authorized)
            final otherId = teacherId == uid ? studentId : teacherId;
            return authorizedIds.contains(otherId);
          }).toList();

          allDocs.sort((a, b) {
            final ta = a.data()['lastMessageAt'] as Timestamp?;
            final tb = b.data()['lastMessageAt'] as Timestamp?;
            if (ta == null || tb == null) return 0;
            return tb.compareTo(ta);
          });

          final users = allDocs
              .map((doc) => ChatUser.fromFirestore(doc, uid))
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
  final authState = ref.watch(authProvider);
  final uid = authState.user?.id ?? '';

  if (uid.isEmpty) return Stream.value([]);

  // roomId = teacherId_studentId. Check if I am one of them.
  if (!roomId.contains(uid)) {
    return Stream.value([]);
  }

  return _db
      .collection('chats')
      .doc(roomId)
      .collection('messages')
      .orderBy('createdAt', descending: false)
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
    required String teacherImage,
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
        'participants': [teacherId, studentId],
        'teacherName': teacherName,
        'teacherImage': teacherImage,
        'studentName': studentName,
        'studentImage': studentImage,
        'lastMessage': '',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount': 0,
        'unreadForTeacher': 0,
        'unreadForStudent': 0,
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

    final uid = ref.read(authProvider).user?.id ?? '';
    if (uid.isEmpty) return;

    final roomRef = _db.collection('chats').doc(roomId);
    final roomSnap = await roomRef.get();
    if (!roomSnap.exists) return;
    final teacherId = roomSnap.data()?['teacherId'] as String? ?? '';
    final incField = uid == teacherId ? 'unreadForStudent' : 'unreadForTeacher';

    final batch = _db.batch();

    final msgRef = _db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .doc();

    batch.set(msgRef, {
      'senderId': uid,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    batch.update(roomRef, {
      'lastMessage': text.trim(),
      'lastMessageSenderId': uid,
      'lastMessageAt': FieldValue.serverTimestamp(),
      incField: FieldValue.increment(1),
      'unreadCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  /// Room kholne pe student ke messages read mark karo
  Future<void> markMessagesRead(String roomId) async {
    final uid = ref.read(authProvider).user?.id ?? '';
    if (uid.isEmpty) return;

    final roomRef = _db.collection('chats').doc(roomId);
    final roomSnap = await roomRef.get();
    if (!roomSnap.exists) return;
    final data = roomSnap.data()!;
    final teacherId = data['teacherId'] as String? ?? '';
    final isTeacher = teacherId == uid;
    final unreadField = isTeacher ? 'unreadForTeacher' : 'unreadForStudent';

    final snap = await _db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: uid)
        .get();

    if (snap.docs.isEmpty) {
      await roomRef.update({unreadField: 0, 'unreadCount': 0});
      return;
    }

    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    batch.update(roomRef, {unreadField: 0, 'unreadCount': 0});
    await batch.commit();
  }
}
