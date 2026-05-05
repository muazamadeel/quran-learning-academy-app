import 'package:flutter_riverpod/legacy.dart';

import 'package:quran_learning_app/models/progress/progress_model.dart';

class ProgressState {
  final ProgressModel? progress;
  final bool isSaving;
  final bool isSaved;

  const ProgressState({
    this.progress,
    this.isSaving = false,
    this.isSaved = false,
  });

  ProgressState copyWith({
    ProgressModel? progress,
    bool? isSaving,
    bool? isSaved,
  }) {
    return ProgressState(
      progress: progress ?? this.progress,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier() : super(const ProgressState());

  void initProgress(String studentId, String studentName) {
    state = state.copyWith(
      progress: ProgressModel(studentId: studentId, studentName: studentName),
    );
  }

  void updateProgressNote(String note) {
    state = state.copyWith(
      progress: state.progress?.copyWith(progressNote: note),
    );
  }

  void updateWhatWasCovered(String covered) {
    state = state.copyWith(
      progress: state.progress?.copyWith(whatWasCovered: covered),
    );
  }

  void updateHomework(String homework) {
    state = state.copyWith(
      progress: state.progress?.copyWith(homework: homework),
    );
  }

  void updateRating(String rating) {
    state = state.copyWith(progress: state.progress?.copyWith(rating: rating));
  }

  // Firebase ke baad Firestore mein save hoga
  Future<void> saveProgress() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isSaving: false, isSaved: true);
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>(
  (ref) => ProgressNotifier(),
);
