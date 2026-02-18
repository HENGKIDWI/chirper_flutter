import 'package:chirper/providers/post_provider.dart';
import 'package:chirper/screens/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detail_page.dart';
import '../models/post_model.dart';
import '../widgets/chirp_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../widgets/top_bar.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    Future.microtask(() => context.read<PostProvider>().fetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    return Scaffold(
      appBar: TopBar(title: "Latest Chirps"),
      body: Column(
        children: [
          // INPUT CHIRP
          inputCard(),

          // LIST CHIRP
          Expanded(
            child: Skeletonizer(
              enabled: postProvider.isLoading,
              child: listChirp(context),
            ),
          ),
        ],
      ),
    );
  }

  // INPUT CHIRP
  Padding inputCard() {
    final postProvider = context.watch<PostProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: InputBorder.none,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: postProvider.isLoading
                    ? null
                    : () async {
                        if (_controller.text.isEmpty) return;

                        final post = Post(
                          content: _controller.text,
                          userId: widget.userId,
                        );

                        await postProvider.addPost(post);
                        _controller.clear();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 198, 255),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Chirp'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LIST CHIRP
  Widget listChirp(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    final displayList = postProvider.isLoading
        ? List.generate(
            5,
            (_) => Post(id: 0, content: "Loading content...", userId: 0),
          )
        : postProvider.posts;

    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (_, index) {
        final post = displayList[index];
        return chirpCard(post, context);
      },
    );
  }

  // CHIRP CARD
  ChirpCard chirpCard(Post post, BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    return ChirpCard(
      post: post,
      onTap: postProvider.isLoading
          ? null
          : () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Detailpage(post: post)),
              ).then((_) => postProvider.fetchPosts());
            },
      onEdit: postProvider.isLoading
          ? null
          : () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditPage(post: post)),
              );
              if (result == true) {
                postProvider.fetchPosts();
              }
            },
      onDelete: postProvider.isLoading
          ? null
          : () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => alertDelete(context),
              );

              if (confirm == true) {
                await postProvider.deletePost(post.id!);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chirp berhasil dihapus')),
                );
              }
            },
    );
  }

  // DELETE ALERT DIALOG
  AlertDialog alertDelete(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus Chirp'),
      content: const Text('Apakah kamu yakin ingin menghapus chirp ini?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white),
            backgroundColor: const Color.fromARGB(255, 73, 20, 233),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Hapus', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
