import 'package:flutter_riverpod/legacy.dart';
import 'package:quran_learning_app/models/booking/booking_model.dart';

class BookingState {
  final List<BookingModel> pendingBookings;
  final List<BookingModel> confirmedBookings;
  final List<BookingModel> completedBookings;
  final int selectedTab;
  final bool isLoading;

  const BookingState({
    this.pendingBookings = const [],
    this.confirmedBookings = const [],
    this.completedBookings = const [],
    this.selectedTab = 0,
    this.isLoading = false,
  });

  BookingState copyWith({
    List<BookingModel>? pendingBookings,
    List<BookingModel>? confirmedBookings,
    List<BookingModel>? completedBookings,
    int? selectedTab,
    bool? isLoading,
  }) {
    return BookingState(
      pendingBookings: pendingBookings ?? this.pendingBookings,
      confirmedBookings: confirmedBookings ?? this.confirmedBookings,
      completedBookings: completedBookings ?? this.completedBookings,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // Current tab ki list
  List<BookingModel> get currentList {
    switch (selectedTab) {
      case 0:
        return pendingBookings;
      case 1:
        return confirmedBookings;
      case 2:
        return completedBookings;
      default:
        return pendingBookings;
    }
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(const BookingState()) {
    _loadDummyData();
  }

  void _loadDummyData() {
    // Firebase ke baad yahan se data aayega
    final pending = [
      const BookingModel(
        id: '1',
        studentName: 'Ali Hassan',
        studentImage: '',
        date: 'Today',
        time: '10:00 AM',
        subject: 'Tajweed',
        status: 'pending',
      ),
      const BookingModel(
        id: '2',
        studentName: 'Fatima Khan',
        studentImage: '',
        date: 'Today',
        time: '02:00 PM',
        subject: 'Hifz',
        status: 'pending',
      ),
      const BookingModel(
        id: '3',
        studentName: 'Usman Tariq',
        studentImage: '',
        date: 'Tomorrow',
        time: '11:00 AM',
        subject: 'Tafseer',
        status: 'pending',
      ),
      const BookingModel(
        id: '4',
        studentName: 'Ayesha Malik',
        studentImage: '',
        date: '15 May',
        time: '04:00 PM',
        subject: 'Quran Reading',
        status: 'pending',
      ),
    ];

    final confirmed = [
      const BookingModel(
        id: '5',
        studentName: 'Hassan Ali',
        studentImage: '',
        date: '16 May',
        time: '09:00 AM',
        subject: 'Tajweed',
        status: 'confirmed',
      ),
    ];

    final completed = [
      const BookingModel(
        id: '6',
        studentName: 'Sara Ahmed',
        studentImage: '',
        date: '1 May',
        time: '10:00 AM',
        subject: 'Hifz',
        status: 'completed',
      ),
    ];

    state = state.copyWith(
      pendingBookings: pending,
      confirmedBookings: confirmed,
      completedBookings: completed,
    );
  }

  // Tab change
  void changeTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  // Accept booking
  // Firebase ke baad Firestore update aayega
  void acceptBooking(String bookingId) {
    final booking = state.pendingBookings.firstWhere((b) => b.id == bookingId);

    final updatedPending = state.pendingBookings
        .where((b) => b.id != bookingId)
        .toList();

    final updatedConfirmed = [
      ...state.confirmedBookings,
      booking.copyWith(status: 'confirmed'),
    ];

    state = state.copyWith(
      pendingBookings: updatedPending,
      confirmedBookings: updatedConfirmed,
    );
  }

  // Reject booking
  // Firebase ke baad Firestore update aayega
  void rejectBooking(String bookingId) {
    final updatedPending = state.pendingBookings
        .where((b) => b.id != bookingId)
        .toList();

    state = state.copyWith(pendingBookings: updatedPending);
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>(
  (ref) => BookingNotifier(),
);
