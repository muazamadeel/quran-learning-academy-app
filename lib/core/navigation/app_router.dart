// import 'package:go_router/go_router.dart';
// import 'package:quran_learning_app/features/auth/login_screen.dart';
// import 'package:quran_learning_app/features/auth/signup_screen.dart';
// import 'package:quran_learning_app/features/auth/teacher_availability_screen.dart';
// import 'package:quran_learning_app/features/auth/approval_pending_screen.dart';
// import 'package:quran_learning_app/features/update_availabilty_screen.dart';
// import 'package:quran_learning_app/features/splash_screen.dart';
// import 'package:quran_learning_app/features/teacher/dashboard_screen.dart';
// import 'package:quran_learning_app/features/teacher/booking_screen.dart';
// import 'package:quran_learning_app/features/teacher/class_screen.dart';
// import 'package:quran_learning_app/features/teacher/progress_note_screen.dart';
// import 'package:quran_learning_app/features/teacher/student_dashboard_screen.dart';
// import 'package:quran_learning_app/features/teacher/widget/teacher_list_screen.dart';
// import 'package:quran_learning_app/features/teacher/student_booking_screen.dart';
// import 'package:quran_learning_app/models/student/student_model.dart';
// import 'package:quran_learning_app/features/teacher/widget/schedule_screen.dart';
// import 'package:quran_learning_app/features/teacher/widget/student_progress.dart';
// import 'package:quran_learning_app/features/teacher/widget/subscription_screen.dart';
// import 'package:quran_learning_app/features/teacher/student_class_screen.dart';
// import 'package:quran_learning_app/features/teacher/chat_list_screen.dart';

// class AppRouter {
//   static final router = GoRouter(
//     initialLocation: AppRoutes.splash,
//     routes: [
//       // ── Auth ────────────────────────────────────────────────────────────
//       GoRoute(
//         path: AppRoutes.splash,
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.login,
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.signup,
//         builder: (context, state) => const SignupScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.teacherAvailability,
//         builder: (context, state) => const TeacherAvailabilityScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.approvalPending,
//         builder: (context, state) => const ApprovalPendingScreen(),
//       ),

//       // ── Teacher Routes ───────────────────────────────────────────────────
//       GoRoute(
//         path: AppRoutes.dashboard,
//         name: AppRoutes.dashboard,
//         builder: (context, state) => const DashboardScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.availability,
//         name: AppRoutes.availability,
//         builder: (context, state) => const UpdateAvailabilityScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.bookings,
//         name: AppRoutes.bookings,
//         builder: (context, state) => const BookingsScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.classroom,
//         name: AppRoutes.classroom,
//         builder: (context, state) {
//           final extra = state.extra as Map<String, dynamic>;
//           return ClassScreen(
//             studentName: extra['studentName'] as String,
//             subject: extra['subject'] as String,
//             time: extra['time'] as String,
//           );
//         },
//       ),
//       GoRoute(
//         path: AppRoutes.progressNotes,
//         name: AppRoutes.progressNotes,
//         builder: (context, state) {
//           final extra = state.extra as Map<String, dynamic>;
//           return ProgressNotesScreen(
//             studentName: extra['studentName'] as String,
//             studentId: extra['studentId'] as String,
//           );
//         },
//       ),

//       // ── Student Routes ───────────────────────────────────────────────────
//       GoRoute(
//         path: AppRoutes.studentDashboard,
//         name: AppRoutes.studentDashboard,
//         builder: (context, state) => const StudentDashboardScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.teacherList,
//         name: AppRoutes.teacherList,
//         builder: (context, state) {
//           final extra = state.extra as Map<String, dynamic>?;
//           final course = extra?['course'] as String? ?? '';
//           return TeacherListScreen(selectedCourse: course);
//         },
//       ),
//       GoRoute(
//         path: AppRoutes.studentBooking,
//         name: AppRoutes.studentBooking,
//         builder: (context, state) {
//           final extra = state.extra as Map<String, dynamic>;
//           return StudentBookingScreen(
//             teacher: extra['teacher'] as TeacherListModel,
//           );
//         },
//       ),
//       GoRoute(
//         path: AppRoutes.studentSchedule,
//         name: AppRoutes.studentSchedule,
//         builder: (context, state) => const StudentScheduleScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.studentProgress,
//         name: AppRoutes.studentProgress,
//         builder: (context, state) => const StudentProgressScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.subscription,
//         name: AppRoutes.subscription,
//         builder: (context, state) => const SubscriptionScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.studentClassroom,
//         name: AppRoutes.studentClassroom,
//         builder: (context, state) {
//           final extra = state.extra as Map<String, dynamic>;
//           return StudentClassScreen(
//             teacherName: extra['teacherName'] as String,
//             subject: extra['subject'] as String,
//             time: extra['time'] as String,
//           );
//         },
//       ),
//       GoRoute(
//         path: AppRoutes.chatList,
//         name: AppRoutes.chatList,
//         builder: (context, state) => const ChatListScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.chatConversation,
//         builder: (ctx, state) {
//           final e = state.extra as Map<String, dynamic>;
//           return ChatRoomScreen(
//             roomId: e['roomId'] as String,
//             userName: e['userName'] as String,
//             userAvatar: e['userAvatar'] as String? ?? '',
//             userId: e['userId'] as String,
//           );
//         },
//       ),
//     ],
//   );
// }

// class AppRoutes {
//   // Auth
//   static const String splash = '/';
//   static const String login = '/login';
//   static const String signup = '/signup';
//   static const String teacherAvailability = '/teacher-availability';
//   static const String approvalPending = '/approval-pending';

//   // Teacher
//   static const String dashboard = '/dashboard';
//   static const String availability = '/availability';
//   static const String bookings = '/bookings';
//   static const String classroom = '/classroom';
//   static const String progressNotes = '/progress-notes';

//   // Student
//   static const String studentDashboard = '/student-dashboard';
//   static const String teacherList = '/teacher-list';
//   static const String studentBooking = '/student-booking';
//   static const String studentSchedule = '/student-schedule';
//   static const String studentProgress = '/student-progress';
//   static const String subscription = '/subscription';
//   static const String studentClassroom = '/student-classroom';

//   // Chat
//   static const String chatList = '/chat-list';
//   static const String chatConversation = '/chat-conversation';
// }
import 'package:go_router/go_router.dart';

// Auth
import 'package:quran_learning_app/features/auth/login_screen.dart';
import 'package:quran_learning_app/features/auth/signup_screen.dart';
import 'package:quran_learning_app/features/auth/teacher_availability_screen.dart';
import 'package:quran_learning_app/features/auth/approval_pending_screen.dart';

// Core
import 'package:quran_learning_app/features/splash_screen.dart';
import 'package:quran_learning_app/features/update_availabilty_screen.dart';

// Teacher
import 'package:quran_learning_app/features/teacher/dashboard_screen.dart';
import 'package:quran_learning_app/features/teacher/booking_screen.dart';
import 'package:quran_learning_app/features/teacher/class_screen.dart';
import 'package:quran_learning_app/features/teacher/progress_note_screen.dart';
import 'package:quran_learning_app/features/teacher/chat_list_screen.dart';

// Student
import 'package:quran_learning_app/features/teacher/student_dashboard_screen.dart';
import 'package:quran_learning_app/features/teacher/student_booking_screen.dart';
import 'package:quran_learning_app/features/teacher/student_class_screen.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_list_screen.dart';
import 'package:quran_learning_app/features/teacher/widget/schedule_screen.dart';
import 'package:quran_learning_app/features/teacher/widget/student_progress.dart';
import 'package:quran_learning_app/features/teacher/widget/subscription_screen.dart';

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

      GoRoute(
        path: AppRoutes.classroom,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>;
          return ClassScreen(
            studentName: e['studentName'],
            subject: e['subject'],
            time: e['time'],
          );
        },
      ),

      GoRoute(
        path: AppRoutes.progressNotes,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>;
          return ProgressNotesScreen(
            studentName: e['studentName'],
            studentId: e['studentId'],
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
          final e = state.extra as Map<String, dynamic>?;
          return TeacherListScreen(selectedCourse: e?['course'] ?? '');
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
        builder: (context, state) => const StudentProgressScreen(),
      ),

      GoRoute(
        path: AppRoutes.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),

      GoRoute(
        path: AppRoutes.studentClassroom,
        builder: (context, state) {
          final e = state.extra as Map<String, dynamic>;
          return StudentClassScreen(
            teacherName: e['teacherName'],
            subject: e['subject'],
            time: e['time'],
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
            studentName: e['studentName'],
            studentImage: e['studentImage'] ?? '',
            studentId: e['studentId'],
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

  static const studentDashboard = '/student-dashboard';
  static const teacherList = '/teacher-list';
  static const studentBooking = '/student-booking';
  static const studentSchedule = '/student-schedule';
  static const studentProgress = '/student-progress';
  static const subscription = '/subscription';
  static const studentClassroom = '/student-classroom';

  static const chatList = '/chat-list';
  static const chatConversation = '/chat-conversation';
}
