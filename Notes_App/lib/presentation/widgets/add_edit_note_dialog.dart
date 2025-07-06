import 'package:flutter/material.dart';
import '../../domain/models/note_model.dart';

class AddEditNoteDialog extends StatelessWidget {
  final Function(String) onSave;
  final NoteModel? note;

  const AddEditNoteDialog({
    super.key,
    required this.onSave,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: note?.text ?? '');

    return AlertDialog(
      title: Text(note == null ? 'Add Note' : 'Edit Note'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Note'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              onSave(controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}