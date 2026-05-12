import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/service/notification_service.dart';
import 'package:quran_learning_app/core/utils/booking_schedule_utils.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';


// ─── Upcoming Stream ───────────────────────────────────────────────────────
final upcomingBookingsProvider =
    StreamProvider<List<StudentUpcomingClassModel>>((ref) {
      final authState = ref.watch(authProvider);
      final uid = authState.user?.id ?? '';
      
      if (uid.isEmpty) {
        debugPrint('⚠️ upcomingBookingsProvider: UID empty');
        return Stream.value([]);
      }

      debugPrint('🔍 upcomingBookingsProvider: uid=$uid');

      return FirebaseFirestore.instance
          .collection('bookings')
          .where('studentId', isEqualTo: uid)
          .where('status', isEqualTo: 'confirmed')
          .orderBy('dateTime')
          .snapshots()
          .map((snap) {
            debugPrint('📦 Upcoming raw docs: ${snap.docs.length}');
            final now = DateTime.now();
            final result = snap.docs
                .where((doc) =>
                    isStudentUpcomingBookingDoc(doc.data(), now),)
                .map((doc) => _fromDoc(doc))
                .toList();

            for (final cls in result) {
              final scheduledAt = cls.scheduledAt;
              if (scheduledAt == null) continue;
              NotificationService.scheduleClassReminder(
                notificationId: '${uid}_${cls.id}'.hashCode,
                channelName: cls.teacherName,
                classTime: scheduledAt,
                isTeacher: false,
              );
            }

            debugPrint('✅ Upcoming filtered: ${result.length}');
            return result;
          });
    });

final completedBookingsProvider =
    StreamProvider<List<StudentUpcomingClassModel>>((ref) {
      final authState = ref.watch(authProvider);
      final uid = authState.user?.id ?? '';
      if (uid.isEmpty) return Stream.value([]);

      return FirebaseFirestore.instance
          .collection('bookings')
          .where('studentId', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map((snap) => snap.docs.map(_fromDoc).toList());
    });
// ─── Helper ────────────────────────────────────────────────────────────────
StudentUpcomingClassModel _fromDoc(DocumentSnapshot doc) {
  final d = doc.data() as Map<String, dynamic>;
  final displayTime = (d['studentSlotTime'] as String?)?.trim().isNotEmpty == true
      ? (d['studentSlotTime'] as String).trim()
      : (d['slotTime'] as String? ?? '');
  return StudentUpcomingClassModel(
    id: doc.id,
    teacherName: d['teacherName'] ?? '',
    teacherImage: d['teacherImage'] ?? '',
    time: displayTime,
    date: d['date'] ?? '',
    status: d['status'] ?? 'confirmed',
    teacherId: d['teacherId'],
    studentId: d['studentId'],
    scheduledAt: parseBookingScheduledAt(d),
    durationMinutes: (d['durationMinutes'] as num?)?.toInt(),
  );
}

// ─── Tab State ─────────────────────────────────────────────────────────────
class StudentScheduleState {
  final int selectedTab;
  const StudentScheduleState({this.selectedTab = 0});
  StudentScheduleState copyWith({int? selectedTab}) =>
      StudentScheduleState(selectedTab: selectedTab ?? this.selectedTab);
}

class StudentScheduleNotifier extends Notifier<StudentScheduleState> {
  @override
  StudentScheduleState build() => const StudentScheduleState();

  void changeTab(int index) => state = state.copyWith(selectedTab: index);

  Future<void> cancelClass(String classId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(classId)
          .update({'status': 'cancelled'});
      debugPrint('✅ Class cancelled: $classId');
    } catch (e) {
      debugPrint('❌ Cancel error: $e');
    }
  }
}

final studentScheduleProvider =
    NotifierProvider<StudentScheduleNotifier, StudentScheduleState>(
      StudentScheduleNotifier.new,
    );
