import 'dart:math' show Random;
import 'dart:io' as io;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import '../models/note.dart';
import '../util/constants.dart';
import '../providers.dart';

const String hiveDirectory = 'note_models_test_6';
const String hiveDirectory2 = 'notes_test_6';

const int audioNoteID = 0;

class NotesNotifier extends StateNotifier<List<NoteModel>> {
  final StateNotifierProviderRef<NotesNotifier, List<NoteModel>> ref;

  NotesNotifier(this.ref) : super([]) {
    _fetchLocalNotes();
  }

  Future<Box<NoteModel>> get _openBox async {
    return await Hive.openBox<NoteModel>(hiveDirectory);
  }

  void _fetchLocalNotes() async {
    debugPrint('Init notes');
    final audioFiles = await _listOfAudioFiles();
    final notesBox = await _openBox;
    final notes = notesBox.values.toList();

    final List<NoteModel> voiceNotes = audioFiles.map((element) {
      return NoteModel(
          title: 'Voice Note',
          id: audioNoteID,
          categoryId: 3,
          path: element.uri.toString(),
          notes: [0],
          color: _getRandomColor().toString(),
          isAudio: true);
    }).toList();

    debugPrint('on init, empty? - ${notesBox.values.isEmpty}');

    state = [...state, ...notes, ...voiceNotes]..sort(
        (a, b) {
          return b.date.compareTo(a.date);
        },
      );
  }

  Future<List<io.FileSystemEntity>> _listOfAudioFiles() async {
    await AppUtil.createFolderInAppDocDir(audioFolder);

    final directory = (await getApplicationDocumentsDirectory()).path;

    return io.Directory("$directory/$audioFolder/").listSync()
      ..sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));
  }

  int? _currentNote;

  /// ID of the note to be viewed.
  int get currentNote => _currentNote as int;

  /// Set ID of the note to be viewed.
  set currentNote(int value) {
    _currentNote = value;
  }

  /// Get new note ID.
  int get newNoteID {
    int highestId = 0;

    for (var element in state) {
      if (element.id > highestId) {
        highestId = element.id;
      }
    }
    return (highestId + 1);
  }

  /// Add a new note.
  Future<void> newNote(NoteModel newNote) async {
    final notesBox = await _openBox;

    final temp = NoteModel.fromExisting(
      existing: newNote,
      noteColor: _getRandomColor().toString(),
    );

    await notesBox.add(temp);
    debugPrint(notesBox.values.first.id.toString());

    state = [...state, temp];
  }

  void saveNote(NoteModel existing) async {
    final notesBox = await _openBox;

    final index = state.indexOf(state.firstWhere((note) {
      return note.id == existing.id;
    }));

    final model = NoteModel.fromExisting(
        existing: existing,
        noteColor: existing.color ?? _getRandomColor().toString());

    state[index] = model;

    final indexStorage = notesBox.values.toList().indexOf(notesBox.values
        .toList()
        .firstWhere((element) => element.id == model.id));

    debugPrint('index - $indexStorage');

    await notesBox.deleteAt(indexStorage);
    await notesBox.add(model);

    debugPrint('local - ${notesBox.values.toList().length}');

    state = List.from(state);
  }

  void deleteNote(int id) async {
    final notesBox = await _openBox;

    final index = state.indexOf(state.firstWhere((note) {
      return note.id == id;
    }));
    final notesIndex = notesBox.values.toList().indexOf(state[index]);

    await notesBox.deleteAt(notesIndex);
    await ref.read(notesProvider.notifier).deleteNote(id);
    state.removeAt(index);
    state = List.from(state);
  }

  final List<Color> _predefinedColors = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  Color _getRandomColor() {
    Random random = Random();
    return _predefinedColors[random.nextInt(_predefinedColors.length)];
  }
}

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]) {
    _fetchNotes();
  }

  Future<Box<Note>> get _openBox async {
    return await Hive.openBox<Note>(hiveDirectory2);
  }

  Box<Note> get _box => Hive.box<Note>(hiveDirectory2);

  void _fetchNotes() async {
    final audioFiles = await _listOfAudioFiles();
    final notesBox = await _openBox;
    final notes = notesBox.values.toList();

    final List<Note> voiceNotes = audioFiles.map((element) {
      return Note(
        element.statSync().modified.toIso8601String(),
        id: 0,
        modelID: audioNoteID,
        isCheckBox: false,
      );
    }).toList();

    state = [...state, ...notes, ...voiceNotes];
  }

  void createNewNote(Note note) {
    state = [...state, note];
  }

  Future<void> createNewNotes(List<Note> notes) async {
    if (notes.isEmpty) return;

    final notesBox = await _openBox;

    if (notesBox.values.toList().isNotEmpty) {
      for (int i = 0; i < notes.length; i++) {
        final currentIndex = notes[i];
        final index = notesBox.values.toList().indexOf(notesBox.values
            .toList()
            .firstWhere((element) => element.modelID == currentIndex.modelID));
        if (index != -1) {
          await _box.deleteAt(index);
        }
      }
    }
    await notesBox.addAll(notes);

    state.removeWhere((element) {
      return element.modelID == notes.first.modelID;
    });

    debugPrint('local notes - ${notesBox.values.toList().length}');

    state = [...state, ...notes];
  }

  Future<void> deleteNote(int id) async {
    try {
      final notesBox = _box;

      final index = state.indexOf(state.firstWhere((note) {
        return note.modelID == id;
      }));
      final notesIndex = notesBox.values.toList().indexOf(state[index]);

      await notesBox.deleteAt(notesIndex);
      state.removeAt(index);
      state = List.from(state);
    } on Exception catch (e) {
      state = List.from(state);

      debugPrintStack(stackTrace: (e as StateError).stackTrace);
    }
  }

  Future<List<io.FileSystemEntity>> _listOfAudioFiles() async {
    await AppUtil.createFolderInAppDocDir(audioFolder);
    final directory = (await getApplicationDocumentsDirectory()).path;

    return io.Directory("$directory/$audioFolder/").listSync()
      ..sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));
  }
}
