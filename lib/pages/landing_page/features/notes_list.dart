import 'dart:math' show Random;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_dimensions.dart';
import '../../../config/app_routes.dart';
import '../../../models/note.dart';
import '../../../providers.dart';

/// Layout types.
enum ListLayout { grid, list }

/// A grid of all notes available.
class NotesList extends ConsumerWidget {
  final ListLayout layout;

  /// Instance of a grid of all notes available.
  const NotesList(this.layout, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    final notes = (filter == null)
        ? ref.watch(notesProvider)
        : ref.watch(notesProvider).where((note) {
            return note.categoryId == filter;
          }).toList();

    switch (layout) {
      case ListLayout.grid:
        return SizedBox(
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: AppDimensions.childAspectRatio),
              itemCount: notes.length,
              itemBuilder: (ctx, index) {
                return _NoteCard(notes[index], secondColumn: (index % 2 == 0),
                    onPressed: () {
                  ref.read(notesProvider.notifier).currentNote =
                      notes[index].id;
                  Navigator.of(context).pushNamed(AppRouter.existingNoteRoute);
                });
              }),
        );
      case ListLayout.list:
        return SizedBox(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (ctx, index) {
                return _NoteCard(notes[index], secondColumn: (index % 2 == 0),
                    onPressed: () {
                  ref.read(notesProvider.notifier).currentNote =
                      notes[index].id;
                  Navigator.of(context).pushNamed(AppRouter.existingNoteRoute);
                });
              }),
        );
    }
  }
}

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onPressed;
  final bool secondColumn;

  _NoteCard(this.note,
      {Key? key, required this.onPressed, required this.secondColumn})
      : super(key: key);

  final List<Color> _predefinedColors = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pinkAccent,
    Colors.teal
  ];

  Color _getRandomColor() {
    Random random = Random();
    return _predefinedColors[random.nextInt(_predefinedColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        color: note.color ?? _getRandomColor(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: secondColumn
                    ? Radius.zero
                    : const Radius.circular(AppDimensions.borderRadius1),
                topRight: const Radius.circular(AppDimensions.borderRadius1),
                bottomRight: secondColumn
                    ? const Radius.circular(AppDimensions.borderRadius1)
                    : Radius.zero,
                bottomLeft:
                    const Radius.circular(AppDimensions.borderRadius1))),
        // margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.padding1),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _NoteHeader(title: note.title),
            _NoteContent(content: note.notes),
          ]),
        ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: AppDimensions.screenWidth * 0.2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            )),
        IconButton(
            onPressed: () {
              //TODO: show dropdown menu to allow delete
            },
            icon: const Icon(Icons.more_vert))
      ],
    );
  }
}

class _NoteContent extends StatelessWidget {
  final List<Note> content;

  const _NoteContent({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              content.first.content,
              overflow: TextOverflow.ellipsis,
            )));
  }
}
