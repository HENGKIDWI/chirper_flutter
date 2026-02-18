import 'package:chirper/providers/post_provider.dart';
import 'package:chirper/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../models/post_model.dart';

class EditPage extends StatefulWidget {
  final Post post;

  const EditPage({super.key, required this.post});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _controller;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.post.content);
  }

  Future<void> updateChirp() async {
    if (_controller.text.isEmpty) return;

    setState(() => isSubmitting = true);

    final updatedPost = Post(
      id: widget.post.id,
      content: _controller.text,
      userId: widget.post.userId,
    );

    await context.read<PostProvider>().updatePost(updatedPost);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Edit Chirp"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
            onPressed: isSubmitting ? null : updateChirp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 5, 198, 255),
            ),
            child: isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Update Chirp",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
