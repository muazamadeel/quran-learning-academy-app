import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  final String id;
  final String studentId;
  final String studentName;
  final String teacherId;
  final String teacherName;
  final String progressNote;
  final String whatWasCovered;
  final String homework;
  final String rating;
  final DateTime date;

  ProgressModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.teacherId,
    required this.teacherName,
    required this.progressNote,
    required this.whatWasCovered,
    required this.homework,
    required this.rating,
    required this.date,
  });

  factory ProgressModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final dtValue = d['date'] ?? d['dateTime'] ?? d['createdAt'];
    DateTime date;
    if (dtValue is Timestamp) {
      date = dtValue.toDate();
    } else if (dtValue is String) {
      date = DateTime.tryParse(dtValue) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    return ProgressModel(
      id: doc.id,
      studentId: d['studentId'] ?? '',
      studentName: d['studentName'] ?? '',
      teacherId: d['teacherId'] ?? '',
      teacherName: d['teacherName'] ?? '',
      progressNote: d['progressNote'] ?? '',
      whatWasCovered: d['whatWasCovered'] ?? '',
      homework: d['homework'] ?? '',
      rating: d['rating'] ?? 'Good',
      date: date,
    );
  }
}
