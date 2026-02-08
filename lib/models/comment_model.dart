class Comment {
  final int? id;
  String content;
  final int postId;
  final String? createdAt;

  Comment({
    this.id,
    required this.content,
    required this.postId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'post_id': postId,
      'created_at': createdAt,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      content: map['content'],
      postId: map['post_id'],
      createdAt: map['created_at'],
    );
  }
}
