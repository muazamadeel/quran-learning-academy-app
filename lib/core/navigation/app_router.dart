import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/features/teacher/availability_screen.dart';
import 'package:quran_learning_app/features/teacher/booking_screen.dart';
import 'package:quran_learning_app/features/teacher/chat_conversation_screen.dart';
import 'package:quran_learning_app/features/teacher/chat_list_screen.dart';
import 'package:quran_learning_app/features/teacher/class_screen.dart';
import 'package:quran_learning_app/features/teacher/dashboard_screen.dart';
import 'package:quran_learning_app/features/teacher/progress_note_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.availability,
        builder: (context, state) => const AvailabilityScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookings,
        builder: (context, state) => const BookingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.classroom,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ClassScreen(
            studentName: extra['studentName'] as String,
            subject: extra['subject'] as String,
            time: extra['time'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.progressNotes,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ProgressNotesScreen(
            studentName: extra['studentName'] as String,
            studentId: extra['studentId'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.chatList,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatConversation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ChatConversationScreen(
            userId: extra['userId'] as String,
            userName: extra['userName'] as String,
          );
        },
      ),
    ],
  );
}

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String availability = '/availability';
  static const String bookings = '/bookings';
  static const String classroom = '/classroom';
  static const String progressNotes = '/progress-notes';
  static const String chatList = '/chat';
  static const String chatConversation = '/chat/conversation';
}
