import 'package:flutter/material.dart';

import 'package:notes_app/pages/landing_page/features/notes_list.dart';

import '../../config/app_dimensions.dart';
import '../../config/app_routes.dart';
import 'features/category_list.dart';

/// The first screen of the app that a user can interact with.
class HomePage extends StatelessWidget {
  /// The first screen of the app that a user can interact with.
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: const SafeArea(
        child:
            Column(children: [CategoriesList(), Expanded(child: NotesList())]),
      ),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRouter.newNoteRoute);
          },
          child: const Center(child: Icon(Icons.add))),
    );
  }
}
