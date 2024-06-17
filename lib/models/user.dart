class User {
  final int id;
  String username;
  String email;
  String password;
  String avatar;  

  User({required this.id, required this.username, required this.email, required this.password, required this.avatar});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'avatar': avatar,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      avatar: map['avatar'] ?? 'assets/default_avatar.png',
    );
  }
}
