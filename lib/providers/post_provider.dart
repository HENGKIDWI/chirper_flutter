import 'package:chirper/database/database_helper.dart';
import 'package:chirper/models/post_model.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 4));

    _posts = await _db.getPosts();
    _setLoading(false);
  }

  Future<void> addPost(Post post) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 4));

    await _db.insertPost(post);
    await fetchPosts();
  }

  Future<void> deletePost(int id) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 4));

    await _db.deletePost(id);
    await fetchPosts();
  }

  Future<void> updatePost(Post post) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 4));

    await _db.updatePost(post);

    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      _posts[index] = post;
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
