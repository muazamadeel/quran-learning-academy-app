import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/models/class/class_model.dart';

class ClassState {
  final ClassModel? classInfo;
  final bool isMuted;
  final bool isVideoOn;
  final bool isScreenSharing;
  final String notes;
  final String elapsedTime;

  const ClassState({
    this.classInfo,
    this.isMuted = false,
    this.isVideoOn = true,
    this.isScreenSharing = false,
    this.notes = '',
    this.elapsedTime = '00:00:00',
  });

  ClassState copyWith({
    ClassModel? classInfo,
    bool? isMuted,
    bool? isVideoOn,
    bool? isScreenSharing,
    String? notes,
    String? elapsedTime,
  }) {
    return ClassState(
      classInfo: classInfo ?? this.classInfo,
      isMuted: isMuted ?? this.isMuted,
      isVideoOn: isVideoOn ?? this.isVideoOn,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      notes: notes ?? this.notes,
      elapsedTime: elapsedTime ?? this.elapsedTime,
    );
  }
}

class ClassNotifier extends Notifier<ClassState> {
  @override
  ClassState build() => const ClassState();

  void initClass(String studentName, String subject, String time) {
    state = state.copyWith(
      classInfo: ClassModel(
        studentName: studentName,
        subject: subject,
        time: time,
      ),
    );
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  void toggleVideo() {
    state = state.copyWith(isVideoOn: !state.isVideoOn);
  }

  void toggleScreenShare() {
    state = state.copyWith(isScreenSharing: !state.isScreenSharing);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void updateElapsedTime(String time) {
    state = state.copyWith(elapsedTime: time);
  }
}

final classProvider = NotifierProvider<ClassNotifier, ClassState>(
  ClassNotifier.new,
);
