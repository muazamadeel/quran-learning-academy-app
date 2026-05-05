import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';
import 'package:quran_learning_app/models/teacher/teacher_model.dart';

// Teacher State
@immutable
class TeacherDashboardState {
  final TeacherModel? teacher;
  final List<UpcomingClassModel> upcomingClasses;
  final bool isLoading;

  const TeacherDashboardState({
    this.teacher,
    this.upcomingClasses = const [],
    this.isLoading = false,
  });

  TeacherDashboardState copyWith({
    TeacherModel? teacher,
    List<UpcomingClassModel>? upcomingClasses,
    bool? isLoading,
  }) {
    return TeacherDashboardState(
      teacher: teacher ?? this.teacher,
      upcomingClasses: upcomingClasses ?? this.upcomingClasses,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Notifier
class TeacherDashboardNotifier extends StateNotifier<TeacherDashboardState> {
  TeacherDashboardNotifier() : super(const TeacherDashboardState()) {
    _loadDummyData(); // Baad mein Firebase se replace hoga
  }

  void _loadDummyData() {
    // Dummy data — Firebase ke baad yahan se data aayega
    final teacher = TeacherModel(
      id: '1',
      name: 'Ustadh Ahmed',
      email: 'ahmed@quran.com',
      experience: '5 Years',
      languages: ['Arabic', 'English', 'Urdu'],
      rating: 4.8,
      totalStudents: 20,
      todayClasses: 8,
      monthEarnings: 320,
    );

    final classes = [
      const UpcomingClassModel(
        id: '1',
        studentName: 'Ali Hassan',
        studentImage: '',
        time: 'Today, 10:00 AM',
        subject: 'Tajweed',
      ),
      const UpcomingClassModel(
        id: '2',
        studentName: 'Fatima Khan',
        studentImage: '',
        time: 'Today, 02:00 PM',
        subject: 'Hifz',
      ),
    ];

    state = state.copyWith(teacher: teacher, upcomingClasses: classes);
  }
}

// Provider
final teacherDashboardProvider =
    StateNotifierProvider<TeacherDashboardNotifier, TeacherDashboardState>(
      (ref) => TeacherDashboardNotifier(),
    );
