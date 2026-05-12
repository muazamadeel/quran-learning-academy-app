import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/student/student_model.dart';

class TeacherListState {
  final List<TeacherListModel> allTeachers;
  final List<TeacherListModel> filteredTeachers;
  final String searchQuery;
  final String selectedExperience;
  final bool isLoading;

  const TeacherListState({
    this.allTeachers = const [],
    this.filteredTeachers = const [],
    this.searchQuery = '',
    this.selectedExperience = 'All',
    this.isLoading = true,
  });

  TeacherListState copyWith({
    List<TeacherListModel>? allTeachers,
    List<TeacherListModel>? filteredTeachers,
    String? searchQuery,
    String? selectedExperience,
    bool? isLoading,
  }) {
    return TeacherListState(
      allTeachers: allTeachers ?? this.allTeachers,
      filteredTeachers: filteredTeachers ?? this.filteredTeachers,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedExperience: selectedExperience ?? this.selectedExperience,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TeacherListNotifier extends Notifier<TeacherListState> {
  final _db = FirebaseFirestore.instance;

  @override
  TeacherListState build() {
    _loadTeachers();
    return const TeacherListState();
  }

  Future<void> _loadTeachers() async {
    try {
      final snap = await _db
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .where('isApproved', isEqualTo: true)
          .get();

      final teachers = snap.docs.map((doc) {
        final d = doc.data();
        return TeacherListModel(
          id: doc.id,
          name: d['name'] ?? '',
          experience: d['experience'] ?? '',
          languages: List<String>.from(d['languages'] ?? []),
          rating: (d['rating'] ?? 0.0).toDouble(),
          totalStudents: d['totalStudents'] ?? 0,
          profileImage: d['profileImage'] ?? '',
          isAvailable: true,

          country: d['country'] ?? '',
          timezone: d['timezone'] ?? '',
          availability: Map<String, dynamic>.from(d['availability'] ?? {}),
        );
      }).toList();

      state = state.copyWith(
        allTeachers: teachers,
        filteredTeachers: teachers,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void filterByExperience(String experience) {
    state = state.copyWith(selectedExperience: experience);
    _applyFilters();
  }

  void _applyFilters() {
    var list = state.allTeachers;

    if (state.searchQuery.isNotEmpty) {
      list = list
          .where(
            (t) =>
                t.name.toLowerCase().contains(state.searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (state.selectedExperience != 'All') {
      list = list
          .where((t) => t.experience == state.selectedExperience)
          .toList();
    }

    state = state.copyWith(filteredTeachers: list);
  }
}

final teacherListProvider =
    NotifierProvider<TeacherListNotifier, TeacherListState>(
      TeacherListNotifier.new,
    );
