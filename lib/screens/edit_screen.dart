import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    debugPrint('🟠 Edit initState called');
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    debugPrint('🔴 Edit dispose called');
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  debugPrint('🟢 EditNoteScreen build');


    final titleController = TextEditingController(text: widget.note.title);
    final contentController = TextEditingController(text: widget.note.content);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await ref.read(firestoreServiceProvider)
                  .deleteNote(widget.note.id);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  final updatedNote = Note(
                    id: widget.note.id,  // keep original id
                    title: titleController.text,
                    content: contentController.text,
                    createdAt: widget.note.createdAt, // keep original time
                  );

                  await ref
                      .read(firestoreServiceProvider)
                      .updateNote(updatedNote);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             _TitleField(controller: titleController),
            const SizedBox(height: 16),
            _ContentField(controller: contentController),
          ],
        ),
      ),
    );
  }
}

class _TitleField extends ConsumerWidget {
  final TextEditingController controller;

  const _TitleField({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🔵 Edit TitleField build');

    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(),
      ),
    );
  }
}


class _ContentField extends ConsumerWidget {
  final TextEditingController controller;

  const _ContentField({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🟣 Edit ContentField build');

    return Expanded(
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: "Note",
          border: OutlineInputBorder(),
        ),
        maxLines: null,
        expands: true,
      ),
    );
  }
}
