import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
class StudentScheduleState {
  final List<StudentUpcomingClassModel> upcomingClasses;
  final List<StudentUpcomingClassModel> completedClasses;
  final int selectedTab;
  final bool isLoading;

  const StudentScheduleState({
    this.upcomingClasses = const [],
    this.completedClasses = const [],
    this.selectedTab = 0,
    this.isLoading = false,
  });

  StudentScheduleState copyWith({
    List<StudentUpcomingClassModel>? upcomingClasses,
    List<StudentUpcomingClassModel>? completedClasses,
    int? selectedTab,
    bool? isLoading,
  }) {
    return StudentScheduleState(
      upcomingClasses: upcomingClasses ?? this.upcomingClasses,
      completedClasses: completedClasses ?? this.completedClasses,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<StudentUpcomingClassModel> get currentList =>
      selectedTab == 0 ? upcomingClasses : completedClasses;
}

class StudentScheduleNotifier extends Notifier<StudentScheduleState> {
  @override
  StudentScheduleState build() {
    return _loadDummyData();
  }

  StudentScheduleState _loadDummyData() {
    final upcoming = [
      const StudentUpcomingClassModel(
        id: '1',
        teacherName: 'Ustadh Ahmed',
        teacherImage: '',
        time: '10:00 AM',
        date: 'Today, 3 May',
        subject: 'Tajweed',
      ),
      const StudentUpcomingClassModel(
        id: '2',
        teacherName: 'Ustadha Fatima',
        teacherImage: '',
        time: '02:00 PM',
        date: 'Tomorrow, 4 May',
        subject: 'Hifz',
      ),
      const StudentUpcomingClassModel(
        id: '3',
        teacherName: 'Ustadh Omar',
        teacherImage: '',
        time: '11:00 AM',
        date: 'Mon, 6 May',
        subject: 'Tafseer',
      ),
    ];

    final completed = [
      const StudentUpcomingClassModel(
        id: '4',
        teacherName: 'Ustadh Ahmed',
        teacherImage: '',
        time: '10:00 AM',
        date: '1 May',
        subject: 'Tajweed',
        status: 'completed',
      ),
      const StudentUpcomingClassModel(
        id: '5',
        teacherName: 'Ustadha Fatima',
        teacherImage: '',
        time: '02:00 PM',
        date: '29 Apr',
        subject: 'Hifz',
        status: 'completed',
      ),
    ];

    return const StudentScheduleState().copyWith(
      upcomingClasses: upcoming,
      completedClasses: completed,
    );
  }

  void changeTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  void cancelClass(String classId) {
    final updated = state.upcomingClasses
        .where((c) => c.id != classId)
        .toList();
    state = state.copyWith(upcomingClasses: updated);
  }
}

final studentScheduleProvider =
    NotifierProvider<StudentScheduleNotifier, StudentScheduleState>(
      StudentScheduleNotifier.new,
    );
