import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/provider/student/progress_student_provider.dart';

import '../../../provider/progress_teacher_provider.dart';

class ProgressNotesScreen extends ConsumerStatefulWidget {
  final String studentName;
  final String studentId;
  final String teacherId;
  final bool isTeacher;

  const ProgressNotesScreen({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.teacherId,
    required this.isTeacher,
  });

  @override
  ConsumerState<ProgressNotesScreen> createState() =>
      _ProgressNotesScreenState();
}

class _ProgressNotesScreenState extends ConsumerState<ProgressNotesScreen> {
  final progressController = TextEditingController();
  final coveredController = TextEditingController();
  final homeworkController = TextEditingController();

  String rating = "Good";

  final ratings = ["Excellent", "Good", "Average", "Needs Improvement"];

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(progressStudentProvider(widget.studentId));

    final teacherNotifier = ref.read(progressTeacherProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Progress Notes")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.isTeacher) ...[
              /// ───────── INPUTS ─────────
              TextField(
                controller: progressController,
                decoration: const InputDecoration(labelText: "Progress"),
              ),

              TextField(
                controller: coveredController,
                decoration: const InputDecoration(labelText: "Covered"),
              ),

              TextField(
                controller: homeworkController,
                decoration: const InputDecoration(labelText: "Homework"),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                children: ratings.map((r) {
                  final selected = rating == r;

                  return ChoiceChip(
                    label: Text(r),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => rating = r);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              /// ───────── SAVE BUTTON ─────────
              ElevatedButton(
                onPressed: () async {
                  await teacherNotifier.addProgress(
                    studentId: widget.studentId,
                    studentName: widget.studentName,
                    teacherId: widget.teacherId,
                    teacherName: '',
                    progressNote: progressController.text,
                    whatWasCovered: coveredController.text,
                    homework: homeworkController.text,
                    rating: rating,
                  );

                  progressController.clear();
                  coveredController.clear();
                  homeworkController.clear();

                  setState(() => rating = "Good");
                },
                child: const Text("Save Note"),
              ),
              const SizedBox(height: 30),
            ],

            /// ───────── REAL TIME LIST ─────────
            const Text(
              "Previous Lessons",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            notesAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("Error: $e"),
              data: (notes) {
                if (notes.isEmpty) {
                  return const Text("No notes yet");
                }

                return Column(
                  children: notes.map((n) {
                    return Card(
                      child: ListTile(
                        title: Text(n.teacherName),
                        subtitle: Text(n.progressNote),
                        trailing: Text(n.rating),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
