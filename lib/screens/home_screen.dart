import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practical_notes_app/screens/edit_screen.dart';
import '../../providers/note_provider.dart';
import '../../providers/auth_provider.dart';
import 'add_note_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🟢 Home Screen build');

    return Scaffold(
      appBar: const _HomeAppBar(),
      body: const _NotesBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddNoteScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🔵 Home AppBar build');

    return AppBar(
      title: const Text('QuickNotes'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              hintText: 'Search notes...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => ref.read(authRepositoryProvider).signOut(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);
}

class _NotesBody extends ConsumerWidget {
  const _NotesBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🟣 Home Body build');

    final notesAsync = ref.watch(notesProvider);

    return notesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (_) => const _FilteredNotesList(),
    );
  }
}

class _FilteredNotesList extends ConsumerWidget {
  const _FilteredNotesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🟡 Home FilteredNotesList build');

    final filteredNotes = ref.watch(filteredNotesProvider);

    if (filteredNotes.isEmpty) {
      return const Center(child: Text('No notes yet!'));
    }

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(
            note.content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditNoteScreen(note: note),
              ),
            );
          },
        );
      },
    );
  }
}



// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final filteredNotes = ref.watch(filteredNotesProvider);
//     final notesAsync = ref.watch(notesProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QuickNotes'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) {
//                   ref.read(searchQueryProvider.notifier).state = value;
//                   debugPrint('Called Search Query');
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search notes...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => ref.read(authRepositoryProvider).signOut(),
//           ),
//         ],
//       ),
//       body: notesAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, _) => Center(child: Text(err.toString())),
//         data: (notes) => notes.isEmpty
//             ? const Center(child: Text('No notes yet!'))
//             : ListView.builder(
//                 itemCount: filteredNotes.length,
//                 itemBuilder: (context, index) {
//                   final note = filteredNotes[index];
//                   return ListTile(
//                     title: Text(note.title),
//                     subtitle: Text(
//                       note.content,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => EditNoteScreen(note: note),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AddNoteScreen()),
//         ),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
