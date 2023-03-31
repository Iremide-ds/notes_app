import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_routes.dart';
import '../../../models/note.dart';
import '../../../providers.dart';

/// A grid of all notes available.
class NotesList extends ConsumerWidget {
  /// Instance of a grid of all notes available.
  const NotesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return SizedBox(
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: notes.length,
          itemBuilder: (ctx, index) {
            return _NoteCard(notes[index], onPressed: () {
              ref.read(notesProvider.notifier).currentNote = notes[index].id;
              Navigator.of(context).pushNamed(AppRouter.existingNoteRoute);
            });
          }),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onPressed;

  const _NoteCard(this.note, {Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        child: Column(children: [
          _NoteHeader(title: note.title),
          _NoteContent(content: note.notes)
        ]),
      ),
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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: content.length,
        itemBuilder: (ctx, index) {
          final note = content[index];

          return Text(note.content);
        });
  }
}
