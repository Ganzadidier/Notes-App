import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/note_cubit.dart';
import '../../cubit/auth_cubit.dart';
import '../../domain/models/note_model.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get the user ID passed via arguments
    final userId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {
          if (state is NoteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is NoteInitial) {
            // first time: fetch notes
            context.read<NoteCubit>().fetchNotes(userId);
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NoteLoaded) {
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(
                child: Text(
                  "Nothing here yet—tap ➕ to add a note.",
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.text),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showAddEditDialog(context, userId, isEditing: true, note: note);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<NoteCubit>().deleteNote(userId, note.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditDialog(context, userId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, String userId, {bool isEditing = false, NoteModel? note}) {
    final controller = TextEditingController(text: isEditing ? note?.text : "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Edit Note" : "Add Note"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Note Text"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              if (isEditing && note != null) {
                context.read<NoteCubit>().updateNote(userId, note.id, text);
              } else {
                context.read<NoteCubit>().addNote(userId, text);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}