class Post {
  final int? id;
  String content; // mutable (buat edit)
  final int userId;
  final String? createdAt;

  Post({this.id, required this.content, required this.userId, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'user_id': userId,
      'created_at': createdAt,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      content: map['content'],
      userId: map['user_id'],
      createdAt: map['created_at'],
    );
  }
}
