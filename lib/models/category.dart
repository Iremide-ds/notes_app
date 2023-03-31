import 'package:flutter/foundation.dart';

@immutable
class NoteCategory {
  final int id;
  final String name;

  const NoteCategory({required this.id, required this.name});
}