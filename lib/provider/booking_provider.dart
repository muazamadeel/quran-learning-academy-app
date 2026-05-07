import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/booking/booking_model.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

final _db = FirebaseFirestore.instance;

// ─── Confirmed bookings ───────────────────────────────────────────────────────
final confirmedBookingsProvider = StreamProvider<List<BookingModel>>((ref) {
  final authState = ref.watch(authProvider);
  final uid = authState.user?.id ?? '';

  if (uid.isEmpty) return const Stream.empty();

  return _db
      .collection('bookings')
      .where('teacherId', isEqualTo: uid)
      .where('status', isEqualTo: 'confirmed')
      .snapshots()
      .map((snap) {
        final list = snap.docs
            .map((d) => BookingModel.fromFirestore(d))
            .toList();
        list.sort(
          (a, b) => (a.scheduledAt ?? DateTime(0)).compareTo(
            b.scheduledAt ?? DateTime(0),
          ),
        );
        return list;
      });
});

// ─── Completed bookings ───────────────────────────────────────────────────────
final completedBookingsProvider = StreamProvider<List<BookingModel>>((ref) {
  final authState = ref.watch(authProvider);
  final uid = authState.user?.id ?? '';

  if (uid.isEmpty) return const Stream.empty();

  return _db
      .collection('bookings')
      .where('teacherId', isEqualTo: uid)
      .where('status', isEqualTo: 'completed')
      .limit(30)
      .snapshots()
      .map((snap) {
        final list = snap.docs
            .map((d) => BookingModel.fromFirestore(d))
            .toList();
        // Newest first
        list.sort(
          (a, b) => (b.scheduledAt ?? DateTime(0)).compareTo(
            a.scheduledAt ?? DateTime(0),
          ),
        );
        return list;
      });
});

// ─── Selected Tab State ───────────────────────────────────────────────────────
final bookingSelectedTabProvider = NotifierProvider<BookingTabNotifier, int>(
  BookingTabNotifier.new,
);

class BookingTabNotifier extends Notifier<int> {
  @override
  int build() => 0; // 0 = Confirmed, 1 = Completed
  void update(int v) => state = v;
}

// ─── Actions Notifier ─────────────────────────────────────────────────────────
final bookingActionsProvider =
    AsyncNotifierProvider<BookingActionsNotifier, void>(
      BookingActionsNotifier.new,
    );

class BookingActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> markCompleted(String bookingId) async {
    state = await AsyncValue.guard(() async {
      await _db.collection('bookings').doc(bookingId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> submitReview({
    required String bookingId,
    required double rating,
    required String review,
  }) async {
    state = await AsyncValue.guard(() async {
      await _db.collection('bookings').doc(bookingId).update({
        'studentRating': rating,
        'studentReview': review,
        'reviewedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
