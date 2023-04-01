import 'dart:math' show Random;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note.dart';
import '../pages/landing_page/features/notes_list.dart' show ListLayout;

class NotesNotifier extends StateNotifier<List<NoteModel>> {
  NotesNotifier()
      : super([
          NoteModel(
              id: 1,
              categoryId: 1,
              notes: [
                Note('Remember to wash the rice!', id: 1, isCheckBox: false)
              ],
              title: 'Another note'),
          NoteModel(
              id: 2,
              categoryId: 2,
              notes: [
                Note('Remember to wash the rice and forget',
                    id: 1, isCheckBox: false)
              ],
              title: 'Our note'),
          NoteModel(
              id: 3,
              categoryId: 2,
              notes: [Note('Remember to be awake', id: 1, isCheckBox: false)],
              title: 'That note'),
          NoteModel(
              id: 4,
              categoryId: 1,
              notes: [Note('I want to be ', id: 1, isCheckBox: false)],
              title: 'This note'),
          NoteModel(
              id: 5,
              categoryId: 1,
              notes: [Note('Random text!!!!!!!', id: 1, isCheckBox: false)],
              title: 'A note')
        ]);

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
