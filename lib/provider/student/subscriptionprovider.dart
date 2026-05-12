import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

// ─── State ─────────────────────────────────────────────────────────────────
class SubscriptionState {
  final List<SubscriptionPlanModel> plans;
  final String? selectedPlanId;
  final bool isSubscribing;

  const SubscriptionState({
    this.plans = const [],
    this.selectedPlanId,
    this.isSubscribing = false,
  });

  SubscriptionPlanModel? get selectedPlan =>
      plans.where((p) => p.id == selectedPlanId).firstOrNull;

  SubscriptionState copyWith({
    List<SubscriptionPlanModel>? plans,
    String? selectedPlanId,
    bool? isSubscribing,
  }) {
    return SubscriptionState(
      plans: plans ?? this.plans,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      isSubscribing: isSubscribing ?? this.isSubscribing,
    );
  }
}

// ─── Notifier ──────────────────────────────────────────────────────────────
class SubscriptionNotifier extends Notifier<SubscriptionState> {
  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  SubscriptionState build() {
    _loadPlans();
    return const SubscriptionState();
  }

  Future<void> _loadPlans() async {
    // Hardcoded plans — baad mein Firestore se bhi la sakte hain
    final plans = [
      const SubscriptionPlanModel(
        id: 'basic',
        title: 'Basic',
        price: 19,
        classesPerWeek: 2,
        studentsAllowed: 1,
        features: [
          '2 classes per week',
          '1 student',
          'Live 1-on-1 sessions',
          'Progress tracking',
        ],
      ),
      const SubscriptionPlanModel(
        id: 'standard',
        title: 'Standard',
        price: 35,
        classesPerWeek: 4,
        studentsAllowed: 2,
        isPopular: true,
        features: [
          '4 classes per week',
          'Up to 2 students',
          'Live 1-on-1 sessions',
          'Progress tracking',
          'Homework assignments',
        ],
      ),
      const SubscriptionPlanModel(
        id: 'premium',
        title: 'Premium',
        price: 59,
        classesPerWeek: 7,
        studentsAllowed: 4,
        features: [
          'Daily classes',
          'Up to 4 students',
          'Live 1-on-1 sessions',
          'Progress tracking',
          'Homework assignments',
          'Priority teacher matching',
        ],
      ),
    ];

    state = state.copyWith(plans: plans);
  }

  void selectPlan(String planId) {
    state = state.copyWith(selectedPlanId: planId);
  }

  Future<void> subscribe() async {
    if (state.selectedPlan == null || _uid.isEmpty) return;

    state = state.copyWith(isSubscribing: true);

    try {
      await _db.collection('users').doc(_uid).update({
        'isSubscribed': true,
        'subscriptionPlan': state.selectedPlan!.title,
        'subscribedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // error handle
    } finally {
      state = state.copyWith(isSubscribing: false);
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────
final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, SubscriptionState>(
      SubscriptionNotifier.new,
    );
