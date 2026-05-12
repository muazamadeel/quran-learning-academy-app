import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:quran_learning_app/models/teacher/teacher_model.dart';
import 'package:quran_learning_app/models/teacher_class_model.dart';

final _db = FirebaseFirestore.instance;
String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

// ─── Teacher Profile — realtime ───────────────────────────────────────────────
final teacherProfileProvider = StreamProvider<TeacherModel?>((ref) {
  if (_uid.isEmpty) return Stream.value(null);
  return _db
      .collection('users')
      .doc(_uid)
      .snapshots()
      .map((snap) => snap.exists ? TeacherModelX.fromFirestore(snap) : null);
});

// ─── Upcoming Classes — realtime ──────────────────────────────────────────────
final upcomingClassesProvider = StreamProvider<List<TeacherClassModel>>((ref) {
  if (_uid.isEmpty) return Stream.value([]);
  return _db
      .collection('classes')
      .where('teacherId', isEqualTo: _uid)
      .where('status', whereIn: ['upcoming', 'live'])
      .orderBy('scheduledAt')
      .snapshots()
      .map(
        (s) => s.docs.map((d) => TeacherClassModelX.fromFirestore(d)).toList(),
      );
});

// ─── Completed Classes — realtime ─────────────────────────────────────────────
final completedClassesProvider = StreamProvider<List<TeacherClassModel>>((ref) {
  if (_uid.isEmpty) return Stream.value([]);
  return _db
      .collection('classes')
      .where('teacherId', isEqualTo: _uid)
      .where('status', isEqualTo: 'completed')
      .orderBy('scheduledAt', descending: true)
      .limit(20)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => TeacherClassModelX.fromFirestore(d)).toList(),
      );
});

// ─── Dashboard Stats — derived ────────────────────────────────────────────────
final dashboardStatsProvider = Provider<Map<String, int>>((ref) {
  final upcoming =
      ref.watch(upcomingClassesProvider).asData?.value ?? <TeacherClassModel>[];
  final completed =
      ref.watch(completedClassesProvider).asData?.value ??
      <TeacherClassModel>[];
  final teacher = ref.watch(teacherProfileProvider).asData?.value;
  final now = DateTime.now();

  final todayClasses = upcoming.where((c) {
    final d = c.scheduledAt;
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }).length;

  return {
    'totalStudents': teacher?.totalStudents ?? 0,
    'todayClasses': todayClasses,
    'upcomingCount': upcoming.length,
    'completedCount': completed.length,
  };
});

// ─── Search Query ─────────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((_) => '');

// ─── Filtered Upcoming — search applied ──────────────────────────────────────
final filteredUpcomingProvider = Provider<List<TeacherClassModel>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final list =
      ref.watch(upcomingClassesProvider).asData?.value ?? <TeacherClassModel>[];
  if (query.isEmpty) return list;
  return list
      .where(
        (c) =>
            c.studentName.toLowerCase().contains(query) ||
            c.subject.toLowerCase().contains(query),
      )
      .toList();
});

final teacherDashboardProvider = teacherProfileProvider;
