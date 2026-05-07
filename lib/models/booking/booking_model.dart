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
//     @Default('pending') String status, // pending | confirmed | completed
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
//     final scheduledAt = (data['scheduledAt'] as Timestamp?)?.toDate();

//     String dateStr = '';
//     String timeStr = '';
//     if (scheduledAt != null) {
//       final now = DateTime.now();
//       final today = DateTime(now.year, now.month, now.day);
//       final tomorrow = today.add(const Duration(days: 1));
//       final classDay = DateTime(
//           scheduledAt.year, scheduledAt.month, scheduledAt.day);

//       if (classDay == today) {
//         dateStr = 'Today';
//       } else if (classDay == tomorrow) {
//         dateStr = 'Tomorrow';
//       } else {
//         final months = [
//           '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//         ];
//         dateStr = '${scheduledAt.day} ${months[scheduledAt.month]}';
//       }

//       final hour = scheduledAt.hour;
//       final minute = scheduledAt.minute.toString().padLeft(2, '0');
//       final period = hour >= 12 ? 'PM' : 'AM';
//       final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
//       timeStr = '$hour12:$minute $period';
//     }

//     return BookingModel(
//       id: doc.id,
//       studentName: data['studentName'] ?? '',
//       studentImage: data['studentImage'] ?? '',
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
//     int durationMinutes = 45,
//     String status = 'pending',
//   }) {
//     return {
//       'teacherId': teacherId,
//       'studentId': studentId,
//       'studentName': studentName,
//       'studentImage': studentImage,
//       'subject': subject,
//       'scheduledAt': Timestamp.fromDate(scheduledAt),
//       'durationMinutes': durationMinutes,
//       'status': status,
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//   }
// }
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
    required String time,
    required String subject,
    @Default('pending') String status,
    String? studentId,
    String? teacherId,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? meetingLink,
    double? studentRating,
    String? studentReview,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // ── scheduledAt: dateTime field use karo ─────────────────────────────────
    final DateTime? scheduledAt =
        (data['dateTime'] as Timestamp?)?.toDate() ??
        (data['scheduledAt'] as Timestamp?)?.toDate();

    // ── date string: Firestore ka 'date' field directly lo ───────────────────
    // fallback: scheduledAt se banao
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

    // ── time string: slotTime field directly lo ───────────────────────────────
    // fallback: scheduledAt se banao
    String timeStr = data['slotTime'] as String? ?? '';
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
      subject: data['subject'] ?? '',
      status: data['status'] ?? 'pending',
      studentId: data['studentId'],
      teacherId: data['teacherId'],
      scheduledAt: scheduledAt,
      durationMinutes: (data['durationMinutes'] as num?)?.toInt(),
      meetingLink: data['meetingLink'],
      studentRating: (data['studentRating'] as num?)?.toDouble(),
      studentReview: data['studentReview'],
    );
  }

  static Map<String, dynamic> toFirestoreMap({
    required String teacherId,
    required String studentId,
    required String studentName,
    required String studentImage,
    required String subject,
    required DateTime scheduledAt,
    required String slotTime,
    required String date,
    int durationMinutes = 30,
    String status = 'pending',
  }) {
    return {
      'teacherId': teacherId,
      'studentId': studentId,
      'studentName': studentName,
      'studentImage': studentImage,
      'subject': subject,
      'dateTime': Timestamp.fromDate(scheduledAt),
      'slotTime': slotTime,
      'date': date,
      'durationMinutes': durationMinutes,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
