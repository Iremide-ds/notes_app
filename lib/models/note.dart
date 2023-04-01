import 'package:flutter/material.dart';

/// A collection of [Note]s.
class NoteModel {
  final int id, categoryId;
  final String title;
  final Color? color;
  final List<Note> notes;

  /// Instance of a collection of notes.
  NoteModel(
      {required this.title,
      required this.id,
      required this.categoryId,
      this.color,
      required this.notes});

  NoteModel.fromExisting(
      {required NoteModel existing, required Color noteColor})
      : id = existing.id,
        categoryId = existing.categoryId,
        title = existing.title,
        notes = existing.notes,
        color = noteColor;
}

/// A line in a note.
class Note {
  final int id;
  final bool isCheckBox;
  final bool? isChecked;
  final String content;

  /// Instance of a line in a note.
  Note(this.content,
      {required this.id, required this.isCheckBox, this.isChecked});
}
