// lib/provider/agora_provider.dart

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quran_learning_app/core/service/agora_service.dart';

// ── State ─────────────────────────────────────────────────────────────────────
class AgoraState {
  final bool isJoined;
  final bool isMicMuted;
  final bool isCameraOff;
  final bool isScreenSharing;
  final bool isLoading;
  final String? error;
  final List<int> remoteUids; // joined remote users

  const AgoraState({
    this.isJoined = false,
    this.isMicMuted = false,
    this.isCameraOff = false,
    this.isScreenSharing = false,
    this.isLoading = false,
    this.error,
    this.remoteUids = const [],
  });

  AgoraState copyWith({
    bool? isJoined,
    bool? isMicMuted,
    bool? isCameraOff,
    bool? isScreenSharing,
    bool? isLoading,
    String? error,
    List<int>? remoteUids,
  }) {
    return AgoraState(
      isJoined: isJoined ?? this.isJoined,
      isMicMuted: isMicMuted ?? this.isMicMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      remoteUids: remoteUids ?? this.remoteUids,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────
class AgoraNotifier extends StateNotifier<AgoraState> {
  AgoraNotifier() : super(const AgoraState());

  // ── Join ────────────────────────────────────────────────────────────────
  Future<void> joinCall({required String channelName, required int uid}) async {
    state = state.copyWith(isLoading: true);

    try {
      final granted = await AgoraService.requestPermissions();
      if (!granted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Camera/Mic permission denied',
        );
        return;
      }

      await AgoraService.initialize();

      // Register event handlers
      AgoraService.engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            state = state.copyWith(isJoined: true, isLoading: false);
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            final updated = [...state.remoteUids, remoteUid];
            state = state.copyWith(remoteUids: updated);
          },
          onUserOffline: (connection, remoteUid, reason) {
            final updated = state.remoteUids
                .where((uid) => uid != remoteUid)
                .toList();
            state = state.copyWith(remoteUids: updated);
          },
          onError: (err, msg) {
            state = state.copyWith(error: msg, isLoading: false);
          },
        ),
      );

      await AgoraService.joinChannel(channelName: channelName, uid: uid);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // ── Leave ───────────────────────────────────────────────────────────────
  Future<void> leaveCall() async {
    await AgoraService.leaveChannel();
    await AgoraService.dispose();
    state = const AgoraState();
  }

  // ── Toggle Mic ──────────────────────────────────────────────────────────
  Future<void> toggleMic() async {
    final newMuted = !state.isMicMuted;
    await AgoraService.toggleMic(newMuted);
    state = state.copyWith(isMicMuted: newMuted);
  }

  // ── Toggle Camera ───────────────────────────────────────────────────────
  Future<void> toggleCamera() async {
    final newOff = !state.isCameraOff;
    await AgoraService.toggleCamera(newOff);
    state = state.copyWith(isCameraOff: newOff);
  }

  // ── Switch Camera ───────────────────────────────────────────────────────
  Future<void> switchCamera() async {
    await AgoraService.switchCamera();
  }

  // ── Screen Share ────────────────────────────────────────────────────────
  Future<void> toggleScreenShare() async {
    if (state.isScreenSharing) {
      await AgoraService.stopScreenShare();
      state = state.copyWith(isScreenSharing: false);
    } else {
      await AgoraService.startScreenShare();
      state = state.copyWith(isScreenSharing: true);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final agoraProvider = StateNotifierProvider<AgoraNotifier, AgoraState>(
  (ref) => AgoraNotifier(),
);
