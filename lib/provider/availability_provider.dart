import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quran_learning_app/models/availabilty/availabilty_model.dart';

// ─── State ────────────────────────────────────────────────────────────────────
class AvailabilityState {
  final List<DayAvailabilityModel> days;
  final bool isSaving;
  final bool isSaved;

  const AvailabilityState({
    this.days = const [],
    this.isSaving = false,
    this.isSaved = false,
  });

  AvailabilityState copyWith({
    List<DayAvailabilityModel>? days,
    bool? isSaving,
    bool? isSaved,
  }) {
    return AvailabilityState(
      days: days ?? this.days,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────
class AvailabilityNotifier extends StateNotifier<AvailabilityState> {
  AvailabilityNotifier() : super(const AvailabilityState()) {
    _loadDefaultDays();
  }

  void _loadDefaultDays() {
    final days = [
      const DayAvailabilityModel(
        day: 'Monday',
        timeRange: '09:00 AM - 05:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Tuesday',
        timeRange: '09:00 AM - 05:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Wednesday',
        timeRange: '09:00 AM - 05:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Thursday',
        timeRange: '09:00 AM - 05:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Friday',
        timeRange: '02:00 PM - 06:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Saturday',
        timeRange: '10:00 AM - 04:00 PM',
        isEnabled: false,
      ),
      const DayAvailabilityModel(
        day: 'Sunday',
        timeRange: '10:00 AM - 04:00 PM',
        isEnabled: false,
      ),
    ];
    state = state.copyWith(days: days);
  }

  // Toggle day on/off
  void toggleDay(int index) {
    final updatedDays = [...state.days];
    updatedDays[index] = updatedDays[index].copyWith(
      isEnabled: !updatedDays[index].isEnabled,
    );
    state = state.copyWith(days: updatedDays, isSaved: false);
  }

  // Update time range
  void updateTimeRange(int index, String newTimeRange) {
    final updatedDays = [...state.days];
    updatedDays[index] = updatedDays[index].copyWith(timeRange: newTimeRange);
    state = state.copyWith(days: updatedDays, isSaved: false);
  }

  // Save to Firestore — disabled days ka time save nahi hoga
  Future<void> saveAvailability() async {
    state = state.copyWith(isSaving: true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final availability = <String, dynamic>{};
      for (final day in state.days) {
        if (day.isEnabled) {
          // Enabled day — time ke saath save karo
          final parts = day.timeRange.split(' - ');
          availability[day.day] = {
            'enabled': true,
            'startTime': parts.isNotEmpty ? parts[0].trim() : '',
            'endTime': parts.length > 1 ? parts[1].trim() : '',
          };
        } else {
          // Disabled day — sirf enabled: false, koi time nahi
          availability[day.day] = {'enabled': false};
        }
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'availability': availability,
      }, SetOptions(merge: true));

      state = state.copyWith(isSaving: false, isSaved: true);
    } catch (e) {
      state = state.copyWith(isSaving: false);
      rethrow;
    }
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────
final availabilityProvider =
    StateNotifierProvider<AvailabilityNotifier, AvailabilityState>(
      (ref) => AvailabilityNotifier(),
    );

/// Teacher ka poora Firestore document fetch karta hai
final teacherAvailabilityFutureProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
  return doc.data() ?? {};
});
