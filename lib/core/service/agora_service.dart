import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const String agoraAppId = '52d99b99bd8240558c5ef64ba3e07202';

class AgoraService {
  static RtcEngine? _engine;

  static RtcEngine get engine {
    if (_engine == null) throw Exception('Agora not initialized');
    return _engine!;
  }

  // ── Initialize ────────────────────────────────────────────────────────────
  static Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(
      const RtcEngineContext(
        appId: agoraAppId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
    await _engine!.enableVideo();
    await _engine!.enableAudio();
    await _engine!.startPreview();
  }

  // ── Request Permissions ───────────────────────────────────────────────────
  static Future<bool> requestPermissions() async {
    final camera = await Permission.camera.request();
    final mic = await Permission.microphone.request();
    return camera.isGranted && mic.isGranted;
  }

  // ── Join Channel ──────────────────────────────────────────────────────────
  static Future<void> joinChannel({
    required String channelName,
    required int uid,
    String? token, // null = testing mode (no token)
  }) async {
    await _engine!.joinChannel(
      token: token ?? '',
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
  }

  // ── Leave Channel ─────────────────────────────────────────────────────────
  static Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
    await _engine?.stopPreview();
  }

  // ── Dispose ───────────────────────────────────────────────────────────────
  static Future<void> dispose() async {
    await _engine?.release();
    _engine = null;
  }

  // ── Toggle Mic ────────────────────────────────────────────────────────────
  static Future<void> toggleMic(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  // ── Toggle Camera ─────────────────────────────────────────────────────────
  static Future<void> toggleCamera(bool disabled) async {
    await _engine?.muteLocalVideoStream(disabled);
  }

  // ── Switch Camera ─────────────────────────────────────────────────────────
  static Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  // ── Screen Share (Android/iOS) ────────────────────────────────────────────
  static Future<void> startScreenShare() async {
    await _engine?.startScreenCapture(
      const ScreenCaptureParameters2(captureAudio: true, captureVideo: true),
    );
    await _engine?.updateChannelMediaOptions(
      const ChannelMediaOptions(
        publishScreenTrack: true,
        publishCameraTrack: false,
      ),
    );
  }

  static Future<void> stopScreenShare() async {
    await _engine?.stopScreenCapture();
    await _engine?.updateChannelMediaOptions(
      const ChannelMediaOptions(
        publishScreenTrack: false,
        publishCameraTrack: true,
      ),
    );
  }
}
