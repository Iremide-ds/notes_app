import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_dimensions.dart';
import '../../config/app_routes.dart';
import '../../providers.dart';
import 'features/note_card.dart';
import 'features/category_list.dart';

/// The first screen of the app that a user can interact with.
class HomePage extends ConsumerWidget {
  /// The first screen of the app that a user can interact with.
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.black38),
            padding: const EdgeInsets.all(AppDimensions.defaultPadding),
            child: const Center(child: Icon(Icons.dashboard)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const CategoriesList(),
            Expanded(
              child: SizedBox(
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: notes.length,
                    itemBuilder: (ctx, index) {
                      return NoteCard(notes[index].id);
                    }),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // TODO: navigate to new note screen
          Navigator.of(context).pushNamed(AppRouter.newNoteRoute);
        },
        child: const Center(child: Icon(Icons.add)),
      ),
    );
  }
}
