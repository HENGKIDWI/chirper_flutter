import 'package:chirper/providers/comment_provider.dart';
import 'package:chirper/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<CommentProvider>().fetchComments(widget.post.id!),
    );
  }

  Future<void> loadComments() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    final data = await db.getCommentsByPost(widget.post.id!);
    if (!mounted) return;
    setState(() {
      comments = data;
      isLoading = false;
    });
  }

  Future<void> addComment() async {
    if (_controller.text.isEmpty) return;

    final comment = Comment(content: _controller.text, postId: widget.post.id!);

    await context.read<CommentProvider>().addComment(comment);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Chirp"),
      body: chirp(),
    );
  }

  Column chirp() {
    return Column(
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
        listKomen(),

        // INPUT COMMENT
        inputKomen(),
      ],
    );
  }

  Expanded listKomen() {
    final commentProvider = context.watch<CommentProvider>();

    final displayList = commentProvider.isLoading
        ? List.generate(5, (_) => Comment(content: "Loading...", postId: 0))
        : commentProvider.comments;

    return Expanded(
      child: Skeletonizer(
        enabled: commentProvider.isLoading,
        child: ListView.builder(
          itemCount: displayList.length,
          itemBuilder: (_, index) {
            final comment = displayList[index];

            return Column(
              children: [
                ListTile(title: Text(comment.content)),
                const Divider(height: 1),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding inputKomen() {
    return Padding(
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
    );
  }
}
