import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressTeacherNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> addProgress({
    required String studentId,
    required String studentName,
    required String teacherId,
    required String teacherName,
    required String progressNote,
    required String whatWasCovered,
    required String homework,
    required String rating,
  }) async {
    var resolvedTeacherName = teacherName.trim();
    if (resolvedTeacherName.isEmpty && teacherId.isNotEmpty) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(teacherId)
            .get();
        resolvedTeacherName = userDoc.data()?['name']?.toString().trim() ?? '';
      } catch (_) {}
    }

    if (resolvedTeacherName.isEmpty) {
      resolvedTeacherName =
          FirebaseAuth.instance.currentUser?.displayName?.trim() ?? '';
    }

    await FirebaseFirestore.instance.collection('progress_notes').add({
      'studentId': studentId,
      'studentName': studentName,
      'teacherId': teacherId,
      'teacherName': resolvedTeacherName,
      'progressNote': progressNote,
      'whatWasCovered': whatWasCovered,
      'homework': homework,
      'rating': rating,
      'date': Timestamp.now(),
    });
  }

  Future<void> deleteProgress(String id) async {
    await FirebaseFirestore.instance
        .collection('progress_notes')
        .doc(id)
        .delete();
  }
}

final progressTeacherProvider = NotifierProvider<ProgressTeacherNotifier, void>(
  ProgressTeacherNotifier.new,
);
