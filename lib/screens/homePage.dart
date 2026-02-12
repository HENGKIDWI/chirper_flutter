import 'package:chirper/screens/editPage.dart';
import 'package:flutter/material.dart';
import 'detailPage.dart';
import '../database/database_helper.dart';
import '../models/post_model.dart';
import '../widgets/chirp_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = DatabaseHelper.instance;
  final TextEditingController _controller = TextEditingController();

  List<Post> posts = [];
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() {
      isLoading = true;
    });
    final data = await db.getPosts();
    setState(() {
      posts = data;
      isLoading = false;
    });
  }

  Future<void> addPost() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    final post = Post(content: _controller.text, userId: widget.userId);

    await db.insertPost(post);
    _controller.clear();
    loadPosts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Latest Chirps',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 72, 43, 237),
      ),
      body: Column(
        children: [
          // INPUT CHIRP
          Padding(
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
                      onPressed: addPost,
                      child: const Text('Chirp'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LIST CHIRP
          Expanded(
            child: Skeletonizer(
                enabled: isLoading,
                child: listChirp(context)
            ),
          ),
        ],
      ),
    );
  }

//   ListView listChirp(BuildContext context) {
//     return ListView.builder(
//             itemCount: posts.length,
//             itemBuilder: (_, index) {
//               final post = posts[index];
//             return ChirpCard(
//               post: post,
//               onTap: () async {
//                 await Future.delayed(Duration(seconds: 5));
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => Detailpage(post: post),
//                   ),
//                 ).then((_) => loadPosts());
//               },
//               onEdit: () async {
//                 final result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => EditPage(post: post),
//                   ),
//                 );
//                 if (result == true) loadPosts();
//               },
//               onDelete: () async {
//                 await db.deletePost(post.id!);
//                 loadPosts();
//               },
//             );
//             },
//           );
//   }
// }

ListView listChirp(BuildContext context) {
  final displayList = isLoading
      ? List.generate(5, (_) => Post(content: 'Loading...', userId: 0))
      : posts;

  return ListView.builder(
    itemCount: displayList.length,
    itemBuilder: (_, index) {
      final post = displayList[index];

      return ChirpCard(
        post: post,
        onTap: isLoading
            ? null
            : () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Detailpage(post: post),
            ),
          ).then((_) => loadPosts());
        },
        onEdit: isLoading
            ? null
            : () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditPage(post: post),
            ),
          );
          if (result == true) loadPosts();
        },
        onDelete: isLoading
            ? null
            : () async {
          await db.deletePost(post.id!);
          loadPosts();
        },
      );
    },
  );
}}
