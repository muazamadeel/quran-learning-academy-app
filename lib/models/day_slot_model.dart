import 'package:flutter/material.dart';

class DaySlot {
  final bool enabled;
  final TimeOfDay start;
  final TimeOfDay end;

  const DaySlot({
    required this.enabled,
    required this.start,
    required this.end,
  });

  DaySlot copyWith({bool? enabled, TimeOfDay? start, TimeOfDay? end}) {
    return DaySlot(
      enabled: enabled ?? this.enabled,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  /// "9:00 AM" format se TimeOfDay parse karta hai
  static TimeOfDay parseTime(String s) {
    try {
      final parts = s.trim().split(' ');
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  /// TimeOfDay ko "9:00 AM" format mein convert karta hai
  static String formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }
}
