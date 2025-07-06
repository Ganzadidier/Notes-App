import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/note_repository.dart';
import '../domain/models/note_model.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteModel> notes;

  NoteLoaded(this.notes);
}

class NoteError extends NoteState {
  final String message;

  NoteError(this.message);
}

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository _noteRepository;

  NoteCubit(this._noteRepository) : super(NoteInitial());

  Future<void> fetchNotes(String userId) async {
    try {
      emit(NoteLoading());
      final notes = await _noteRepository.fetchNotes(userId);
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError('Failed to load notes'));
    }
  }

  Future<void> addNote(String userId, String text) async {
    try {
      await _noteRepository.addNote(userId, text);
      await fetchNotes(userId);
    } catch (e) {
      emit(NoteError('Failed to add note'));
    }
  }

  Future<void> updateNote(String userId, String noteId, String text) async {
    try {
      await _noteRepository.updateNote(userId, noteId, text);
      await fetchNotes(userId);
    } catch (e) {
      emit(NoteError('Failed to update note'));
    }
  }

  Future<void> deleteNote(String userId, String noteId) async {
    try {
      await _noteRepository.deleteNote(userId, noteId);
      await fetchNotes(userId);
    } catch (e) {
      emit(NoteError('Failed to delete note'));
    }
  }
}
