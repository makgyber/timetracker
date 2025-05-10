import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetracker/features/authentication/models/authenticated_user.dart';
import 'package:timetracker/features/authentication/services/auth_service.dart';
import 'package:timetracker/repository/database.dart';


class UserService {
  final DatabaseService db = DatabaseService();
  final AuthService authService = AuthService();

  Future<bool> logIn(String email, String password) async {

    String? _token = await authService.getToken(email, password);

    if (_token == null) {
      return false;
    }

    AuthenticatedUser? user  = await authService.getUser(_token!);
    if (user == null) {
      return false;
    }

    await db.insertAuthenticatedUser(user);
    return true;
  }

  Future<void> logOut() async {
    var users = await db.authenticatedUser();
    for(final user in users) {
      debugPrint(user.toString());
    }

    await db.deleteAllAuthenticatedUsers();
  }
}

final userServiceProvider = Provider<UserService>((ref) => UserService());