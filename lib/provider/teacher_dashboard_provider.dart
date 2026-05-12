import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quran_learning_app/models/teacher/teacher_model.dart';
import 'package:quran_learning_app/models/teacher_class_model.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';
import 'package:quran_learning_app/core/service/notification_service.dart';

final _db = FirebaseFirestore.instance;

// ─── Teacher Profile Stream ───────────────────────────────────────────────────
final teacherProfileProvider = StreamProvider<TeacherModel?>((ref) {
  final uid = ref.watch(authProvider).user?.id ?? '';
  if (uid.isEmpty) return const Stream.empty();

  return _db
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snap) => snap.exists ? TeacherModelX.fromFirestore(snap) : null);
});

// ─── All Bookings for teacher (single stream, filter client side) ─────────────
final _allBookingsProvider = StreamProvider<List<TeacherClassModel>>((ref) {
  final uid = ref.watch(authProvider).user?.id ?? '';
  if (uid.isEmpty) return const Stream.empty();

  return _db
      .collection('bookings')
      .where('teacherId', isEqualTo: uid)
      .snapshots()
      .map((s) {
        final list = s.docs
            .map((d) => TeacherClassModelX.fromBooking(d))
            .toList();
        list.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        return list;
      });
});

// ─── Upcoming Classes (confirmed + not yet passed) ────────────────────────────
final upcomingClassesProvider = Provider<List<TeacherClassModel>>((ref) {
  final all = ref.watch(_allBookingsProvider).asData?.value ?? [];
  final now = DateTime.now();
  return all
      .where(
        (c) =>
            c.status == 'confirmed' &&
            c.scheduledAt.isAfter(now.subtract(const Duration(minutes: 30))),
      )
      .toList();
});

// ─── Completed Classes ────────────────────────────────────────────────────────
final completedClassesProvider = Provider<List<TeacherClassModel>>((ref) {
  final all = ref.watch(_allBookingsProvider).asData?.value ?? [];
  final result = all.where((c) => c.status == 'completed').toList();
  result.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
  return result.take(20).toList();
});

// ─── Dashboard Stats ──────────────────────────────────────────────────────────
final dashboardStatsProvider = Provider<Map<String, int>>((ref) {
  final all = ref.watch(_allBookingsProvider).asData?.value ?? [];
  final teacher = ref.watch(teacherProfileProvider).asData?.value;

  final now = DateTime.now();

  final upcoming = all
      .where(
        (c) =>
            c.status == 'confirmed' &&
            c.scheduledAt.isAfter(now.subtract(const Duration(minutes: 30))),
      )
      .toList();

  final completed = all.where((c) => c.status == 'completed').toList();

  final todayClasses = all.where((c) {
    final d = c.scheduledAt;
    return c.status == 'confirmed' &&
        d.year == now.year &&
        d.month == now.month &&
        d.day == now.day;
  }).length;

  return {
    'totalStudents': teacher?.totalStudents ?? 0,
    'todayClasses': todayClasses,
    'upcomingCount': upcoming.length,
    'completedCount': completed.length,
    'overallCount': upcoming.length + completed.length,
  };
});

// ─── Search Query ─────────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((_) => '');

// ─── Filtered Upcoming ────────────────────────────────────────────────────────
final filteredUpcomingProvider = Provider<List<TeacherClassModel>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final list = ref.watch(upcomingClassesProvider);
  if (query.isEmpty) return list;
  return list
      .where(
        (c) =>
            c.studentName.toLowerCase().contains(query) ||
            c.subject.toLowerCase().contains(query),
      )
      .toList();
});
// ─── Notification Scheduler (Teacher) ──────────────────────────────────────────
final teacherNotificationScheduler = Provider<void>((ref) {
  final upcoming = ref.watch(upcomingClassesProvider);

  for (final cls in upcoming) {
    NotificationService.scheduleClassReminder(
      notificationId: cls.id.hashCode,
      channelName: cls.studentName,
      classTime: cls.scheduledAt,
      isTeacher: true,
    );
  }
});
