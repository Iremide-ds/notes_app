import 'dart:math' show Random;
import 'dart:io' as io;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../models/note.dart';
import '../util/constants.dart';

class NotesNotifier extends StateNotifier<List<NoteModel>> {
  NotesNotifier() : super([]) {
    _fetchLocalNotes();
  }

  void _fetchLocalNotes() async {
    final files = await _listOfAudioFiles();

    final List<NoteModel> voiceNotes = files.map((element) {
      return NoteModel(
          title: 'Voice Note',
          id: newNoteID,
          categoryId: 3,
          path: element.uri.toString(),
          notes: [
            Note(
              element.statSync().modified.toIso8601String(),
              id: 1,
              isCheckBox: false,
            )
          ],
          color: _getRandomColor(),
          isAudio: true);
    }).toList();

    state = [...state, ...voiceNotes];
  }

  Future<List<io.FileSystemEntity>> _listOfAudioFiles() async {
    final directory = (await getApplicationDocumentsDirectory()).path;

    return io.Directory("$directory/$audioFolder/").listSync();
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
  void newNote(NoteModel newNote) {
    final temp = NoteModel.fromExisting(
      existing: newNote,
      noteColor: _getRandomColor(),
    );
    state = [...state, temp];
  }

  void saveNote(NoteModel existing) {
    final index = state.indexOf(state.firstWhere((note) {
      return note.id == existing.id;
    }));
    state[index] = NoteModel.fromExisting(
        existing: existing, noteColor: existing.color ?? _getRandomColor());
    state = List.from(state);
  }

  void deleteNote(int id) {
    final index = state.indexOf(state.firstWhere((note) {
      return note.id == id;
    }));
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
