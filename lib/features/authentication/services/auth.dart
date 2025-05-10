// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:timetracker/features/authentication/models/authenticated_user.dart';
import 'package:timetracker/features/authentication/services/user_service.dart';
import 'package:timetracker/repository/database.dart';

class UserAuth extends ChangeNotifier {
  bool _signedIn = false;
  List<AuthenticatedUser> _users = [];
  final DatabaseService _databaseService = DatabaseService();
  final UserService _userService = UserService();

  UserAuth() {
    _init();
  }

  Future<void> _init() async {
    _users = await _databaseService.authenticatedUser();
    _signedIn = _users.isNotEmpty;
    notifyListeners();
  }

  /// Whether user has signed in.
  bool get signedIn => _signedIn;

  /// Signs out the current user.
  Future<void> signOut() async {
    await _userService.logOut();
    _signedIn = false;
    notifyListeners();
  }

  /// Signs in a user.
  Future<bool> signIn(String email, String password) async {
    _signedIn = await _userService.logIn(email, password);
    notifyListeners();
    return _signedIn;
  }
}

/// An inherited notifier to host [UserAuth] for the subtree.
class UserAuthScope extends InheritedNotifier<UserAuth> {
  /// Creates a [UserAuthScope].
  const UserAuthScope({
    required UserAuth super.notifier,
    required super.child,
    super.key,
  });

  /// Gets the [UserAuth] above the context.
  static UserAuth of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<UserAuthScope>()!
      .notifier!;
}