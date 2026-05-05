import 'package:flutter_riverpod/legacy.dart';
import '../../models/chat/chat_model.dart';

class ChatListState {
  final List<ChatUserModel> chatUsers;
  final bool isLoading;

  const ChatListState({this.chatUsers = const [], this.isLoading = false});

  ChatListState copyWith({List<ChatUserModel>? chatUsers, bool? isLoading}) {
    return ChatListState(
      chatUsers: chatUsers ?? this.chatUsers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatListNotifier extends StateNotifier<ChatListState> {
  ChatListNotifier() : super(const ChatListState()) {
    _loadDummyData();
  }

  void _loadDummyData() {
    // Firebase ke baad replace hoga
    final users = [
      const ChatUserModel(
        id: '1',
        name: 'Ali Hassan',
        lastMessage: 'JazakAllah Khair Ustadh!',
        time: '10:30 AM',
        unreadCount: 2,
        isOnline: true,
      ),
      const ChatUserModel(
        id: '2',
        name: 'Fatima Khan',
        lastMessage: 'I will practice today inshAllah',
        time: '09:15 AM',
        unreadCount: 0,
        isOnline: true,
      ),
      const ChatUserModel(
        id: '3',
        name: 'Usman Tariq',
        lastMessage: 'Can we reschedule tomorrow?',
        time: 'Yesterday',
        unreadCount: 1,
        isOnline: false,
      ),
      const ChatUserModel(
        id: '4',
        name: 'Ayesha Malik',
        lastMessage: 'Assalamu Alaikum Ustadh',
        time: 'Yesterday',
        unreadCount: 0,
        isOnline: false,
      ),
    ];
    state = state.copyWith(chatUsers: users);
  }
}

// Chat conversation state
class ChatConversationState {
  final List<MessageModel> messages;
  final bool isSending;

  const ChatConversationState({
    this.messages = const [],
    this.isSending = false,
  });

  ChatConversationState copyWith({
    List<MessageModel>? messages,
    bool? isSending,
  }) {
    return ChatConversationState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }
}

class ChatConversationNotifier extends StateNotifier<ChatConversationState> {
  ChatConversationNotifier() : super(const ChatConversationState()) {
    _loadDummyMessages();
  }

  void _loadDummyMessages() {
    // Firebase ke baad replace hoga
    final messages = [
      const MessageModel(
        id: '1',
        message: 'Assalamu Alaikum! Ready for today\'s Tajweed lesson?',
        time: '9:02 AM',
        isSentByMe: true,
      ),
      const MessageModel(
        id: '2',
        message: 'Wa Alaikum Assalam Ustadh! Yes I am ready.',
        time: '9:05 AM',
        isSentByMe: false,
      ),
      const MessageModel(
        id: '3',
        message: 'Please review Surah Al-Fatiha before class.',
        time: '9:06 AM',
        isSentByMe: true,
      ),
      const MessageModel(
        id: '4',
        message: 'InshAllah I will. JazakAllah Khair Ustadh!',
        time: '9:10 AM',
        isSentByMe: false,
      ),
    ];
    state = state.copyWith(messages: messages);
  }

  // Firebase ke baad Firestore mein save hoga
  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final newMessage = MessageModel(
      id: DateTime.now().toString(),
      message: message.trim(),
      time: _getCurrentTime(),
      isSentByMe: true,
    );

    state = state.copyWith(messages: [...state.messages, newMessage]);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

// Providers
final chatListProvider = StateNotifierProvider<ChatListNotifier, ChatListState>(
  (ref) => ChatListNotifier(),
);

final chatConversationProvider =
    StateNotifierProvider<ChatConversationNotifier, ChatConversationState>(
      (ref) => ChatConversationNotifier(),
    );
