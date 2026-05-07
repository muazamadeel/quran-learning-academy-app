import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

@immutable
class StudentDashboardState {
  final StudentModel? student;
  final List<StudentUpcomingClassModel> upcomingClasses;
  final List<TeacherListModel> availableTeachers;
  final bool isLoading;
  final int trialDaysLeft;

  const StudentDashboardState({
    this.student,
    this.upcomingClasses = const [],
    this.availableTeachers = const [],
    this.isLoading = true,
    this.trialDaysLeft = 30,
  });

  StudentDashboardState copyWith({
    StudentModel? student,
    List<StudentUpcomingClassModel>? upcomingClasses,
    List<TeacherListModel>? availableTeachers,
    bool? isLoading,
    int? trialDaysLeft,
  }) {
    return StudentDashboardState(
      student: student ?? this.student,
      upcomingClasses: upcomingClasses ?? this.upcomingClasses,
      availableTeachers: availableTeachers ?? this.availableTeachers,
      isLoading: isLoading ?? this.isLoading,
      trialDaysLeft: trialDaysLeft ?? this.trialDaysLeft,
    );
  }
}

class StudentDashboardNotifier extends Notifier<StudentDashboardState> {
  final _db = FirebaseFirestore.instance;

  @override
  StudentDashboardState build() {
    _loadData();
    return const StudentDashboardState();
  }

  Future<void> _loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      // Load student profile
      final userDoc = await _db.collection('users').doc(uid).get();
      final userData = userDoc.data();

      StudentModel? student;
      int trialDaysLeft = 30;

      if (userData != null) {
        // Calculate trial days remaining
        if (userData['createdAt'] != null) {
          DateTime createdAt;
          if (userData['createdAt'] is Timestamp) {
            createdAt = (userData['createdAt'] as Timestamp).toDate();
          } else {
            createdAt =
                DateTime.tryParse(userData['createdAt'].toString()) ??
                    DateTime.now();
          }
          final daysSinceCreation =
              DateTime.now().difference(createdAt).inDays;
          trialDaysLeft = (30 - daysSinceCreation).clamp(0, 30);
        }

        student = StudentModel(
          id: uid,
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          dob: userData['dob'] ?? '',
          subscriptionPlan: userData['subscriptionPlan'] ?? '',
          totalClassesCompleted: userData['totalClassesCompleted'] ?? 0,
          upcomingClassesCount: userData['upcomingClassesCount'] ?? 0,
          isSubscribed: userData['isSubscribed'] ?? false,
        );
      }

      // Load approved teachers (limit 5 for dashboard)
      final teachersSnap = await _db
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .where('isApproved', isEqualTo: true)
          .limit(5)
          .get();

      final teachers = teachersSnap.docs.map((doc) {
        final d = doc.data();
        return TeacherListModel(
          id: doc.id,
          name: d['name'] ?? '',
          experience: d['experience'] ?? '',
          languages: List<String>.from(d['languages'] ?? []),
          rating: (d['rating'] ?? 0.0).toDouble(),
          totalStudents: d['totalStudents'] ?? 0,
          profileImage: d['profileImage'] ?? '',
          isAvailable: true,
          subjects: List<String>.from(d['subjects'] ?? []),
          country: d['country'] ?? '',
          timezone: d['timezone'] ?? '',
          availability: Map<String, dynamic>.from(d['availability'] ?? {}),
        );
      }).toList();

      // Load upcoming bookings
      final bookingsSnap = await _db
          .collection('bookings')
          .where('studentId', isEqualTo: uid)
          .where('status', isEqualTo: 'confirmed')
          .orderBy('dateTime')
          .limit(5)
          .get();

      final upcomingClasses = bookingsSnap.docs.map((doc) {
        final d = doc.data();
        return StudentUpcomingClassModel(
          id: doc.id,
          teacherName: d['teacherName'] ?? '',
          teacherImage: '',
          time: d['slotTime'] ?? '',
          date: d['date'] ?? '',
          subject: d['subject'] ?? 'Quran',
        );
      }).toList();

      state = state.copyWith(
        student: student,
        availableTeachers: teachers,
        upcomingClasses: upcomingClasses,
        trialDaysLeft: trialDaysLeft,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final studentDashboardProvider =
    NotifierProvider<StudentDashboardNotifier, StudentDashboardState>(
      StudentDashboardNotifier.new,
    );
