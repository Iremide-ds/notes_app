import 'package:flutter/material.dart';

import '../pages/landing_page/home_page.dart';
import '../pages/note_page/exisitng_note_page.dart';
import '../pages/note_page/new_note_page.dart';
import '../pages/note_page/audio_notes.dart';

/// This manages all of this app's routing.
@immutable
class AppRouter {
  // All routes
  static const String homeRoute = '/';
  static const String existingNoteRoute = '/note';
  static const String newNoteRoute = '/new';
  static const String recordAudio = '/audio';

  /// Routes mapping.
  static final Map<String, Widget Function(BuildContext)> routes = {
    homeRoute: (_) => const HomePage(),
    existingNoteRoute: (_) => const ExistingNoteScreen(),
    newNoteRoute: (_) => const NewNoteScreen(),
    recordAudio: (_) => const SimpleRecorder(),
  };
}