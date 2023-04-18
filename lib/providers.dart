import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/categories_notifier.dart';
import 'notifiers/notes_notifier.dart';
import 'models/category.dart';
import 'models/note.dart';

// All App wide providers

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<NoteCategory>>(
        (ref) => CategoriesNotifier());

final notesProvider =
    StateNotifierProvider<NoteNotifier, List<Note>>((ref) => NoteNotifier());

final notesModelProvider =
    StateNotifierProvider<NotesNotifier, List<NoteModel>>((ref) {
  final notifier = ref.read(notesProvider.notifier);
  return NotesNotifier(ref);
});

//TODO: add video provider

final filterProvider = StateProvider<int?>((ref) => null);
