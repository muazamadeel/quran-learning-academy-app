import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

class StudentProgressState {
  final List<StudentProgressModel> progressNotes;
  final int totalClassesCompleted;
  final int currentStreak;
  final bool isLoading;

  const StudentProgressState({
    this.progressNotes = const [],
    this.totalClassesCompleted = 0,
    this.currentStreak = 0,
    this.isLoading = false,
  });

  StudentProgressState copyWith({
    List<StudentProgressModel>? progressNotes,
    int? totalClassesCompleted,
    int? currentStreak,
    bool? isLoading,
  }) {
    return StudentProgressState(
      progressNotes: progressNotes ?? this.progressNotes,
      totalClassesCompleted:
          totalClassesCompleted ?? this.totalClassesCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class StudentProgressNotifier extends Notifier<StudentProgressState> {
  @override
  StudentProgressState build() {
    return _loadDummyData();
  }

  StudentProgressState _loadDummyData() {
    final notes = [
      const StudentProgressModel(
        id: '1',
        teacherName: 'Ustadh Ahmed',
        subject: 'Tajweed',
        date: '1 May 2026',
        progressNote:
            'Good progress in recitation. Needs to improve Noon Saakinah.',
        whatWasCovered: 'Surah Al-Baqarah (Ayat 1-10)',
        homework: 'Practice Tajweed — Noon Saakinah rules',
        rating: 'Good',
      ),
      const StudentProgressModel(
        id: '2',
        teacherName: 'Ustadha Fatima',
        subject: 'Hifz',
        date: '29 Apr 2026',
        progressNote: 'Excellent memorization of last 5 ayat.',
        whatWasCovered: 'Surah Al-Kahf (Ayat 1-5)',
        homework: 'Revise Surah Al-Kahf Ayat 1-10',
        rating: 'Excellent',
      ),
      const StudentProgressModel(
        id: '3',
        teacherName: 'Ustadh Ahmed',
        subject: 'Tajweed',
        date: '27 Apr 2026',
        progressNote: 'Average session. Pronunciation needs work.',
        whatWasCovered: 'Makharij Al-Huroof basics',
        homework: 'Listen to Qari recitation 15 minutes daily',
        rating: 'Average',
      ),
    ];

    return const StudentProgressState().copyWith(
      progressNotes: notes,
      totalClassesCompleted: 12,
      currentStreak: 5,
    );
  }
}

final studentProgressProvider =
    NotifierProvider<StudentProgressNotifier, StudentProgressState>(
      StudentProgressNotifier.new,
    );
