import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/notes_notifier.dart';
import '../../config/app_dimensions.dart';
import '../../providers.dart';
import '../../models/note.dart';

/// Screen to create a new note
class NewNoteScreen extends ConsumerStatefulWidget {
  const NewNoteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends ConsumerState<NewNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<Map<String, dynamic>> _bottomAppBarItems = [];
  final List<TextEditingController> _checkBoxControllers = [];
  final List<bool> _checkBoxValues = [];
  final List<StatefulBuilder> _checkBoxes = [];

  Future<void> _saveNote(NotesNotifier notifier) async {
    if (_titleController.text.isEmpty &&
        _contentController.text.isEmpty &&
        (_checkBoxes.isEmpty || _checkBoxControllers.first.text.isEmpty)) {
      return;
    } else {
      final newID = notifier.newNoteID;
      final List<Note> notes = [];

      if (_checkBoxes.isNotEmpty) {
        for (int i = 0; i < _checkBoxes.length; i++) {
          final value = _checkBoxValues[i];
          final controller = _checkBoxControllers[i];

          notes.add(Note(controller.text,
              id: i, isCheckBox: true, isChecked: value, modelID: newID));
        }
      }

      final allNotes = [
        ...notes,
        Note(_contentController.text,
            id: notes.length, isCheckBox: false, modelID: newID)
      ];

      final notesWatch = ref.read(notesProvider.notifier);
      notesWatch.createNewNotes(allNotes);

      final NoteModel newNote = NoteModel(
          title: _titleController.text,
          id: newID,
          categoryId: 1,
          path: '',
          notes: allNotes.map((e) => e.id).toList(),
          isAudio: false);

      await notifier.newNote(newNote);
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  maxLines: null,
                  minLines: null),
              splashRadius: 0.0,
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

  @override
  void initState() {
    super.initState();
    _initBottomAppBarItems();
  }

  @override
  Widget build(BuildContext context) {
    final notesNotifier = ref.read(notesModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(shape: const CircleBorder()),
            onPressed: () async {
              await _saveNote(notesNotifier);
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Icon(Icons.arrow_back_ios),
          )),
      body: SafeArea(
          child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Title'),
            ),
            // Body here
            Expanded(
              child: SizedBox(
                child: _NoteContent(
                    checkboxes: _checkBoxes,
                    contentController: _contentController),
              ),
            )
          ],
        ),
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
            return LayoutBuilder(
              builder: (ctx, constraints) {
                final size = MediaQuery.of(context).size;

                return TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Content...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  maxLines: null,
                  minLines: (size.height * 0.04).toInt(),
                );
              },
            );
          } else {
            return checkboxes[index];
          }
        });
  }
}
