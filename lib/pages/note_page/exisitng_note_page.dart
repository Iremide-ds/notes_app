import 'dart:math' show Random;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/notes_notifier.dart';
import '../../config/app_dimensions.dart';
import '../../providers.dart';
import '../../models/note.dart';

class ExistingNoteScreen extends ConsumerStatefulWidget {
  const ExistingNoteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ExistingNoteScreen> createState() => _ExistingNoteScreenState();
}

class _ExistingNoteScreenState extends ConsumerState<ExistingNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<Map<String, dynamic>> _bottomAppBarItems = [];
  final List<TextEditingController> _checkBoxControllers = [];
  final List<bool> _checkBoxValues = [];
  final List<StatefulBuilder> _checkBoxes = [];

  bool _isLoading = true;

  final List<Color> _predefinedColors = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  Color _getRandomColor() {
    Random random = Random();
    return _predefinedColors[random.nextInt(_predefinedColors.length)];
  }

  Future<void> _saveNote(NotesNotifier notifier) async {
    if (_titleController.text.isEmpty &&
        _contentController.text.isEmpty &&
        (_checkBoxes.isEmpty || _checkBoxControllers.first.text.isEmpty)) {
      notifier.deleteNote(notifier.currentNote);
      return;
    } else {
      final notes = ref.read(notesModelProvider);

      final currentNote = notes.firstWhere((note) {
        return note.id == notifier.currentNote;
      });
      final List<Note> newNotes = [];

      if (_checkBoxes.isNotEmpty) {
        for (int i = 0; i < _checkBoxes.length; i++) {
          final value = _checkBoxValues[i];
          final controller = _checkBoxControllers[i];

          newNotes.add(Note(controller.text,
              id: i,
              isCheckBox: true,
              isChecked: value,
              modelID: notifier.currentNote));
        }
      }

      final allNotes = [
        ...newNotes,
        Note(_contentController.text,
            id: notes.length, isCheckBox: false, modelID: notifier.currentNote)
      ];

      final notesWatch = ref.read(notesProvider.notifier);
      await notesWatch.createNewNotes(allNotes);

      final NoteModel editedNote = NoteModel(
          title: _titleController.text,
          id: notifier.currentNote,
          categoryId: currentNote.categoryId,
          color: currentNote.color,
          path: '',
          notes: allNotes.map((e) => e.id).toList(),
          isAudio: false);

      notifier.saveNote(editedNote);
    }
  }

  void _newCheckBox() {
    final TextEditingController controller = TextEditingController();

    setState(() {
      _checkBoxControllers.add(controller);
      _checkBoxValues.add(false);
      final currentIndex = _checkBoxControllers.indexOf(controller);
      _checkBoxes.add(StatefulBuilder(
        builder: (context, setState) {
          return CheckboxListTile(
              autofocus: false,
              dense: true,
              value: _checkBoxValues[currentIndex],
              selected: _checkBoxValues[currentIndex],
              title: TextFormField(
                  controller:
                      _checkBoxControllers[_checkBoxControllers.length - 1],
                  maxLines: null,
                  minLines: null),
              onChanged: (newVal) {
                setState(() {
                  _checkBoxValues[currentIndex] = newVal!;
                });
              });
        },
      ));
    });
  }

  void _addBullet() {
    //TODO: add bullet before start of the sentence nearest to a full stop
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Coming soon!')));
  }

  void _initBottomAppBarItems() {
    _bottomAppBarItems.addAll([
      {
        'widget': _CustomIconButton(
            icon: const Icon(Icons.check_box), onPressed: _newCheckBox)
      },
      {
        'widget': _CustomIconButton(
            icon: const Icon(Icons.list), onPressed: _addBullet)
      },
    ]);
  }

  void _getNote() {
    final notes = ref.read(notesModelProvider);
    final notesNotifier = ref.read(notesModelProvider.notifier);

    final currentNote = notes.firstWhere((note) {
      return note.id == notesNotifier.currentNote;
    });

    setState(() {
      _titleController.text = currentNote.title;
    });

    _getLines(currentNote);

    setState(() {
      _isLoading = false;
    });
  }

  void _getLines(NoteModel noteModel) {
    final notes = ref
        .read(notesProvider)
        .where((element) => element.modelID == noteModel.id);
    for (Note note in notes) {
      final TextEditingController controller =
          TextEditingController(text: note.content);

      setState(() {
        if (note.isCheckBox) {
          _checkBoxControllers.add(controller);
          _checkBoxValues.add(note.isChecked!);

          final currentIndex = _checkBoxControllers.indexOf(controller);

          _checkBoxes.add(StatefulBuilder(
            builder: (context, setState) {
              return CheckboxListTile(
                  autofocus: false,
                  dense: true,
                  value: _checkBoxValues[currentIndex],
                  selected: _checkBoxValues[currentIndex],
                  title: TextFormField(
                      controller: _checkBoxControllers[currentIndex],
                      maxLines: null,
                      minLines: null),
                  onChanged: (newVal) {
                    setState(() {
                      _checkBoxValues[currentIndex] = newVal!;
                    });
                  });
            },
          ));
        } else {
          _contentController.text = note.content;
        }
      });
    }
  }

  Color? _getColor(String? colorString) {
    if (colorString == null) return null;
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  @override
  void initState() {
    super.initState();
    _initBottomAppBarItems();
    _getNote();
  }

  @override
  Widget build(BuildContext context) {
    final notesNotifier = ref.read(notesModelProvider.notifier);
    final notes = ref.read(notesModelProvider);

    final currentNote = notes.firstWhere((note) {
      return note.id == notesNotifier.currentNote;
    });

    return Scaffold(
      backgroundColor: _getColor(currentNote.color) ?? _getRandomColor(),
      appBar: AppBar(
          elevation: 0.0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          leading: ElevatedButton(
              style: ElevatedButton.styleFrom(shape: const CircleBorder()),
              onPressed: () {
                _saveNote(notesNotifier).then((_) {
                  Navigator.of(context).pop();
                });
              },
              child: const Icon(Icons.arrow_back_ios))),
      body: SafeArea(
          child: Form(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(children: [
                TextFormField(controller: _titleController),
                // Body here
                Expanded(
                    child: SizedBox(
                        child: _NoteContent(
                            checkboxes: _checkBoxes,
                            contentController: _contentController)))
              ]),
      )),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black26,
        ),
        width: AppDimensions.screenWidth,
        child: Row(
          children: _bottomAppBarItems.map((e) {
            return _CustomIconButton(icon: e['widget']!, onPressed: () {});
          }).toList(),
        ),
      ),
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final Widget icon;
  final Function onPressed;

  const _CustomIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          onPressed();
        },
        icon: icon);
  }
}

class _NoteContent extends StatelessWidget {
  final List<StatefulBuilder> checkboxes;
  final TextEditingController contentController;

  const _NoteContent(
      {Key? key, required this.checkboxes, required this.contentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: checkboxes.length + 1,
        itemBuilder: (ctx, index) {
          if (index == checkboxes.length) {
            return TextFormField(
              controller: contentController,
              maxLines: null,
              minLines: null,
            );
          } else {
            return checkboxes[index];
          }
        });
  }
}
