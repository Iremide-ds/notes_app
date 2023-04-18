import 'package:hive/hive.dart';

part 'note.g.dart';

/// A collection of [Note]s.
@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int categoryId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String path;

  @HiveField(4)
  final String? color;

  @HiveField(5)
  //TODO: change to list of note IDs then save each note separately
  final List<int> notes;

  @HiveField(6)
  final bool isAudio;

  @HiveField(7)
  final DateTime date = DateTime.now();

  /// Instance of a collection of notes.
  NoteModel(
      {required this.isAudio,
      required this.title,
      required this.id,
      required this.categoryId,
      this.color,
      required this.notes,
      required this.path});

  NoteModel.fromExisting(
      {required NoteModel existing, required String? noteColor})
      : id = existing.id,
        categoryId = existing.categoryId,
        title = existing.title,
        notes = existing.notes,
        isAudio = existing.isAudio,
        path = existing.path,
        color = noteColor;
}

/// A line in a note.
@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final int id;

  @HiveField(01)
  final int modelID;

  @HiveField(2)
  final bool isCheckBox;

  @HiveField(3)
  final bool? isChecked;

  @HiveField(4)
  final String content;

  /// Instance of a line in a note.
  Note(this.content,
      {required this.modelID,
      required this.id,
      required this.isCheckBox,
      this.isChecked});
}
