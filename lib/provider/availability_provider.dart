import 'package:flutter_riverpod/legacy.dart';
import 'package:quran_learning_app/models/availabilty/availabilty_model.dart';

// State
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

// Notifier
class AvailabilityNotifier extends StateNotifier<AvailabilityState> {
  AvailabilityNotifier() : super(const AvailabilityState()) {
    _loadDummyData(); // Firebase ke baad replace hoga
  }

  void _loadDummyData() {
    // Dummy data — baad mein Firebase se aayega
    final days = [
      const DayAvailabilityModel(
        day: 'Monday',
        timeRange: '09:00 AM - 10:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Tuesday',
        timeRange: '09:00 AM - 10:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Wednesday',
        timeRange: '09:00 AM - 10:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Thursday',
        timeRange: '09:00 AM - 10:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Friday',
        timeRange: '02:00 PM - 10:00 PM',
        isEnabled: true,
      ),
      const DayAvailabilityModel(
        day: 'Saturday',
        timeRange: '10:00 AM - 06:00 PM',
        isEnabled: false,
      ),
      const DayAvailabilityModel(
        day: 'Sunday',
        timeRange: 'Not Available',
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

  // Save availability
  // Firebase ke baad yahan Firestore call aayegi
  Future<void> saveAvailability() async {
    state = state.copyWith(isSaving: true);

    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    state = state.copyWith(isSaving: false, isSaved: true);
  }
}

// Provider
final availabilityProvider =
    StateNotifierProvider<AvailabilityNotifier, AvailabilityState>(
      (ref) => AvailabilityNotifier(),
    );
