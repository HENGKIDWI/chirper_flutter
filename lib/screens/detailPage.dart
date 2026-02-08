import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class Detailpage extends StatefulWidget {
  final Post post;

  const Detailpage({super.key, required this.post});

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  final db = DatabaseHelper.instance;
  final TextEditingController _controller = TextEditingController();

  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    final data = await db.getCommentsByPost(widget.post.id!);
    setState(() {
      comments = data;
    });
  }

  Future<void> addComment() async {
    if (_controller.text.isEmpty) return;

    final comment = Comment(content: _controller.text, postId: widget.post.id!);

    await db.insertComment(comment);
    _controller.clear();
    loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chirp'),
        backgroundColor: const Color.fromARGB(255, 72, 43, 237),
      ),
      body: Column(
        children: [
          // CHIRP CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.post.content,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),

          const Divider(),

          // COMMENT LIST
          Expanded(
            child: comments.isEmpty
                ? const Center(child: Text('Belum ada komentar'))
                : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (_, index) {
                      final comment = comments[index];
                      return ListTile(title: Text(comment.content));
                    },
                  ),
          ),

          // INPUT COMMENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tulis komentar...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.send), onPressed: addComment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
