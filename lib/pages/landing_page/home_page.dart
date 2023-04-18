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
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );
  ListLayout _layout = ListLayout.grid;
  bool _showOptions = false;

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
              style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  iconSize: AppDimensions.screenHeight * 0.04),
              onPressed: () {
                setState(() {
                  switch (_layout) {
                    case ListLayout.grid:
                      _layout = ListLayout.list;
                      break;
                    case ListLayout.list:
                      _layout = ListLayout.grid;
                      break;
                  }
                });
              },
              icon: Icon(
                (_layout == ListLayout.list) ? Icons.list : Icons.dashboard,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenWidth * 0.03),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: AppDimensions.width1,
                      child: const Text(
                        'My Notes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontSize2,
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimensions.screenHeight * 0.02),
                    const CategoriesList(),
                    SizedBox(height: AppDimensions.screenHeight * 0.02),
                    NotesList(_layout)
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenWidth * 0.03,
                ),
                child: SizedBox(
                  height: AppDimensions.screenHeight,
                  width: AppDimensions.screenWidth,
                  child: const Center(
                    child: Text(
                      'Coming Soon!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimensions.fontSize2,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: _showOptions,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.padding3),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    setState(() {
                      _showOptions = !_showOptions;
                    });
                    Navigator.of(context).pushNamed(AppRouter.recordAudio);
                  },
                  child: const Icon(Icons.mic),
                ),
              ),
            ),
            Visibility(
                visible: _showOptions,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: AppDimensions.padding3,
                      bottom: AppDimensions.defaultPadding),
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () {
                      setState(() {
                        _showOptions = !_showOptions;
                      });
                      Navigator.of(context).pushNamed(AppRouter.newNoteRoute);
                    },
                    child: const Icon(Icons.create),
                  ),
                )),
            FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  setState(() {
                    _showOptions = !_showOptions;
                  });
                },
                child: const Center(child: Icon(Icons.add))),
          ],
        ),
      ),
    );
  }
}
