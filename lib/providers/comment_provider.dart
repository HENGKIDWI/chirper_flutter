import 'package:chirper/database/database_helper.dart';
import 'package:chirper/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Comment> _comments = [];
  bool _isLoading = false;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  Future<void> fetchComments(int postId) async {
    _setLoading(true);

    await Future.delayed(const Duration(seconds: 4));

    _comments = await _db.getCommentsByPost(postId);
    _setLoading(false);
  }

  Future<void> addComment(Comment comment) async {
    _setLoading(true);

    await Future.delayed(const Duration(seconds: 4));

    await _db.insertComment(comment);
    _comments = await _db.getCommentsByPost(comment.postId);

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
