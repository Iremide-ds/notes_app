# V Notes
### An offline mobile app for taking notes and recording audio.

## Features
* Voice notes
* Text notes

## Upcoming features
* Checkbox notes [beta]
* Video notes [coming soon]

### Libraries & Tools Used
* State management with [Riverpod](https://pub.dev/packages/flutter_riverpod)
* Local database management with [Hive](https://pub.dev/packages/hive)
* Audio recording, playing and svaing with [flutter_sound](https://pub.dev/packages/flutter_sound) and [audio_session](https://pub.dev/packages/audio_session)
* Local storage management with [path_provider](https://pub.dev/packages/path_provider)
* Date formatting with [intl](https://pub.dev/packages/intl)
* Code generation using [build_runner](https://pub.dev/packages/build_runner) and [hive_generator](https://pub.dev/packages/hive_generator)

## How to Setup
**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/Iremide-ds/notes_app.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

This project uses `hive_generator` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```

## Hide Generated Files

In-order to hide generated files, navigate to `Android Studio` -> `Preferences` -> `Editor` -> `File Types` and paste the below lines under `ignore files and folders` section:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

In Visual Studio Code, navigate to `Preferences` -> `Settings` and search for `Files:Exclude`. Add the following patterns:
```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```
### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- config/
|- models/
|- notifiers/
|- pages/
|- utils/
|- main.dart
|- providers.dart
```
Now, lets dive into the lib folder which has the main code for the application.

```
1- config - All application level configurations including themes, routes and dimensins are defined in this directory with-in their respective files.
2- models - Contains the data layer of this project. The models are grouped into files for example all models concerned with notes go into the note model file as different classes.
3- notifiers - Contains riverpod state notifiers for state-management. 
4- pages — Contains all the ui of your project, contains sub directory for each screen.
5- util — Contains the utilities/common functions of the application. All the application level constants will/should be defined in this directory with-in a file named constants.dart.
6- main.dart — This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
7- providers.dart — This file contains all the providers for the application.
```

### Config

This directory contains all the application level constants. A separate file is created for each type as shown in example below:

```
config/
|- app_theme.dart
|- app_dimensions.dart
|- app_routes.dart
```

### Models

All the models of the application reside in this directory.

```
data/
|- category.dart
|- note.dart
|- note.g.dart
```

### Notifiers

The store is where all your application state lives in flutter. The Store is basically a widget that stands at the top of the widget tree and passes it's data down using special methods. In-case of multiple stores, a separate folder for each store is created as shown in the example below:

```
notifiers/
    |- categories_notifier.dart
    |- notes_notifier.dart
```

### Pages

This directory contains all the ui of your application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. All the screen specific widgets will be placed in `widgets` directory as shown in the example below:

```
pages/
|- landing_page
   |- home_page.dart
   |- features
      |- category_list.dart
      |- notes_list.dart
```

### Utils

Contains the common file(s) and utilities used in a project. The folder structure is as follows: 

```
util/
   |- assets_manager.dart
   |- constants.dart
```

### Providers

This file contains all the routes for your application.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/categories_notifier.dart';
import 'notifiers/notes_notifier.dart';
import 'models/category.dart';
import 'models/note.dart';

// All App wide providers

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<NoteCategory>>(
        (ref) => CategoriesNotifier());

final notesProvider =
    StateNotifierProvider<NoteNotifier, List<Note>>((ref) => NoteNotifier());

final notesModelProvider =
    StateNotifierProvider<NotesNotifier, List<NoteModel>>((ref) {
  final notifier = ref.read(notesProvider.notifier);
  return NotesNotifier(ref);
});

//TODO: add video provider

final filterProvider = StateProvider<int?>((ref) => null);

```

### Main

This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(NoteAdapter());

  /// Enforce portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

// TODO: Complete readme.md file
/// This is the root of the entire app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V Notes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routes: AppRouter.routes,
    );
  }
}

```
## Conclusion

I will be happy to answer any questions that you may have on this approach, and if you want to lend a hand with the project then please feel free to submit an issue and/or pull request 🙂
