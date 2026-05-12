import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/service/notification_service.dart';
import 'package:quran_learning_app/core/utils/timezone_helper.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
import 'package:quran_learning_app/provider/chat_provider.dart';

class StudentBookingState {
  final TeacherListModel? selectedTeacher;
  final String? selectedDate;
  final String? selectedDay;
  final SlotModel? selectedSlot;
  final List<SlotModel> availableSlots;
  final List<String> availableDates;
  final bool isBooking;
  final bool isBooked;
  final bool isLoadingSlots;

  // ── Timezone info ──────────────────────────────────────────────────────────
  final String studentTimezone;
  final String teacherTimezone;
  final String studentName;
  final String studentImage;

  const StudentBookingState({
    this.selectedTeacher,
    this.selectedDate,
    this.selectedDay,
    this.selectedSlot,
    this.availableSlots = const [],
    this.availableDates = const [],
    this.isBooking = false,
    this.isBooked = false,
    this.isLoadingSlots = false,
    this.studentTimezone = '',
    this.teacherTimezone = '',
    this.studentName = '',
    this.studentImage = '',
  });

  StudentBookingState copyWith({
    TeacherListModel? selectedTeacher,
    String? selectedDate,
    String? selectedDay,
    SlotModel? selectedSlot,
    List<SlotModel>? availableSlots,
    List<String>? availableDates,
    bool? isBooking,
    bool? isBooked,
    bool? isLoadingSlots,
    bool clearSlot = false,
    String? studentTimezone,
    String? teacherTimezone,
    String? studentName,
    String? studentImage,
  }) {
    return StudentBookingState(
      selectedTeacher: selectedTeacher ?? this.selectedTeacher,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedSlot: clearSlot ? null : (selectedSlot ?? this.selectedSlot),
      availableSlots: availableSlots ?? this.availableSlots,
      availableDates: availableDates ?? this.availableDates,
      isBooking: isBooking ?? this.isBooking,
      isBooked: isBooked ?? this.isBooked,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      studentTimezone: studentTimezone ?? this.studentTimezone,
      teacherTimezone: teacherTimezone ?? this.teacherTimezone,
      studentName: studentName ?? this.studentName,
      studentImage: studentImage ?? this.studentImage,
    );
  }

  bool get canBook =>
      selectedTeacher != null && selectedDate != null && selectedSlot != null;
}

class StudentBookingNotifier extends Notifier<StudentBookingState> {
  final _db = FirebaseFirestore.instance;

  @override
  StudentBookingState build() => const StudentBookingState();

