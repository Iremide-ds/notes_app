import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note.dart';

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

  /// Get next note ID.
  int get newNoteID {
    int highestId = 0;

    for (var element in state) {
      if (element.id > highestId) {
        highestId = element.id;
      }
    }
    return (highestId+1);
  }

  /// Add a new note.
  void newNote(NoteModel newNote) {
    state = [...state, newNote];
  }
}
