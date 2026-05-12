import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
import 'package:quran_learning_app/core/service/notification_service.dart';
import 'package:quran_learning_app/core/utils/booking_schedule_utils.dart';

// ─── Dashboard State ───────────────────────────────────────────────────────
class StudentDashboardState {
  final StudentModel? student;
  final List<StudentUpcomingClassModel> upcomingClasses;
  final List<StudentUpcomingClassModel> completedClasses;
  final List<TeacherListModel> availableTeachers;
  final int trialDaysLeft;
  final bool isLoading;

  const StudentDashboardState({
    this.student,
    this.upcomingClasses = const [],
    this.completedClasses = const [],
    this.availableTeachers = const [],
    this.trialDaysLeft = 30,
    this.isLoading = true,
  });

  StudentDashboardState copyWith({
    StudentModel? student,
    List<StudentUpcomingClassModel>? upcomingClasses,
    List<StudentUpcomingClassModel>? completedClasses,
    List<TeacherListModel>? availableTeachers,
    int? trialDaysLeft,
    bool? isLoading,
  }) {
    return StudentDashboardState(
      student: student ?? this.student,
      upcomingClasses: upcomingClasses ?? this.upcomingClasses,
      completedClasses: completedClasses ?? this.completedClasses,
      availableTeachers: availableTeachers ?? this.availableTeachers,
      trialDaysLeft: trialDaysLeft ?? this.trialDaysLeft,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─── Notifier ──────────────────────────────────────────────────────────────
class StudentDashboardNotifier extends Notifier<StudentDashboardState> {
  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  StudentDashboardState build() {
    _loadData();
    return const StudentDashboardState();
  }

  Future<void> refresh() => _loadData();

  Future<void> _loadData() async {
    if (_uid.isEmpty) {
      debugPrint('⚠️ UID empty — user not logged in');
      state = state.copyWith(isLoading: false);
      return;
    }

    try {
      // 1. Student profile
      final userDoc = await _db.collection('users').doc(_uid).get();
      StudentModel? student;
      int trialDaysLeft = 30;

      if (userDoc.exists) {
        final d = userDoc.data()!;
        debugPrint('👤 User fields: ${d.keys.toList()}');
        debugPrint('📅 createdAt value: ${d['createdAt']}');

        student = StudentModel(
          id: userDoc.id,
          name: d['name'] ?? '',
          email: d['email'] ?? '',
          dob: d['dob'] ?? '',
          profileImage: d['profileImage'] ?? '',
          subscriptionPlan: d['subscriptionPlan'] ?? '',
          isSubscribed: d['isSubscribed'] ?? false,
        );

        if (d['createdAt'] != null && d['createdAt'] is Timestamp) {
          final createdAt = (d['createdAt'] as Timestamp).toDate();
          final daysPassed = DateTime.now().difference(createdAt).inDays;
          trialDaysLeft = (30 - daysPassed).clamp(0, 30);
          debugPrint(
            '📆 Days passed: $daysPassed | Trial left: $trialDaysLeft',
          );
        } else {
          debugPrint('⚠️ createdAt field missing ya Timestamp nahi hai!');
        }
      } else {
        debugPrint('❌ User document exist nahi karta: $_uid');
      }

      // 2. Upcoming bookings — date string se filter
      debugPrint('🔍 Upcoming bookings fetch ho rahi hain...');
      final upcomingSnap = await _db
          .collection('bookings')
          .where('studentId', isEqualTo: _uid)
          .where('status', isEqualTo: 'confirmed')
          .orderBy('dateTime')
          // .limit(10)
          .get();

      debugPrint('✅ Upcoming bookings count: ${upcomingSnap.docs.length}');
      final now = DateTime.now();
      final upcomingClasses = upcomingSnap.docs
          .where((doc) => isStudentUpcomingBookingDoc(doc.data(), now))
          .map((doc) {
            final d = doc.data();
            final scheduledAt = parseBookingScheduledAt(d);
            final teacherName = d['teacherName'] ?? 'Teacher';
            final displayTime =
                (d['studentSlotTime'] as String?)?.trim().isNotEmpty == true
                ? (d['studentSlotTime'] as String).trim()
                : (d['slotTime'] as String? ?? '');

            if (scheduledAt != null) {
              NotificationService.scheduleClassReminder(
                notificationId: doc.id.hashCode,
                channelName: teacherName,
                classTime: scheduledAt,
                isTeacher: false,
              );
            }

            return StudentUpcomingClassModel(
              id: doc.id,
              teacherName: teacherName,
              teacherImage: d['teacherImage'] ?? '',
              time: displayTime,
              date: d['date'] ?? '',
              status: d['status'] ?? 'confirmed',
              teacherId: d['teacherId'],
              studentId: d['studentId'],
              scheduledAt: scheduledAt,
              durationMinutes: (d['durationMinutes'] as num?)?.toInt() ?? 30,
            );
          })
          .take(3)
          .toList();

      // 3. Completed bookings
      debugPrint('🔍 Completed bookings fetch ho rahi hain...');
      final completedSnap = await _db
          .collection('bookings')
          .where('studentId', isEqualTo: _uid)
          .where('status', isEqualTo: 'completed')
          .orderBy('dateTime', descending: true)
          .limit(3)
          .get();

      debugPrint('✅ Completed bookings count: ${completedSnap.docs.length}');

      final completedClasses = completedSnap.docs.map((doc) {
        final d = doc.data();
        return StudentUpcomingClassModel(
          id: doc.id,
          teacherName: d['teacherName'] ?? '',
          teacherImage: d['teacherImage'] ?? '',
          time: d['slotTime'] ?? '',
          date: d['date'] ?? '',
          status: 'completed',
        );
      }).toList();

      // 4. Available teachers
      debugPrint('🔍 Teachers fetch ho rahe hain...');
      final teachersSnap = await _db
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .where('isApproved', isEqualTo: true)
          .limit(10)
          .get();

      debugPrint('✅ Teachers count: ${teachersSnap.docs.length}');

      final availableTeachers = teachersSnap.docs.map((doc) {
        final d = doc.data();
        debugPrint(
          '👨‍🏫 Teacher: ${d['name']} | role: ${d['role']} | isApproved: ${d['isApproved']}',
        );
        return TeacherListModel(
          id: doc.id,
          name: d['name'] ?? '',
          experience: d['experience'] ?? '',
          languages: List<String>.from(d['languages'] ?? []),
          rating: (d['rating'] ?? 0.0).toDouble(),
          totalStudents: d['totalStudents'] ?? 0,
          profileImage: d['profileImage'] ?? '',
          country: d['country'] ?? '',
          timezone: d['timezone'] ?? '',
          availability: Map<String, dynamic>.from(d['availability'] ?? {}),
        );
      }).toList();

      state = state.copyWith(
        student: student,
        upcomingClasses: upcomingClasses,
        completedClasses: completedClasses,
        availableTeachers: availableTeachers,
        trialDaysLeft: trialDaysLeft,
        isLoading: false,
      );

      debugPrint('🎉 Dashboard load complete!');
    } catch (e, st) {
      debugPrint('❌ Dashboard load FAILED: $e');
      debugPrint('$st');
      state = state.copyWith(isLoading: false);
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────
final studentDashboardProvider =
    NotifierProvider<StudentDashboardNotifier, StudentDashboardState>(
      StudentDashboardNotifier.new,
    );
