import 'dart:convert';

class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  User({this.id, required this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      "name": name,
      "email": email,
      "password": password
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"] ??= map["id"],
      name: map["name"] as String,
      email: map["email"] as String,
      password: map["password"] as String
    );
  }
}