import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';

class TeacherAvailabilityScreen extends ConsumerStatefulWidget {
  const TeacherAvailabilityScreen({super.key});

  @override
  ConsumerState<TeacherAvailabilityScreen> createState() =>
      _TeacherAvailabilityScreenState();
}

class _TeacherAvailabilityScreenState
    extends ConsumerState<TeacherAvailabilityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  String _selectedCountry = 'Pakistan';
  String _selectedTimezone = 'Asia/Karachi (PKT, UTC+5)';
  bool _isSubmitting = false;

  // Removed course selection list here

  // ── Country → Timezone map ──────────────────────────────────────────────
  static const Map<String, List<String>> _countryTimezones = {
    'Pakistan': ['Asia/Karachi (PKT, UTC+5)'],
    'Saudi Arabia': ['Asia/Riyadh (AST, UTC+3)'],
    'United Arab Emirates': ['Asia/Dubai (GST, UTC+4)'],
    'United Kingdom': ['Europe/London (GMT/BST, UTC+0/+1)'],
    'United States': [
      'America/New_York (EST, UTC-5)',
      'America/Chicago (CST, UTC-6)',
      'America/Denver (MST, UTC-7)',
      'America/Los_Angeles (PST, UTC-8)',
    ],
    'Canada': [
      'America/Toronto (EST, UTC-5)',
      'America/Vancouver (PST, UTC-8)',
      'America/Edmonton (MST, UTC-7)',
    ],
    'India': ['Asia/Kolkata (IST, UTC+5:30)'],
    'Bangladesh': ['Asia/Dhaka (BST, UTC+6)'],
    'Malaysia': ['Asia/Kuala_Lumpur (MYT, UTC+8)'],
    'Turkey': ['Europe/Istanbul (TRT, UTC+3)'],
    'Egypt': ['Africa/Cairo (EET, UTC+2)'],
    'Australia': [
      'Australia/Sydney (AEST, UTC+10)',
      'Australia/Perth (AWST, UTC+8)',
    ],
    'Germany': ['Europe/Berlin (CET, UTC+1)'],
    'France': ['Europe/Paris (CET, UTC+1)'],
    'South Africa': ['Africa/Johannesburg (SAST, UTC+2)'],
    'Indonesia': [
      'Asia/Jakarta (WIB, UTC+7)',
      'Asia/Makassar (WITA, UTC+8)',
    ],
    'Nigeria': ['Africa/Lagos (WAT, UTC+1)'],
    'Qatar': ['Asia/Qatar (AST, UTC+3)'],
    'Kuwait': ['Asia/Kuwait (AST, UTC+3)'],
    'Oman': ['Asia/Muscat (GST, UTC+4)'],
    'Bahrain': ['Asia/Bahrain (AST, UTC+3)'],
    'Jordan': ['Asia/Amman (EET, UTC+2)'],
    'Morocco': ['Africa/Casablanca (WET, UTC+0/+1)'],
  };

  // ── Weekly availability ─────────────────────────────────────────────────
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late Map<String, _DaySlot> _slots;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _slots = {
      for (var d in _days)
        d: _DaySlot(
          enabled: d != 'Friday' && d != 'Sunday',
          start: const TimeOfDay(hour: 9, minute: 0),
          end: const TimeOfDay(hour: 17, minute: 0),
        ),
    };
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Pick time helper ────────────────────────────────────────────────────
  Future<void> _pickTime(String day, bool isStart) async {
    final slot = _slots[day]!;
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? slot.start : slot.end,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryGreen,
            onSurface: AppColors.textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _slots[day] = slot.copyWith(start: picked);
        } else {
          _slots[day] = slot.copyWith(end: picked);
        }
      });
    }
  }

  // ── Format time ─────────────────────────────────────────────────────────
  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  // ── Submit ──────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    // Check at least one day is enabled
    final hasDay = _slots.values.any((s) => s.enabled);
    if (!hasDay) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable at least one day'),
          backgroundColor: AppColors.rejected,
        ),
      );
      return;
    }

    // Removed course check here

    setState(() => _isSubmitting = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Build availability map (only include enabled days)
      final availability = <String, dynamic>{};
      for (final entry in _slots.entries) {
        if (entry.value.enabled) {
          availability[entry.key] = {
            'enabled': entry.value.enabled,
            'startTime': _fmt(entry.value.start),
            'endTime': _fmt(entry.value.end),
          };
        }
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'country': _selectedCountry,
        'timezone': _selectedTimezone,
        'availability': availability,
        'isApproved': false,
      });

      if (mounted) {
        context.go(AppRoutes.approvalPending);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.rejected,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── BUILD ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + h * 0.02,
              bottom: h * 0.025,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkGreen, AppColors.primaryGreen],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: w * 0.14,
                  height: w * 0.14,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    size: w * 0.07,
                    color: AppColors.lightGold,
                  ),
                ),
                SizedBox(height: h * 0.01),
                Text(
                  'Set Your Availability',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: w * 0.048,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: h * 0.004),
                Text(
                  'Tell us when you can teach',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: w * 0.032,
                  ),
                ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _animCtrl,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Country ──────────────────────────────────
                    _sectionTitle('Country', Icons.public, w),
                    SizedBox(height: h * 0.008),
                    _dropdownCard(
                      value: _selectedCountry,
                      items: _countryTimezones.keys.toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedCountry = v!;
                          _selectedTimezone =
                              _countryTimezones[v]!.first;
                        });
                      },
                      w: w,
                    ),
                    SizedBox(height: h * 0.018),

                    // ── Timezone ─────────────────────────────────
                    _sectionTitle('Timezone', Icons.access_time_rounded, w),
                    SizedBox(height: h * 0.008),
                    _dropdownCard(
                      value: _selectedTimezone,
                      items: _countryTimezones[_selectedCountry]!,
                      onChanged: (v) =>
                          setState(() => _selectedTimezone = v!),
                      w: w,
                    ),
                    SizedBox(height: h * 0.025),

                    // Courses to Teach removed

                    // ── Weekly Schedule ──────────────────────────
                    _sectionTitle(
                        'Weekly Schedule', Icons.calendar_month_rounded, w),
                    SizedBox(height: h * 0.005),
                    Text(
                      'Toggle days on/off and set your teaching hours',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: w * 0.03,
                      ),
                    ),
                    SizedBox(height: h * 0.012),

                    ...List.generate(_days.length, (i) {
                      final day = _days[i];
                      final slot = _slots[day]!;
                      return _dayCard(day, slot, w, h, i);
                    }),

                    SizedBox(height: h * 0.025),

                    // ── Submit ───────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.065,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: w * 0.05),
                                  SizedBox(width: w * 0.02),
                                  Text(
                                    'Submit for Approval',
                                    style: TextStyle(
                                      fontSize: w * 0.042,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Course chips widget removed

  // ── Section title ───────────────────────────────────────────────────────
  Widget _sectionTitle(String text, IconData icon, double w) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: w * 0.05),
        SizedBox(width: w * 0.02),
        Text(
          text,
          style: TextStyle(
            fontSize: w * 0.04,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  // ── Dropdown card ───────────────────────────────────────────────────────
  Widget _dropdownCard({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double w,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.005),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon:
              Icon(Icons.arrow_drop_down, color: AppColors.primaryGreen, size: w * 0.06),
          style: TextStyle(
            fontSize: w * 0.035,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── Day card ────────────────────────────────────────────────────────────
  Widget _dayCard(
      String day, _DaySlot slot, double w, double h, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (_, val, child) => Opacity(
        opacity: val,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - val)),
          child: child,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.01),
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: w * 0.03,
        ),
        decoration: BoxDecoration(
          color: slot.enabled
              ? AppColors.white
              : AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: slot.enabled
                ? AppColors.primaryGreen.withValues(alpha: 0.3)
                : AppColors.textLight.withValues(alpha: 0.5),
          ),
          boxShadow: slot.enabled
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Day name + toggle
            Row(
              children: [
                Container(
                  width: w * 0.09,
                  height: w * 0.09,
                  decoration: BoxDecoration(
                    color: slot.enabled
                        ? AppColors.primaryGreen.withValues(alpha: 0.1)
                        : AppColors.textLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      day.substring(0, 3).toUpperCase(),
                      style: TextStyle(
                        fontSize: w * 0.028,
                        fontWeight: FontWeight.w800,
                        color: slot.enabled
                            ? AppColors.primaryGreen
                            : AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w600,
                      color: slot.enabled
                          ? AppColors.textDark
                          : AppColors.textGrey,
                    ),
                  ),
                ),
                // Available / Unavailable label
                Text(
                  slot.enabled ? 'Available' : 'Off',
                  style: TextStyle(
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w600,
                    color: slot.enabled
                        ? AppColors.success
                        : AppColors.textGrey,
                  ),
                ),
                SizedBox(width: w * 0.015),
                Switch.adaptive(
                  value: slot.enabled,
                  activeTrackColor: AppColors.primaryGreen,
                  onChanged: (v) => setState(
                    () => _slots[day] = slot.copyWith(enabled: v),
                  ),
                ),
              ],
            ),

            // Time row (only when enabled)
            if (slot.enabled) ...[
              SizedBox(height: h * 0.008),
              Row(
                children: [
                  SizedBox(width: w * 0.12),
                  _timeChip(
                    label: 'Start',
                    time: _fmt(slot.start),
                    icon: Icons.play_arrow_rounded,
                    w: w,
                    onTap: () => _pickTime(day, true),
                  ),
                  SizedBox(width: w * 0.03),
                  Icon(Icons.arrow_forward,
                      size: w * 0.04, color: AppColors.textGrey),
                  SizedBox(width: w * 0.03),
                  _timeChip(
                    label: 'End',
                    time: _fmt(slot.end),
                    icon: Icons.stop_rounded,
                    w: w,
                    onTap: () => _pickTime(day, false),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Time chip ───────────────────────────────────────────────────────────
  Widget _timeChip({
    required String label,
    required String time,
    required IconData icon,
    required double w,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.025,
            vertical: w * 0.02,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primaryGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: w * 0.035, color: AppColors.primaryGreen),
              SizedBox(width: w * 0.015),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: w * 0.024,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper class for day slot ─────────────────────────────────────────────
class _DaySlot {
  final bool enabled;
  final TimeOfDay start;
  final TimeOfDay end;

  const _DaySlot({
    required this.enabled,
    required this.start,
    required this.end,
  });

  _DaySlot copyWith({
    bool? enabled,
    TimeOfDay? start,
    TimeOfDay? end,
  }) {
    return _DaySlot(
      enabled: enabled ?? this.enabled,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}

