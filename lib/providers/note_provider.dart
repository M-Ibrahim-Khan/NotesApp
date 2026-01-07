import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';

// Takes an instance of FirestoreService
final firestoreServiceProvider = Provider((ref) => FirestoreService());
// Provides a stream of notes from Firestore passed to fileredNotesProvider
final notesProvider = StreamProvider.autoDispose<List<Note>>((ref) {
  return ref.watch(firestoreServiceProvider).getNotes();
});
// Search Query State Provider placed in homescreen
final searchQueryProvider = StateProvider<String>((ref) => '');
// Provides filtered notes based on search query
final filteredNotesProvider = Provider<List<Note>>((ref) {
  final notes = ref.watch(notesProvider).value ?? [];
  final query = ref.watch(searchQueryProvider).toLowerCase();

// if empty Search
  if (query.isEmpty) return notes;

// Filter Search
  return notes.where((note) {
    return note.title.toLowerCase().contains(query) ||
           note.content.toLowerCase().contains(query);
  }).toList();
});