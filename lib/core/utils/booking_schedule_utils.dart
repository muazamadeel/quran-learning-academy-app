import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore booking doc → class start time (best effort).
DateTime? parseBookingScheduledAt(Map<String, dynamic> d) {
  final dt = d['dateTime'];
  if (dt is Timestamp) return dt.toDate();
  final sch = d['scheduledAt'];
  if (sch is Timestamp) return sch.toDate();
  if (dt is String) {
    final p = DateTime.tryParse(dt);
    if (p != null) return p;
  }

  final dateStr = d['date'] as String?;
  final slot = () {
    final st = d['studentSlotTime'] as String?;
    if (st != null && st.trim().isNotEmpty) return st.trim();
    return (d['slotTime'] as String?)?.trim();
  }();
  if (dateStr == null || slot == null || slot.isEmpty) return null;

  final day = _parseBookingDateOnly(dateStr);
  final hm = _parseFirstTimeFromSlot(slot);
  if (day == null || hm == null) return null;
  return DateTime(day.year, day.month, day.day, hm['h']!, hm['m']!);
}

/// Same “upcoming list” rule as schedule: by calendar day when [date] parses as ISO;
/// otherwise fall back to [dateTime] within grace window; else include.
bool isStudentUpcomingBookingDoc(Map<String, dynamic> d, DateTime now) {
  final dateStr = d['date'] as String?;
  if (dateStr == null) {
    final scheduled = parseBookingScheduledAt(d);
    if (scheduled != null) {
      return scheduled.isAfter(now.subtract(const Duration(minutes: 30)));
    }
    return true;
  }
  final classDate = DateTime.tryParse(dateStr);
  if (classDate == null) return true;
  final todayOnly = DateTime(now.year, now.month, now.day);
  final classDayOnly = DateTime(
    classDate.year,
    classDate.month,
    classDate.day,
  );
  return !classDayOnly.isBefore(todayOnly);
}

DateTime? _parseBookingDateOnly(String dateStr) {
  final iso = DateTime.tryParse(dateStr);
  if (iso != null) return iso;
  return null;
}

/// First side of "9:00 AM - 9:30 AM" → hour/minute 24h.
Map<String, int>? _parseFirstTimeFromSlot(String slot) {
  try {
    final first = slot.split(' - ').first.trim();
    final parts = first.split(' ');
    if (parts.length < 2) return null;
    final hm = parts[0].split(':');
    var hour = int.parse(hm[0]);
    final minute = int.parse(hm[1]);
    final period = parts[1].toUpperCase();
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return {'h': hour, 'm': minute};
  } catch (_) {
    return null;
  }
}

/// GoRouter extra map → DateTime for classroom (no network).
DateTime parseClassroomExtraScheduledAt(Map<String, dynamic> e) {
  final v = e['scheduledAt'];
  if (v is DateTime) return v;
  if (v is Timestamp) return v.toDate();
  if (v is String) {
    final p = DateTime.tryParse(v);
    if (p != null) return p;
  }
  final merged = Map<String, dynamic>.from(e);
  final parsed = parseBookingScheduledAt(merged);
  if (parsed != null) return parsed;
  return DateTime.now();
}
