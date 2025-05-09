import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:timetracker/features/authentication/models/authenticated_user.dart';
import 'package:timetracker/features/authentication/models/token.dart';
import 'package:timetracker/features/authentication/models/user.dart';

class AuthService {

  bool _isLoggedIn = true;

  bool get isLoggedIn => _isLoggedIn;

  Future<AuthenticatedUser?> login(String email, String password) async {

    return  await getUser("33|qdz9s2kwiMmgus6ZlYR3EoICRj0pN0ahm81qYEppeef22399").then((onValue)=>onValue);

  }

  Future<String?> getToken(String email, String password) async {
    String url = "https://topbestsystems.com/api/sanctum/token";
    try {
      final Response response = await post(Uri.parse(url), body: {
        "email": email,
        "password": password,
        "device_name": "mobile"
      });
      debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  Future<AuthenticatedUser?> getUser(String token) async {
    String url = "https://topbestsystems.com/api/user";
    try {
      final Response response = await get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });
      debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        var user = User.fromJson(json.decode(response.body));
        return AuthenticatedUser(
            id: user.id,
            name: user.name,
            email: user.email,
            token: token
        );
      }
    }catch(e){
      return null;
    }
    return null;
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
