import 'package:timetracker/features/authentication/models/token.dart';
import 'package:timetracker/features/authentication/models/user.dart';

class AuthenticatedUser {
  final int id;
  final String name;
  final String email;
  final String token;

  AuthenticatedUser({required this.id, required this.name, required this.email,  required this.token});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token
    };
  }

  factory AuthenticatedUser.fromMap(Map<String, dynamic> map) {
    return AuthenticatedUser(
      id: map['id'].toInt(),
      name: map['name'].toString(),
      email: map['email'].toString(),
      token: map['token'].toString()
    );
  }
}