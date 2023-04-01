import 'package:flutter/material.dart';

import '../../config/app_dimensions.dart';
import '../../config/app_routes.dart';
import 'features/category_list.dart';
import 'features/notes_list.dart';

/// The first screen of the app that a user can interact with.
class HomePage extends StatefulWidget {
  /// The first screen of the app that a user can interact with.
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ListLayout layout = ListLayout.grid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        toolbarHeight: AppDimensions.screenHeight * 0.1,
        actions: [
          IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.white24, iconSize: AppDimensions.screenHeight * 0.04),
              onPressed: () {
                setState(() {
                  switch (layout) {
                    case ListLayout.grid:
                      layout = ListLayout.list;
                      break;
                    case ListLayout.list:
                      layout = ListLayout.grid;
                      break;
                  }
                });
              },
              icon: Icon(
                (layout == ListLayout.list) ? Icons.list : Icons.dashboard,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.screenWidth * 0.03),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: AppDimensions.screenWidth * 0.4,
                    child: const Text('My Notes',
                        style: TextStyle(color: Colors.white, fontSize: 80))),
                SizedBox(height: AppDimensions.screenHeight * 0.02),
                const CategoriesList(),
                SizedBox(height: AppDimensions.screenHeight * 0.02),
                NotesList(layout)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            //TODO: show list of options including voice record or noraml note
            Navigator.of(context).pushNamed(AppRouter.newNoteRoute);
          },
          child: const Center(child: Icon(Icons.add))),
    );
  }
}
