import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/notifiers/notes_notifier.dart';

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
  final List<CheckboxListTile> _checkBoxes = [];

  void _saveNote(NotesNotifier notifier) {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      return;
    } else {
      final NoteModel newNote = NoteModel(
          title: _titleController.text,
          id: notifier.newNoteID,
          categoryId: 1,
          notes: [Note(_contentController.text, id: 1, isCheckBox: false)]);

      notifier.newNote(newNote);
    }
  }

  void _newCheckBox() {
    setState(() {
      _checkBoxControllers.add(TextEditingController());
      _checkBoxValues.add(false);
      _checkBoxes.add(CheckboxListTile(
          value: _checkBoxValues[_checkBoxValues.length-1],
          title: TextFormField(),
          onChanged: (newVal) {
            setState(() {
              _checkBoxValues[_checkBoxValues.length-1] = newVal!;
            });
          }));
    });
  }

  void _initBottomAppBarItems() {
    _bottomAppBarItems.addAll([
      {'widget': _CustomIconButton(icon: const Text('B'), onPressed: () {})},
      {'widget': _CustomIconButton(icon: const Text('U'), onPressed: () {})},
      {'widget': _CustomIconButton(icon: const Text('I'), onPressed: () {})},
      {
        'widget': _CustomIconButton(
            icon: const Icon(Icons.check_box), onPressed: _newCheckBox)
      },
      {
        'widget':
            _CustomIconButton(icon: const Icon(Icons.list), onPressed: () {})
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
    final notesNotifier = ref.read(notesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
          leading: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: const CircleBorder()),
        onPressed: () {
          _saveNote(notesNotifier);
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back_ios),
      )),
      body: SafeArea(
          child: Form(
        child: Column(
          children: [
            TextFormField(controller: _titleController),
            // Body here
            Expanded(
                child: SizedBox(
              child: _NoteContent(
                  checkboxes: _checkBoxes,
                  contentController: _contentController),
            ))
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
  final List<CheckboxListTile> checkboxes;
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
