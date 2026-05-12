import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/progress/progress_model.dart';

final progressStudentProvider =
    StreamProvider.family<List<ProgressModel>, String>((ref, studentId) {
      if (studentId.isEmpty) return const Stream.empty();

      return FirebaseFirestore.instance
          .collection('progress_notes')
          .where('studentId', isEqualTo: studentId)
          .orderBy('date', descending: true)
          .snapshots()
          .map(
            (snap) => snap.docs.map((e) => ProgressModel.fromDoc(e)).toList(),
          );
    });
