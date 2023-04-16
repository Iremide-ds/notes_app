import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';

class CategoriesNotifier extends StateNotifier<List<NoteCategory>> {
  CategoriesNotifier()
      : super([
          const NoteCategory(id: 1, name: 'Important'),
          const NoteCategory(id: 2, name: 'To-do'),
          const NoteCategory(id: 3, name: 'Audio'),
        ]);

  /// Add a new category and notify listeners.
  void newCategory(NoteCategory category) {
    // state.add(category);
    state = [...state,category];
  }
}
