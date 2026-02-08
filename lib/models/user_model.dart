class User {
  final int? id;
  final String username;

  User({this.id, required this.username});

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(id: map['id'], username: map['username']);
  }
}
