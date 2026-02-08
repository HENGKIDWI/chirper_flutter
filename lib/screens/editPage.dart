import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/post_model.dart';

class EditPage extends StatefulWidget {
  final Post post;

  const EditPage({super.key, required this.post});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final db = DatabaseHelper.instance;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.post.content);
  }

  Future<void> updateChirp() async {
    if (_controller.text.isEmpty) return;

    final updatedPost = Post(
      id: widget.post.id,
      content: _controller.text,
      userId: widget.post.userId,
    );

    await db.updatePost(updatedPost);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Chirp'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: updateChirp),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: 5,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }
}
