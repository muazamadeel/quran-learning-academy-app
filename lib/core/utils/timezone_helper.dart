class TimezoneHelper {
  static const Map<String, int> _tzOffsets = {
    'Asia/Karachi (PKT, UTC+5)': 300,
    'Asia/Riyadh (AST, UTC+3)': 180,
    'Asia/Dubai (GST, UTC+4)': 240,
    'Europe/London (GMT/BST, UTC+0/+1)': 0,
    'America/New_York (EST, UTC-5)': -300,
    'America/Chicago (CST, UTC-6)': -360,
    'America/Denver (MST, UTC-7)': -420,
    'America/Los_Angeles (PST, UTC-8)': -480,
    'America/Toronto (EST, UTC-5)': -300,
    'America/Vancouver (PST, UTC-8)': -480,
    'America/Edmonton (MST, UTC-7)': -420,
    'Asia/Kolkata (IST, UTC+5:30)': 330,
    'Asia/Dhaka (BST, UTC+6)': 360,
    'Asia/Kuala_Lumpur (MYT, UTC+8)': 480,
    'Europe/Istanbul (TRT, UTC+3)': 180,
    'Africa/Cairo (EET, UTC+2)': 120,
    'Australia/Sydney (AEST, UTC+10)': 600,
    'Australia/Perth (AWST, UTC+8)': 480,
    'Europe/Berlin (CET, UTC+1)': 60,
    'Europe/Paris (CET, UTC+1)': 60,
    'Africa/Johannesburg (SAST, UTC+2)': 120,
    'Asia/Jakarta (WIB, UTC+7)': 420,
    'Asia/Makassar (WITA, UTC+8)': 480,
    'Africa/Lagos (WAT, UTC+1)': 60,
    'Asia/Qatar (AST, UTC+3)': 180,
    'Asia/Kuwait (AST, UTC+3)': 180,
    'Asia/Muscat (GST, UTC+4)': 240,
    'Asia/Bahrain (AST, UTC+3)': 180,
    'Asia/Amman (EET, UTC+2)': 120,
    'Africa/Casablanca (WET, UTC+0/+1)': 0,
  };

  /// Timezone string se offset minutes nikalta hai
  /// e.g. "Asia/Karachi (PKT, UTC+5)" → 300
  static int getOffsetMinutes(String timezone) {
    return _tzOffsets[timezone] ?? 0;
  }

  /// Time string ko ek timezone se doosre mein convert karta hai
  ///
  /// [timeStr] : "9:00 AM" ya "9:00 AM - 9:30 AM" format
  /// [fromTz]  : source timezone string (teacher ka)
  /// [toTz]    : target timezone string (student ka)
  ///
  /// Returns converted time string same format mein
  static String convertTime({
    required String timeStr,
    required String fromTz,
    required String toTz,
  }) {
    // Same timezone — kuch nahi karna
    if (fromTz == toTz) return timeStr;

    // Range slot check: "9:00 AM - 9:30 AM"
    if (timeStr.contains(' - ')) {
      final parts = timeStr.split(' - ');
      final start = _convertSingleTime(parts[0].trim(), fromTz, toTz);
      final end = _convertSingleTime(parts[1].trim(), fromTz, toTz);
      return '$start - $end';
    }

    return _convertSingleTime(timeStr, fromTz, toTz);
  }

  /// Single time string convert karta hai: "9:00 AM" → converted string
  static String _convertSingleTime(String timeStr, String fromTz, String toTz) {
    final minutes = _parseToMinutes(timeStr);
    if (minutes == null) return timeStr;

    final fromOffset = getOffsetMinutes(fromTz);
    final toOffset = getOffsetMinutes(toTz);

    // UTC mein convert karo, phir target timezone mein
    int utcMinutes = minutes - fromOffset;
    int localMinutes = utcMinutes + toOffset;

    // 24-hour wrap handle karo
    localMinutes = localMinutes % (24 * 60);
    if (localMinutes < 0) localMinutes += 24 * 60;

    return _minutesToTimeStr(localMinutes);
  }

  /// "9:00 AM" → total minutes from midnight
  static int? _parseToMinutes(String timeStr) {
    try {
      final clean = timeStr.trim();
      final parts = clean.split(' ');
      if (parts.length < 2) return null;

      final hm = parts[0].split(':');
      var hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      final period = parts[1].toUpperCase();

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return hour * 60 + minute;
    } catch (_) {
      return null;
    }
  }

  /// Total minutes → "9:00 AM" format
  static String _minutesToTimeStr(int totalMinutes) {
    final hour24 = (totalMinutes ~/ 60) % 24;
    final minute = totalMinutes % 60;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    var hour12 = hour24 % 12;
    if (hour12 == 0) hour12 = 12;
    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Timezone string se short label nikalta hai UI ke liye
  /// e.g. "Asia/Karachi (PKT, UTC+5)" → "PKT"
  static String getShortLabel(String timezone) {
    try {
      final start = timezone.indexOf('(') + 1;
      final end = timezone.indexOf(',');
      if (start > 0 && end > start) {
        return timezone.substring(start, end).trim();
      }
    } catch (_) {}
    return timezone.split('/').last.split(' ').first;
  }

  /// UTC offset string nikalta hai
  /// e.g. "Asia/Karachi (PKT, UTC+5)" → "UTC+5"
  static String getUtcLabel(String timezone) {
    try {
      final start = timezone.lastIndexOf('UTC');
      final end = timezone.lastIndexOf(')');
      if (start >= 0 && end > start) {
        return timezone.substring(start, end).trim();
      }
    } catch (_) {}
    return '';
  }
}
