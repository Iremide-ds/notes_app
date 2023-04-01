import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/categories_notifier.dart';
import 'notifiers/notes_notifier.dart';
import 'models/category.dart';
import 'models/note.dart' show NoteModel;

// All App wide providers

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<NoteCategory>>(
        (ref) => CategoriesNotifier());

final notesProvider = StateNotifierProvider<NotesNotifier, List<NoteModel>>(
    (ref) => NotesNotifier());

final filterProvider = StateProvider<int?>((ref) => null);