import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note.dart';
import '../../../providers.dart';

class NoteCard extends ConsumerWidget {
  final int noteId;

  const NoteCard(this.noteId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref
        .watch(notesProvider)
        .firstWhere((noteModel) => noteModel.id == noteId);

    return Card(
      child: Column(children: [
        _NoteHeader(title: note.title),
        _NoteContent(content: note.notes)
      ]),
    );
  }
}

class _NoteHeader extends StatelessWidget {
  final String title;

  const _NoteHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(title), const Icon(Icons.favorite)],
    );
  }
}

class _NoteContent extends StatelessWidget {
  final List<Note> content;

  const _NoteContent({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(shrinkWrap: true, itemCount: content.length, itemBuilder: (ctx, index) {
      final note = content[index];

      return Text(note.content);
    });
  }
}
