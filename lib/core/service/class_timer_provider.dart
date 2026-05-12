import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

// ── Class Status ──────────────────────────────────────────────────────────────
enum ClassStatus {
  waiting, // Abhi time nahi hua — countdown dikh raha hai
  live, // Class time ho gaya — Agora join ho gaya
  ended, // Class khatam — progress screen
}

// ── State ─────────────────────────────────────────────────────────────────────
class ClassTimerState {
  final ClassStatus status;
  final Duration remaining; // Class shuru hone mein kitna waqt
  final Duration elapsed; // Class shuru hone ke baad kitna waqt guzra
  final int totalMinutes; // Class ki total duration

  const ClassTimerState({
    this.status = ClassStatus.waiting,
    this.remaining = Duration.zero,
    this.elapsed = Duration.zero,
    this.totalMinutes = 30,
  });

  // Progress 0.0 to 1.0
  double get progress {
    if (totalMinutes == 0) return 0;
    final total = totalMinutes * 60;
    final done = elapsed.inSeconds.clamp(0, total);
    return done / total;
  }

  // Remaining class time (after class started)
  Duration get classTimeLeft {
    final total = Duration(minutes: totalMinutes);
    final left = total - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  ClassTimerState copyWith({
    ClassStatus? status,
    Duration? remaining,
    Duration? elapsed,
    int? totalMinutes,
  }) {
    return ClassTimerState(
      status: status ?? this.status,
      remaining: remaining ?? this.remaining,
      elapsed: elapsed ?? this.elapsed,
      totalMinutes: totalMinutes ?? this.totalMinutes,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────
class ClassTimerNotifier extends StateNotifier<ClassTimerState> {
  ClassTimerNotifier() : super(const ClassTimerState());

  Timer? _timer;
  DateTime? _scheduledAt;
  int _durationMinutes = 30;

  // ── Start tracking ────────────────────────────────────────────────────────
  void start({required DateTime scheduledAt, required int durationMinutes}) {
    _timer?.cancel();
    _scheduledAt = scheduledAt;
    _durationMinutes = durationMinutes;
    // Clear any stale "ended" from a previous session before first tick.
    state = ClassTimerState(totalMinutes: durationMinutes);

    _tick(); // immediate first tick
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_scheduledAt == null) return;

    final now = DateTime.now();
    final diff = _scheduledAt!.difference(now);

    // ── Waiting: class shuru nahi hui ──────────────────────────────────────
    if (diff.inSeconds > 0) {
      state = state.copyWith(
        status: ClassStatus.waiting,
        remaining: diff,
        totalMinutes: _durationMinutes,
      );
      return;
    }

    // ── Live: class chal rahi hai ──────────────────────────────────────────
    final elapsed = now.difference(_scheduledAt!);
    final totalSeconds = (_durationMinutes * 60).clamp(1, 86400);
    final classOver = elapsed.inSeconds >= totalSeconds;

    if (classOver) {
      // ── Ended ────────────────────────────────────────────────────────────
      _timer?.cancel();
      state = state.copyWith(
        status: ClassStatus.ended,
        elapsed: Duration(minutes: _durationMinutes),
        totalMinutes: _durationMinutes,
      );
    } else {
      state = state.copyWith(
        status: ClassStatus.live,
        elapsed: elapsed,
        remaining: Duration.zero,
        totalMinutes: _durationMinutes,
      );
    }
  }

  // ── Manually end class (teacher ends early) ───────────────────────────────
  void endClass() {
    _timer?.cancel();
    state = state.copyWith(status: ClassStatus.ended);
  }

  /// New session — clear stale "ended" from previous class.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _scheduledAt = null;
    _durationMinutes = 30;
    state = const ClassTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final classTimerProvider =
    StateNotifierProvider<ClassTimerNotifier, ClassTimerState>(
      (ref) => ClassTimerNotifier(),
    );
