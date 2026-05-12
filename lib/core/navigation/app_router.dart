import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quran_learning_app/core/utils/booking_schedule_utils.dart';

// Auth
import 'package:quran_learning_app/features/auth/login_screen.dart';
import 'package:quran_learning_app/features/auth/signup_screen.dart';
import 'package:quran_learning_app/features/auth/teacher_availability_screen.dart';
import 'package:quran_learning_app/features/auth/approval_pending_screen.dart';

// Core
import 'package:quran_learning_app/features/splash_screen.dart';
import 'package:quran_learning_app/features/teacher/classroom_screen.dart';
import 'package:quran_learning_app/features/update_availabilty_screen.dart';

// Teacher
import 'package:quran_learning_app/features/teacher/dashboard_screen.dart';
import 'package:quran_learning_app/features/teacher/booking_screen.dart';
import 'package:quran_learning_app/features/teacher/progress_note_screen.dart';
import 'package:quran_learning_app/features/teacher/chat_list_screen.dart';

// Student
import 'package:quran_learning_app/features/teacher/student_dashboard_screen.dart';
import 'package:quran_learning_app/features/teacher/student_booking_screen.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_list_screen.dart';
import 'package:quran_learning_app/features/teacher/widget/schedule_screen.dart';
import 'package:quran_learning_app/features/teacher/widget/student_progress.dart';
import 'package:quran_learning_app/features/teacher/widget/subscription_screen.dart';
import 'package:quran_learning_app/features/teacher/widget/class_endscreen.dart';

// Chat
import 'package:quran_learning_app/features/teacher/chatroom_screen.dart';

// Profile
import 'package:quran_learning_app/features/profile/profile_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // ───── Splash ─────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ───── Auth ─────
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.teacherAvailability,
        builder: (context, state) => const TeacherAvailabilityScreen(),
      ),
      GoRoute(
        path: AppRoutes.approvalPending,
        builder: (context, state) => const ApprovalPendingScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),

      // ───── Teacher ─────
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.availability,
        builder: (context, state) => const UpdateAvailabilityScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookings,
        builder: (context, state) => const BookingsScreen(),
      ),

      // Classroom route ko is tarah update karein:
      GoRoute(
        path: AppRoutes.classroom,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>;
          return ClassroomScreen(
            channelName: e['channelName'],
            otherPersonName: e['otherPersonName'],
            time: e['time'],
            localUid: e['localUid'] ?? 0,
            scheduledAt: parseClassroomExtraScheduledAt(e),
            durationMinutes: e['durationMinutes'] ?? 30,
            studentId: e['studentId'],
            teacherId: e['teacherId'],
            studentName: e['studentName'],
            isTeacher: e['isTeacher'] ?? false,
          );
        },
      ),

      GoRoute(
        path: AppRoutes.progressNotes,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>? ?? {};

          return ProgressNotesScreen(
            studentName: e['studentName']?.toString() ?? '',
            studentId: e['studentId']?.toString() ?? '',
            teacherId: e['teacherId']?.toString() ?? '',
            isTeacher: e['isTeacher'] == true,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.classEnd,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>? ?? {};
          return ClassEndScreen(
            studentId: e['studentId']?.toString() ?? '',
            teacherId: e['teacherId']?.toString() ?? '',
            studentName: e['studentName']?.toString() ?? '',
            isTeacher: e['isTeacher'] == true,
            durationMinutes: (e['durationMinutes'] as num?)?.toInt() ?? 30,
          );
        },
      ),

      // ───── Student ─────
      GoRoute(
        path: AppRoutes.studentDashboard,
        builder: (context, state) => const StudentDashboardScreen(),
      ),

      GoRoute(
        path: AppRoutes.teacherList,
        builder: (context, state) {
          return TeacherListScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.studentBooking,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>;
          return StudentBookingScreen(teacher: e['teacher']);
        },
      ),

      GoRoute(
        path: AppRoutes.studentSchedule,
        builder: (context, state) => const StudentScheduleScreen(),
      ),
      GoRoute(
        path: AppRoutes.studentProgress,
        builder: (context, state) {
          final studentId =
              (state.extra as String?) ??
              FirebaseAuth.instance.currentUser?.uid ??
              '';

          return StudentProgressScreen(studentId: studentId);
        },
      ),

      GoRoute(
        path: AppRoutes.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),

      // ───── Student Classroom ─────
      GoRoute(
        path: AppRoutes.studentClassroom,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>;
          return ClassroomScreen(
            channelName: e['channelName'],
            otherPersonName: e['otherPersonName'],
            time: e['time'],
            localUid: e['localUid'] ?? 0,
            scheduledAt: parseClassroomExtraScheduledAt(e),
            durationMinutes: e['durationMinutes'] ?? 30,
            studentId: e['studentId'],
            teacherId: e['teacherId'],
            studentName: e['studentName'],
            isTeacher: e['isTeacher'] ?? false,
          );
        },
      ),

      // ───── Chat ─────
      GoRoute(
        path: AppRoutes.chatList,
        builder: (context, state) => const ChatListScreen(),
      ),

      GoRoute(
        path: AppRoutes.chatConversation,
        name: AppRoutes.chatConversation,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>;

          return ChatRoomScreen(
            roomId: e['roomId'],
            userName: e['userName'],
            userAvatar: e['userAvatar'] ?? '',
            userId: e['userId'],
          );
        },
      ),
    ],
  );
}

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const teacherAvailability = '/teacher-availability';
  static const approvalPending = '/approval-pending';

  static const dashboard = '/dashboard';
  static const availability = '/availability';
  static const bookings = '/bookings';
  static const classroom = '/classroom';
  static const progressNotes = '/progress-notes';
  static const classEnd = '/class-end';

  static const studentDashboard = '/student-dashboard';
  static const teacherList = '/teacher-list';
  static const studentBooking = '/student-booking';
  static const studentSchedule = '/student-schedule';
  static const studentProgress = '/student-progress';
  static const subscription = '/subscription';
  static const studentClassroom = '/student-classroom';

  static const chatList = '/chat-list';
  static const chatConversation = '/chat-conversation';
  static const profile = '/profile';
}
