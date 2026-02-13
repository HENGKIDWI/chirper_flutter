import 'package:chirper/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
  late TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initPage();
    _controller = TextEditingController(text: widget.post.content);
  }

  Future<void> _initPage() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    _controller = TextEditingController(text: widget.post.content);
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
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
      appBar: TopBar(title: "Edit Chirp"),
      body: Skeletonizer(
        enabled: isLoading,
        child: Column(
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
              onPressed: updateChirp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 198, 255),
              ),
              child: const Text(
                "Update Chirp",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
