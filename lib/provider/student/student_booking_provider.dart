import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

class StudentBookingState {
  final TeacherListModel? selectedTeacher;
  final String? selectedDate;
  final String? selectedDay; // Monday, Tuesday, etc.
  final SlotModel? selectedSlot;
  final List<SlotModel> availableSlots;
  final List<String> availableDates;
  final bool isBooking;
  final bool isBooked;
  final bool isLoadingSlots;

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
    );
  }

  bool get canBook =>
      selectedTeacher != null && selectedDate != null && selectedSlot != null;
}

class StudentBookingNotifier extends Notifier<StudentBookingState> {
  final _db = FirebaseFirestore.instance;

  @override
  StudentBookingState build() {
    return const StudentBookingState();
  }

  void initWithTeacher(TeacherListModel teacher) {
    // Generate next 7 days that the teacher is available
    final dates = <String>[];
    final now = DateTime.now();

    for (int i = 0; i < 14; i++) {
      final date = now.add(Duration(days: i));
      final dayName = _getDayName(date.weekday);

      // Check if teacher is available on this day
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
      selectedDay: dates.isNotEmpty
          ? _getDayName(now.add(Duration(days: 0)).weekday)
          : null,
    );

    if (dates.isNotEmpty) {
      _loadSlotsForDate(dates.first, teacher);
    }
  }

  void selectDate(String date) {
    final teacher = state.selectedTeacher;
    if (teacher == null) return;

    state = state.copyWith(selectedDate: date, clearSlot: true);
    _loadSlotsForDate(date, teacher);
  }

  /// Parse teacher's start/end time and generate 30-minute slots,
  /// then check Firestore for already-booked slots
  Future<void> _loadSlotsForDate(
    String date,
    TeacherListModel teacher,
  ) async {
    state = state.copyWith(isLoadingSlots: true);

    // Determine which day of the week this date is
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

    // Parse start and end times
    final startTime = _parseTime(dayAvail['startTime'] ?? '9:00 AM');
    final endTime = _parseTime(dayAvail['endTime'] ?? '5:00 PM');

    if (startTime == null || endTime == null) {
      state = state.copyWith(isLoadingSlots: false);
      return;
    }

    // Generate 30-minute slots
    final slots = <SlotModel>[];
    var current = startTime;
    int slotIndex = 0;

    while (_timeToMinutes(current) + 30 <= _timeToMinutes(endTime)) {
      final endSlot = _addMinutes(current, 30);
      final timeStr = '${_fmtTime(current)} - ${_fmtTime(endSlot)}';

      slots.add(SlotModel(
        id: 'slot_$slotIndex',
        time: timeStr,
        isAvailable: true,
        isSelected: false,
      ));

      current = endSlot;
      slotIndex++;
    }

    // Check which slots are already booked in Firestore
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

      // Mark booked slots as unavailable
      final updatedSlots = slots.map((slot) {
        if (bookedTimes.contains(slot.time)) {
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

  void selectSlot(SlotModel slot) {
    if (!slot.isAvailable) return;
    final updated = state.availableSlots.map((s) {
      return s.copyWith(isSelected: s.id == slot.id);
    }).toList();
    state = state.copyWith(availableSlots: updated, selectedSlot: slot);
  }

  /// Book the slot — save to Firestore
  Future<void> confirmBooking() async {
    if (!state.canBook) return;
    state = state.copyWith(isBooking: true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = FirebaseAuth.instance.currentUser!;
      final parsedDate = _parseDate(state.selectedDate!);
      final dateStr = parsedDate != null ? _dateToString(parsedDate) : state.selectedDate!;

      await _db.collection('bookings').add({
        'studentId': uid,
        'studentName': user.displayName ?? '',
        'teacherId': state.selectedTeacher!.id,
        'teacherName': state.selectedTeacher!.name,
        'date': dateStr,
        'slotTime': state.selectedSlot!.time,
        'day': state.selectedDay ?? '',
        'subject': 'Quran',
        'status': 'confirmed',
        'dateTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Reload slots to show the booked slot as unavailable
      if (state.selectedTeacher != null && state.selectedDate != null) {
        await _loadSlotsForDate(state.selectedDate!, state.selectedTeacher!);
      }

      state = state.copyWith(isBooking: false, isBooked: true);
    } catch (_) {
      state = state.copyWith(isBooking: false);
    }
  }

  void reset() {
    state = const StudentBookingState();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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
    // Parse "Today, 6 May" or "Mon, 7 May" format
    final now = DateTime.now();
    try {
      final parts = dateStr.split(', ');
      if (parts.length < 2) return null;

      final datePart = parts[1]; // "6 May"
      final dayMonth = datePart.split(' ');
      if (dayMonth.length < 2) return null;

      final day = int.parse(dayMonth[0]);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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
    // Parse "9:00 AM" or "5:00 PM"
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

  int _timeToMinutes(Map<String, int> time) {
    return time['hour']! * 60 + time['minute']!;
  }

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
