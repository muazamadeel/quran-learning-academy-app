// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// part 'booking_model.freezed.dart';
// part 'booking_model.g.dart';

// @Freezed()
// abstract class BookingModel with _$BookingModel {
//   const BookingModel._();

//   const factory BookingModel({
//     required String id,
//     required String studentName,
//     required String studentImage,
//     required String date,
//     required String time,
//     required String subject,
//     @Default('pending') String status,
//     String? studentId,
//     String? teacherId,
//     DateTime? scheduledAt,
//     int? durationMinutes,
//     String? meetingLink,
//     double? studentRating,
//     String? studentReview,
//   }) = _BookingModel;

//   factory BookingModel.fromJson(Map<String, dynamic> json) =>
//       _$BookingModelFromJson(json);

//   factory BookingModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     // ── scheduledAt: dateTime field use karo ─────────────────────────────────
//     final DateTime? scheduledAt =
//         (data['dateTime'] as Timestamp?)?.toDate() ??
//         (data['scheduledAt'] as Timestamp?)?.toDate();

//     // ── date string: Firestore ka 'date' field directly lo ───────────────────
//     // fallback: scheduledAt se banao
//     String dateStr = data['date'] as String? ?? '';
//     if (dateStr.isEmpty && scheduledAt != null) {
//       final now = DateTime.now();
//       final today = DateTime(now.year, now.month, now.day);
//       final tomorrow = today.add(const Duration(days: 1));
//       final classDay = DateTime(
//         scheduledAt.year,
//         scheduledAt.month,
//         scheduledAt.day,
//       );
//       if (classDay == today) {
//         dateStr = 'Today';
//       } else if (classDay == tomorrow) {
//         dateStr = 'Tomorrow';
//       } else {
//         const months = [
//           '',
//           'Jan',
//           'Feb',
//           'Mar',
//           'Apr',
//           'May',
//           'Jun',
//           'Jul',
//           'Aug',
//           'Sep',
//           'Oct',
//           'Nov',
//           'Dec',
//         ];
//         dateStr = '${scheduledAt.day} ${months[scheduledAt.month]}';
//       }
//     }

//     // ── time string: slotTime field directly lo ───────────────────────────────
//     // fallback: scheduledAt se banao
//     String timeStr = data['slotTime'] as String? ?? '';
//     if (timeStr.isEmpty && scheduledAt != null) {
//       final hour = scheduledAt.hour;
//       final minute = scheduledAt.minute.toString().padLeft(2, '0');
//       final period = hour >= 12 ? 'PM' : 'AM';
//       final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
//       timeStr = '$hour12:$minute $period';
//     }

//     return BookingModel(
//       id: doc.id,
//       studentName: data['studentName'] ?? '',
//       studentImage: data['studentImage'] ?? data['studentAvatarUrl'] ?? '',
//       date: dateStr,
//       time: timeStr,
//       subject: data['subject'] ?? '',
//       status: data['status'] ?? 'pending',
//       studentId: data['studentId'],
//       teacherId: data['teacherId'],
//       scheduledAt: scheduledAt,
//       durationMinutes: (data['durationMinutes'] as num?)?.toInt(),
//       meetingLink: data['meetingLink'],
//       studentRating: (data['studentRating'] as num?)?.toDouble(),
//       studentReview: data['studentReview'],
//     );
//   }

//   static Map<String, dynamic> toFirestoreMap({
//     required String teacherId,
//     required String studentId,
//     required String studentName,
//     required String studentImage,
//     required String subject,
//     required DateTime scheduledAt,
//     required String slotTime,
//     required String date,
//     int durationMinutes = 30,
//     String status = 'pending',
//   }) {
//     return {
//       'teacherId': teacherId,
//       'studentId': studentId,
//       'studentName': studentName,
//       'studentImage': studentImage,
//       'subject': subject,
//       'dateTime': Timestamp.fromDate(scheduledAt),
//       'slotTime': slotTime,
//       'date': date,
//       'durationMinutes': durationMinutes,
//       'status': status,
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//   }
// }
// lib/models/booking/booking_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@Freezed()
abstract class BookingModel with _$BookingModel {
  const BookingModel._();

  const factory BookingModel({
    required String id,
    required String studentName,
    required String studentImage,
    required String date,
    required String time, // Display time (viewer ke timezone mein)
    @Default('pending') String status,
    String? studentId,
    String? teacherId,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? meetingLink,
    double? studentRating,
    String? studentReview,
    // ── Timezone fields ──────────────────────────────────────────────────────
    @Default('') String teacherTimezone, // Teacher ka timezone
    @Default('') String studentTimezone, // Student ka timezone
    @Default('')
    String teacherSlotTime, // Teacher ke timezone mein original time
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // ── scheduledAt ──────────────────────────────────────────────────────────
    final DateTime? scheduledAt =
        (data['dateTime'] as Timestamp?)?.toDate() ??
        (data['scheduledAt'] as Timestamp?)?.toDate();

    // ── date string ──────────────────────────────────────────────────────────
    String dateStr = data['date'] as String? ?? '';
    if (dateStr.isEmpty && scheduledAt != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final classDay = DateTime(
        scheduledAt.year,
        scheduledAt.month,
        scheduledAt.day,
      );
      if (classDay == today) {
        dateStr = 'Today';
      } else if (classDay == tomorrow) {
        dateStr = 'Tomorrow';
      } else {
        const months = [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        dateStr = '${scheduledAt.day} ${months[scheduledAt.month]}';
      }
    }

    // ── time string ──────────────────────────────────────────────────────────
    // studentSlotTime: student ke timezone mein converted time (booking ke waqt save hota hai)
    // slotTime: teacher ka original time
    // Agar studentSlotTime available hai to use karo, warna slotTime
    String timeStr =
        data['studentSlotTime'] as String? ?? data['slotTime'] as String? ?? '';

    if (timeStr.isEmpty && scheduledAt != null) {
      final hour = scheduledAt.hour;
      final minute = scheduledAt.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      timeStr = '$hour12:$minute $period';
    }

    return BookingModel(
      id: doc.id,
      studentName: data['studentName'] ?? '',
      studentImage: data['studentImage'] ?? data['studentAvatarUrl'] ?? '',
      date: dateStr,
      time: timeStr,
      status: data['status'] ?? 'pending',
      studentId: data['studentId'],
      teacherId: data['teacherId'],
      scheduledAt: scheduledAt,
      durationMinutes: (data['durationMinutes'] as num?)?.toInt(),
      meetingLink: data['meetingLink'],
      studentRating: (data['studentRating'] as num?)?.toDouble(),
      studentReview: data['studentReview'],
      teacherTimezone: data['teacherTimezone'] as String? ?? '',
      studentTimezone: data['studentTimezone'] as String? ?? '',
      teacherSlotTime: data['slotTime'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toFirestoreMap({
    required String teacherId,
    required String studentId,
    required String studentName,
    required String studentImage,
    required DateTime scheduledAt,
    required String slotTime, // Teacher ka original time
    required String studentSlotTime, // Student ka converted time
    required String date,
    required String teacherTimezone,
    required String studentTimezone,
    int durationMinutes = 30,
    String status = 'pending',
  }) {
    return {
      'teacherId': teacherId,
      'studentId': studentId,
      'studentName': studentName,
      'studentImage': studentImage,
      'dateTime': Timestamp.fromDate(scheduledAt),
      'slotTime': slotTime,
      'studentSlotTime': studentSlotTime,
      'date': date,
      'durationMinutes': durationMinutes,
      'status': status,
      'teacherTimezone': teacherTimezone,
      'studentTimezone': studentTimezone,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
