/*
import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../util/constants.dart';

class AudioNote extends StatefulWidget {
  const AudioNote({Key? key}) : super(key: key);

  @override
  State<AudioNote> createState() => _AudioNoteState();
}

class _AudioNoteState extends State<AudioNote> {
  late FlutterSoundRecorder _recordingSession;

  final recordingPlayer = AssetsAudioPlayer();

  bool _playAudio = false;
  String _timerText= '00:00:00';

  void initializer() async {
    _recordingSession = FlutterSoundRecorder();
    await _recordingSession.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _recordingSession.setSubscriptionDuration(const Duration(
        milliseconds: 10));
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future<void> playFunc() async {
    recordingPlayer.open(
      Audio.file(AppConstants.pathToAudio),
      autoStart: true,
      showNotification: true,
    );
  }

  Future<void> stopPlayFunc() async {
    recordingPlayer.stop();
  }

  ElevatedButton createElevatedButton(
      {required IconData icon, required Color iconColor, required Function onPressFunc}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(6.0), backgroundColor: Colors.white,
        side: const BorderSide(
          color: Colors.red,
          width: 4.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 9.0,
      ),
      onPressed: () => onPressFunc(),
      icon: Icon(
        icon,
        color: iconColor,
        size: 38.0,
      ),
      label: const Text(''),
    );
  }

  @override
  void initState() {
    super.initState();
    initializer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
    Center(
      child: Text(
      _timerText,
      style: const TextStyle(fontSize: 70, color: Colors.red),
    ),
    ),const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          style:
          ElevatedButton.styleFrom(elevation: 9.0, backgroundColor: Colors.red),
          onPressed: () {
            setState(() {
              _playAudio = !_playAudio;
            });
            if (_playAudio) playFunc();
            if (!_playAudio) stopPlayFunc();
          },
          icon: _playAudio
              ? const Icon(
            Icons.stop,
          )
              : const Icon(Icons.play_arrow),
          label: _playAudio
              ? const Text(
            "Stop",
            style: TextStyle(
              fontSize: 28,
            ),
          )
              : const Text(
            "Play",
            style: TextStyle(
              fontSize: 28,
            ),
          ),
        ),]));
  }
}
*/
