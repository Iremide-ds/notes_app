/// A collection of [Note]s.
class NoteModel {
  final int id, categoryId;
  final String title;
  final List<Note> notes;

  /// Instance of a collection of notes.
  NoteModel({required this.title, required this.id, required this.categoryId, required this.notes});
}

/// A line in a note.
class Note {
  final int id;
  final bool isCheckBox;
  final bool? isChecked;
  final String content;

  /// Instance of a line in a note.
  Note(this.content, {required this.id, required this.isCheckBox, this.isChecked});
}