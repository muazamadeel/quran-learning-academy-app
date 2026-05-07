import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

class SubscriptionState {
  final List<SubscriptionPlanModel> plans;
  final String? selectedPlanId;
  final bool isSubscribing;
  final bool isSubscribed;

  const SubscriptionState({
    this.plans = const [],
    this.selectedPlanId,
    this.isSubscribing = false,
    this.isSubscribed = false,
  });

  SubscriptionState copyWith({
    List<SubscriptionPlanModel>? plans,
    String? selectedPlanId,
    bool? isSubscribing,
    bool? isSubscribed,
  }) {
    return SubscriptionState(
      plans: plans ?? this.plans,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      isSubscribing: isSubscribing ?? this.isSubscribing,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  SubscriptionPlanModel? get selectedPlan =>
      plans.where((p) => p.id == selectedPlanId).firstOrNull;
}

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() {
    return _loadPlans();
  }

  SubscriptionState _loadPlans() {
    final plans = [
      const SubscriptionPlanModel(
        id: 'single',
        title: 'Single Student',
        price: 40,
        classesPerWeek: 2,
        studentsAllowed: 1,
        isPopular: false,
        features: [
          '2 classes per week',
          '1 student',
          'Flexible timing',
          'Basic materials',
        ],
      ),
      const SubscriptionPlanModel(
        id: 'two',
        title: 'Two Students',
        price: 70,
        classesPerWeek: 3,
        studentsAllowed: 2,
        isPopular: true,
        features: [
          '3 classes per week',
          '2 students',
          'Flexible timing',
          'Progress reports',
          'Study materials',
        ],
      ),
      const SubscriptionPlanModel(
        id: 'three',
        title: 'Three Students',
        price: 90,
        classesPerWeek: 5,
        studentsAllowed: 3,
        isPopular: false,
        features: [
          '5 classes per week',
          '3 students',
          'Flexible timing',
          'Progress reports',
          'Study materials',
        ],
      ),
    ];

    return const SubscriptionState().copyWith(plans: plans, selectedPlanId: 'two');
  }

  void selectPlan(String planId) {
    state = state.copyWith(selectedPlanId: planId);
  }

  Future<void> subscribe() async {
    if (state.selectedPlanId == null) return;
    state = state.copyWith(isSubscribing: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isSubscribing: false, isSubscribed: true);
  }
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, SubscriptionState>(
      SubscriptionNotifier.new,
    );