  // ── Init ───────────────────────────────────────────────────────────────────
  // Teacher select hone par: student ka timezone fetch karo, dates generate karo
  Future<void> initWithTeacher(TeacherListModel teacher) async {
    // Student ka timezone Firestore se fetch karo
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    String studentTz = '';
    String studentName = '';
    String studentImg = '';
    String teacherTz = teacher.timezone;

    if (uid.isNotEmpty) {
      try {
        final doc = await _db.collection('users').doc(uid).get();
        final d = doc.data();
        studentTz = d?['timezone'] as String? ?? '';
        studentName = d?['name'] as String? ?? '';
        studentImg = d?['profileImage'] as String? ?? '';
      } catch (_) {}
    }

    // Next 7 available dates generate karo
    final dates = <String>[];
    final now = DateTime.now();

    for (int i = 0; i < 14; i++) {
      final date = now.add(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      final dayAvail = teacher.availability[dayName];
      if (dayAvail != null && dayAvail['enabled'] == true) {
        dates.add(_formatDate(date));
        if (dates.length >= 7) break;
      }
    }

    state = state.copyWith(
      selectedTeacher: teacher,
      availableDates: dates,
      selectedDate: dates.isNotEmpty ? dates.first : null,
      selectedDay: dates.isNotEmpty ? _getDayName(now.weekday) : null,
      studentTimezone: studentTz,
      teacherTimezone: teacherTz,
      studentName: studentName,
      studentImage: studentImg,
    );

    if (dates.isNotEmpty) {
      await _loadSlotsForDate(dates.first, teacher);
    }
  }

  void selectDate(String date) {
    final teacher = state.selectedTeacher;
    if (teacher == null) return;
    state = state.copyWith(selectedDate: date, clearSlot: true);
    _loadSlotsForDate(date, teacher);
  }

  // ── Load slots ─────────────────────────────────────────────────────────────
  // Teacher ke times generate karo, phir student ke timezone mein convert karo
  Future<void> _loadSlotsForDate(String date, TeacherListModel teacher) async {
    state = state.copyWith(isLoadingSlots: true);

    final parsedDate = _parseDate(date);
    if (parsedDate == null) {
      state = state.copyWith(isLoadingSlots: false);
      return;
    }

    final dayName = _getDayName(parsedDate.weekday);
    final dayAvail = teacher.availability[dayName];

    if (dayAvail == null || dayAvail['enabled'] != true) {
      state = state.copyWith(
        availableSlots: [],
        isLoadingSlots: false,
        selectedDay: dayName,
      );
      return;
    }

    // Teacher ka start/end time (teacher ke timezone mein)
    final startTime = _parseTime(dayAvail['startTime'] ?? '9:00 AM');
    final endTime = _parseTime(dayAvail['endTime'] ?? '5:00 PM');

    if (startTime == null || endTime == null) {
      state = state.copyWith(isLoadingSlots: false);
      return;
    }

    // 30-minute slots generate karo (teacher ke timezone mein)
    final slots = <SlotModel>[];
    var current = startTime;
    int slotIndex = 0;

    while (_timeToMinutes(current) + 30 <= _timeToMinutes(endTime)) {
      final endSlot = _addMinutes(current, 30);

      // Teacher ke timezone mein original time (Firestore save ke liye)
      final teacherTimeStr = '${_fmtTime(current)} - ${_fmtTime(endSlot)}';

      // ── Timezone conversion ──────────────────────────────────────────────
      // Student ko apne timezone mein dikhao
      final displayTime = _convertSlotTime(teacherTimeStr);

      slots.add(
        SlotModel(
          id: 'slot_$slotIndex',
          time: displayTime, // Student ko dikhne wala time
          teacherTime:
              teacherTimeStr, // Firestore mein save hone wala teacher time
          isAvailable: true,
          isSelected: false,
        ),
      );

      current = endSlot;
      slotIndex++;
    }

    // Firestore se already booked slots check karo
    try {
      final dateStr = _dateToString(parsedDate);
      final bookedSnap = await _db
          .collection('bookings')
          .where('teacherId', isEqualTo: teacher.id)
          .where('date', isEqualTo: dateStr)
          .get();

      final bookedTimes = bookedSnap.docs
          .map((doc) => doc.data()['slotTime'] as String?)
          .whereType<String>()
          .toSet();

      // bookedTimes mein teacher ka time hoga — match teacher time se karo
      final updatedSlots = slots.map((slot) {
        if (bookedTimes.contains(slot.teacherTime)) {
          return slot.copyWith(isAvailable: false);
        }
        return slot;
      }).toList();

      state = state.copyWith(
        availableSlots: updatedSlots,
        isLoadingSlots: false,
        selectedDay: dayName,
      );
    } catch (_) {
      state = state.copyWith(
        availableSlots: slots,
        isLoadingSlots: false,
        selectedDay: dayName,
      );
    }
  }

  /// Teacher time → Student time convert karta hai
  /// Agar koi timezone nahi mila to original time return karta hai
  String _convertSlotTime(String teacherTimeStr) {
    final teacherTz = state.teacherTimezone;
    final studentTz = state.studentTimezone;

    if (teacherTz.isEmpty || studentTz.isEmpty || teacherTz == studentTz) {
      return teacherTimeStr;
    }

    return TimezoneHelper.convertTime(
      timeStr: teacherTimeStr,
      fromTz: teacherTz,
      toTz: studentTz,
    );
  }

  void selectSlot(SlotModel slot) {
    if (!slot.isAvailable) return;
    final updated = state.availableSlots.map((s) {
      return s.copyWith(isSelected: s.id == slot.id);
    }).toList();
    state = state.copyWith(availableSlots: updated, selectedSlot: slot);
  }

  // ── Confirm booking ────────────────────────────────────────────────────────
  // Firestore mein teacher ka original time save karo (student ka converted nahi)
  Future<void> confirmBooking() async {
    if (!state.canBook) return;
    final teacher = state.selectedTeacher!;
    state = state.copyWith(isBooking: true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // ── Create Chat Room ───────────────────────────────────────────────
      await ref
          .read(chatActionsProvider.notifier)
          .createOrGetRoom(
            teacherId: teacher.id,
            teacherName: teacher.name,
            teacherImage: teacher.profileImage, // Ensure this exists in model
            studentId: uid,
            studentName: state.studentName,
            studentImage: state.studentImage,
          );

      final parsedDate = _parseDate(state.selectedDate!);
      final dateStr = parsedDate != null
          ? _dateToString(parsedDate)
          : state.selectedDate!;

      // Teacher ka original time save karo (not converted)
      final teacherTime = state.selectedSlot!.teacherTime.isNotEmpty
          ? state.selectedSlot!.teacherTime
          : state.selectedSlot!.time;

      // Calculate actual scheduled DateTime
      final slotStartTime = state.selectedSlot!.time.split(' - ')[0];
      final slotTimeParts = _parseTime(slotStartTime);
      DateTime? scheduledDateTime;
      if (parsedDate != null && slotTimeParts != null) {
        scheduledDateTime = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          slotTimeParts['hour']!,
          slotTimeParts['minute']!,
        );
      }

      final bookingRef = await _db.collection('bookings').add({
        'studentId': uid,
        'studentName': state.studentName,
        'teacherId': teacher.id,
        'teacherName': teacher.name,
        'participants': [uid, teacher.id],
        'date': dateStr,
        'slotTime': teacherTime,
        'studentSlotTime': state.selectedSlot!.time,
        'day': state.selectedDay ?? '',
        'status': 'confirmed',
        'teacherTimezone': state.teacherTimezone,
        'studentTimezone': state.studentTimezone,
        'dateTime': scheduledDateTime != null
            ? Timestamp.fromDate(scheduledDateTime)
            : FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ── Schedule Notification ──────────────────────────────────────────
      if (scheduledDateTime != null) {
        await NotificationService.scheduleClassReminder(
          notificationId: bookingRef.id.hashCode,
          channelName: teacher.name,
          classTime: scheduledDateTime,
          isTeacher: false,
        );
      }

      if (state.selectedTeacher != null && state.selectedDate != null) {
        await _loadSlotsForDate(state.selectedDate!, state.selectedTeacher!);
      }

      state = state.copyWith(isBooking: false, isBooked: true);
    } catch (_) {
      state = state.copyWith(isBooking: false);
    }
  }

  void reset() => state = const StudentBookingState();

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  String _formatDate(DateTime dt) {
    const months = [
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
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final diff = dt.difference(DateTime(now.year, now.month, now.day)).inDays;

    String prefix;
    if (diff == 0) {
      prefix = 'Today';
    } else if (diff == 1) {
      prefix = 'Tomorrow';
    } else {
      prefix = days[dt.weekday - 1];
    }
    return '$prefix, ${dt.day} ${months[dt.month - 1]}';
  }

  DateTime? _parseDate(String dateStr) {
    final now = DateTime.now();
    try {
      final parts = dateStr.split(', ');
      if (parts.length < 2) return null;
      final datePart = parts[1];
      final dayMonth = datePart.split(' ');
      if (dayMonth.length < 2) return null;
      final day = int.parse(dayMonth[0]);
      const months = [
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
      final month = months.indexOf(dayMonth[1]) + 1;
      if (month == 0) return null;
      return DateTime(now.year, month, day);
    } catch (_) {
      return null;
    }
  }

  String _dateToString(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Map<String, int>? _parseTime(String timeStr) {
    try {
      final clean = timeStr.trim();
      final parts = clean.split(' ');
      if (parts.length < 2) return null;
      final timeParts = parts[0].split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = parts[1].toUpperCase();
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      return {'hour': hour, 'minute': minute};
    } catch (_) {
      return null;
    }
  }

  int _timeToMinutes(Map<String, int> time) =>
      time['hour']! * 60 + time['minute']!;

  Map<String, int> _addMinutes(Map<String, int> time, int minutes) {
    final total = _timeToMinutes(time) + minutes;
    return {'hour': total ~/ 60, 'minute': total % 60};
  }

  String _fmtTime(Map<String, int> time) {
    var h = time['hour']!;
    final m = time['minute']!;
    final p = h >= 12 ? 'PM' : 'AM';
    if (h > 12) h -= 12;
    if (h == 0) h = 12;
    return '$h:${m.toString().padLeft(2, '0')} $p';
  }
}

final studentBookingProvider =
    NotifierProvider<StudentBookingNotifier, StudentBookingState>(
      StudentBookingNotifier.new,
    );
