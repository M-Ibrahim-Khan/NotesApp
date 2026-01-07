import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/note_model.dart';
import '../../providers/note_provider.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    debugPrint('🟠 AddNote initState');
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    debugPrint('🔴 AddNote dispose');
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🟢 AddNoteScreen build');

    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final note = Note(
                  id: '',
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: DateTime.now(),
                );
                await ref.read(firestoreServiceProvider).addNote(note);
                Navigator.pop(context);
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}

// class AddNoteScreen extends ConsumerWidget {
//   const AddNoteScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final titleController = TextEditingController();
//     final contentController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Note')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 labelText: 'Title',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: contentController,
//               maxLines: 5,
//               decoration: const InputDecoration(
//                 labelText: 'Content',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final note = Note(
//                   id: '',
//                   title: titleController.text,
//                   content: contentController.text,
//                   createdAt: DateTime.now(),
//                 );
//                 await ref.read(firestoreServiceProvider).addNote(note);
//                 Navigator.pop(context);
//               },
//               child: const Text('Save Note'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }