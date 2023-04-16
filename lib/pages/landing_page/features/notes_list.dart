import 'dart:math' show Random;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/app_dimensions.dart';
import '../../../config/app_routes.dart';
import '../../../models/note.dart';
import '../../../providers.dart';

///
typedef _Fn = void Function();

/// Layout types.
enum ListLayout { grid, list }

/// A grid of all notes available.
class NotesList extends ConsumerStatefulWidget {
  final ListLayout layout;

  /// Instance of a grid of all notes available.
  const NotesList(this.layout, {Key? key}) : super(key: key);

  @override
  ConsumerState<NotesList> createState() => _NotesListState();
}

class _NotesListState extends ConsumerState<NotesList> {
  final _codec = Codec.aacMP4;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  bool _mplaybackReady = true;
  String _mPath = '';

  get _notifier => ref.read(notesProvider.notifier);

  int? get _filter => ref.watch(filterProvider);

  List<NoteModel> get _notes => (_filter == null)
      ? ref.watch(notesProvider)
      : ref.watch(notesProvider).where((note) {
          return note.categoryId == _filter;
        }).toList();

  Future<void> _openThePlayer() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.unknown,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mPlayerIsInited = true;
  }

  void play() {
    assert(_mPlayerIsInited && _mplaybackReady && _mPlayer!.isStopped);
    debugPrint('Playing - $_mPath');
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            codec: kIsWeb ? Codec.opusWebM : _codec,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    debugPrint('Stop playing - $_mPath');
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  _Fn? getPlaybackFn(path) {
    setState(() {
      _mPath = path;
    });
    if (!_mPlayerIsInited || !_mplaybackReady) {
      return null;
    }

    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  void initState() {
    super.initState();

    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    _openThePlayer();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(children: [
              ElevatedButton(
                onPressed: getPlaybackFn(''),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Play'),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(_mPlayer!.isPlaying
                  ? 'Playback in progress'
                  : 'Player is stopped'),
            ]),
          ),
        ],
      );
    }

    if (_notes.isEmpty) {
      return const SizedBox(
        child: Center(
            child: Text(
          'No notes yet!',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppDimensions.fontSize1,
          ),
        )),
      );
    }

    switch (widget.layout) {
      case ListLayout.grid:
        return SizedBox(
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: AppDimensions.childAspectRatio),
              itemCount: _notes.length,
              itemBuilder: (ctx, index) {
                return _NoteCard(_notes[index], secondColumn: (index % 2 == 0),
                    onPressed: () {
                  if (_notes[index].isAudio) {
                    getPlaybackFn(_notes[index].path)!();
                  } else {
                    _notifier.currentNote = _notes[index].id;
                    Navigator.of(context)
                        .pushNamed(AppRouter.existingNoteRoute);
                  }
                });
              }),
        );
      case ListLayout.list:
        return SizedBox(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _notes.length,
              itemBuilder: (ctx, index) {
                return _NoteCard(_notes[index], secondColumn: (index % 2 == 0),
                    onPressed: () {
                  if (_notes[index].isAudio) {
                  } else {
                    _notifier.currentNote = _notes[index].id;
                    Navigator.of(context)
                        .pushNamed(AppRouter.existingNoteRoute);
                  }
                });
              }),
        );
    }
  }
}

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onPressed;

  /// If item is divisible by 2 then let the bottom right corner not be round.
  final bool secondColumn;

  _NoteCard(this.note,
      {Key? key, required this.onPressed, required this.secondColumn})
      : super(key: key);

  final List<Color> _predefinedColors = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pinkAccent,
    Colors.teal
  ];

  Color _getRandomColor() {
    Random random = Random();
    return _predefinedColors[random.nextInt(_predefinedColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        color: note.color ?? _getRandomColor(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: secondColumn
                    ? Radius.zero
                    : const Radius.circular(AppDimensions.borderRadius1),
                topRight: const Radius.circular(AppDimensions.borderRadius1),
                bottomRight: secondColumn
                    ? const Radius.circular(AppDimensions.borderRadius1)
                    : Radius.zero,
                bottomLeft:
                    const Radius.circular(AppDimensions.borderRadius1))),
        // margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.padding1),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _NoteHeader(id: note.id, title: note.title),
            _NoteContent(content: note.notes),
          ]),
        ),
      ),
    );
  }
}

class _NoteHeader extends StatelessWidget {
  final int id;
  final String title;

  const _NoteHeader({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: AppDimensions.screenWidth * 0.2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            )),
        Consumer(
          builder: (ctx, ref, child) {
            return IconButton(
                onPressed: () {
                  final notifier = ref.watch(notesProvider.notifier);
                  notifier.deleteNote(id);
                },
                icon: const Icon(Icons.delete, color: Colors.black));
          },
        )
      ],
    );
  }
}

class _NoteContent extends StatelessWidget {
  final List<Note> content;

  const _NoteContent({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              content.first.content,
              overflow: TextOverflow.ellipsis,
            )));
  }
}
