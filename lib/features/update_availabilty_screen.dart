import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/day_slot_model.dart';
import 'package:quran_learning_app/provider/availability_provider.dart';
import 'package:quran_learning_app/features/teacher/widget/teacher_bottom_nav.dart';

class UpdateAvailabilityScreen extends ConsumerStatefulWidget {
  const UpdateAvailabilityScreen({super.key});

  @override
  ConsumerState<UpdateAvailabilityScreen> createState() =>
      _UpdateAvailabilityScreenState();
}

class _UpdateAvailabilityScreenState
    extends ConsumerState<UpdateAvailabilityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  bool _isLoaded = false;
  bool _isUpdating = false;

  String _selectedCountry = 'Pakistan';
  String _selectedTimezone = 'Asia/Karachi (PKT, UTC+5)';

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
    'Indonesia': ['Asia/Jakarta (WIB, UTC+7)', 'Asia/Makassar (WITA, UTC+8)'],
    'Nigeria': ['Africa/Lagos (WAT, UTC+1)'],
    'Qatar': ['Asia/Qatar (AST, UTC+3)'],
    'Kuwait': ['Asia/Kuwait (AST, UTC+3)'],
    'Oman': ['Asia/Muscat (GST, UTC+4)'],
    'Bahrain': ['Asia/Bahrain (AST, UTC+3)'],
    'Jordan': ['Asia/Amman (EET, UTC+2)'],
    'Morocco': ['Africa/Casablanca (WET, UTC+0/+1)'],
  };

  static const List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late Map<String, DaySlot> _slots;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _slots = {
      for (var d in _days)
        d: DaySlot(
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

  void _populateFromFirestore(Map<String, dynamic> data) {
    if (_isLoaded) return;
    _isLoaded = true;

    final country = data['country'] as String?;
    if (country != null && _countryTimezones.containsKey(country)) {
      _selectedCountry = country;
    }

    final tz = data['timezone'] as String?;
    if (tz != null && _countryTimezones[_selectedCountry]!.contains(tz)) {
      _selectedTimezone = tz;
    } else {
      _selectedTimezone = _countryTimezones[_selectedCountry]!.first;
    }

    final avail = data['availability'];
    if (avail is Map) {
      for (final day in _days) {
        final dayData = avail[day];
        if (dayData is Map) {
          final enabled = dayData['enabled'] as bool? ?? false;
          // Disabled day ka time Firestore mein nahi hoga — default use karo
          final startStr = dayData['startTime'] as String? ?? '9:00 AM';
          final endStr = dayData['endTime'] as String? ?? '5:00 PM';
          _slots[day] = DaySlot(
            enabled: enabled,
            start: enabled
                ? DaySlot.parseTime(startStr)
                : const TimeOfDay(hour: 9, minute: 0),
            end: enabled
                ? DaySlot.parseTime(endStr)
                : const TimeOfDay(hour: 17, minute: 0),
          );
        }
      }
    }
  }

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
        _slots[day] = isStart
            ? slot.copyWith(start: picked)
            : slot.copyWith(end: picked);
      });
    }
  }

  // ─── UPDATE — disabled days ka time save nahi hoga ───────────────────────
  Future<void> _update() async {
    if (!_slots.values.any((s) => s.enabled)) {
      _showSnack('Please enable at least one day', isError: true);
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final availability = <String, dynamic>{};
      for (final entry in _slots.entries) {
        final day = entry.key;
        final slot = entry.value;

        if (slot.enabled) {
          // Enabled — time ke saath save karo
          availability[day] = {
            'enabled': true,
            'startTime': DaySlot.formatTime(slot.start),
            'endTime': DaySlot.formatTime(slot.end),
          };
        } else {
          // Disabled — sirf enabled: false, koi time nahi
          availability[day] = {'enabled': false};
        }
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'country': _selectedCountry,
        'timezone': _selectedTimezone,
        'availability': availability,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ref.invalidate(teacherAvailabilityFutureProvider);

      if (mounted) {
        _showSnack('Availability updated successfully ✓', isError: false);
      }
    } catch (e) {
      if (mounted) _showSnack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.rejected : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final asyncData = ref.watch(teacherAvailabilityFutureProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        title: Text(
          'My Availability',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.045,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 2),
      body: Column(
        children: [
          _buildHeader(w, h),
          Expanded(
            child: asyncData.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGreen,
                  strokeWidth: 2.5,
                ),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      color: AppColors.textGrey,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load data\n$e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () =>
                          ref.invalidate(teacherAvailabilityFutureProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              data: (firestoreData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!_isLoaded && mounted) {
                    setState(() => _populateFromFirestore(firestoreData));
                  }
                });

                return FadeTransition(
                  opacity: _animCtrl,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.05,
                      vertical: h * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Country', Icons.public, w),
                        SizedBox(height: h * 0.008),
                        _dropdownCard(
                          value: _selectedCountry,
                          items: _countryTimezones.keys.toList(),
                          onChanged: (v) => setState(() {
                            _selectedCountry = v!;
                            _selectedTimezone = _countryTimezones[v]!.first;
                          }),
                          w: w,
                        ),
                        SizedBox(height: h * 0.018),

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

                        _sectionTitle(
                          'Weekly Schedule',
                          Icons.calendar_month_rounded,
                          w,
                        ),
                        SizedBox(height: h * 0.005),
                        Text(
                          'Toggle days and adjust your teaching hours',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: w * 0.03,
                          ),
                        ),
                        SizedBox(height: h * 0.012),

                        ...List.generate(_days.length, (i) {
                          final day = _days[i];
                          return _dayCard(day, _slots[day]!, w, h, i);
                        }),

                        SizedBox(height: h * 0.02),
                        _buildSummaryCard(w),
                        SizedBox(height: h * 0.02),

                        SizedBox(
                          width: double.infinity,
                          height: h * 0.065,
                          child: ElevatedButton(
                            onPressed: _isUpdating ? null : _update,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: AppColors.white,
                              elevation: 4,
                              shadowColor: AppColors.primaryGreen.withValues(
                                alpha: 0.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isUpdating
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
                                      Icon(Icons.save_rounded, size: w * 0.05),
                                      SizedBox(width: w * 0.02),
                                      Text(
                                        'Update Availability',
                                        style: TextStyle(
                                          fontSize: w * 0.042,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(height: h * 0.035),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double w, double h) {
    return Container(
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
          SizedBox(height: h * 0.008),
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
              Icons.edit_calendar_rounded,
              size: w * 0.07,
              color: AppColors.lightGold,
            ),
          ),
          SizedBox(height: h * 0.01),
          Text(
            'Update Availability',
            style: TextStyle(
              color: AppColors.white,
              fontSize: w * 0.048,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: h * 0.004),
          Text(
            'Modify your schedule anytime',
            style: TextStyle(color: Colors.white70, fontSize: w * 0.032),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(double w) {
    final activeDays = _slots.values.where((s) => s.enabled).length;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withValues(alpha: 0.08),
            AppColors.primaryGreen.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryGreen,
            size: 20,
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Text(
              '$activeDays day${activeDays != 1 ? 's' : ''} active in schedule',
              style: TextStyle(
                fontSize: w * 0.033,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.primaryGreen,
            size: w * 0.06,
          ),
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

  Widget _dayCard(String day, DaySlot slot, double w, double h, int index) {
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
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
        decoration: BoxDecoration(
          color: slot.enabled ? AppColors.white : AppColors.background,
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
                  onChanged: (v) =>
                      setState(() => _slots[day] = slot.copyWith(enabled: v)),
                ),
              ],
            ),
            if (slot.enabled) ...[
              SizedBox(height: h * 0.008),
              Row(
                children: [
                  SizedBox(width: w * 0.12),
                  _timeChip(
                    label: 'Start',
                    time: DaySlot.formatTime(slot.start),
                    icon: Icons.play_arrow_rounded,
                    w: w,
                    onTap: () => _pickTime(day, true),
                  ),
                  SizedBox(width: w * 0.03),
                  Icon(
                    Icons.arrow_forward,
                    size: w * 0.04,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(width: w * 0.03),
                  _timeChip(
                    label: 'End',
                    time: DaySlot.formatTime(slot.end),
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
