import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http.exception.dart  ';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authtime;
  bool get isAuth {
    final isAuthenticated = token != null;
    print('isAuth check: $isAuthenticated');
    return isAuthenticated;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      print('token is valid');
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAZnaXQ8nu9QnHI2WkAbmW8WjyXmI-BYiI');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logOut() {
    print('logging out');
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authtime != null) {
      _authtime?.cancel();
      _authtime = null;
    }
    print(
        'Logged out successfully. Token: $_token, User ID: $_userId, Expiry Date: $_expiryDate');
    notifyListeners();
    print(
        'Logged out successfully. Token: $_token, User ID: $_userId, Expiry Date: $_expiryDate');
  }

  void _autoLogout() {
    if (_authtime != null) {
      _authtime?.cancel();
    }
    if (_expiryDate == null) {
      print('Auto logout aborted: Expiry date is null');
      return;
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authtime = Timer(Duration(seconds: timeToExpiry), logOut);
    print('Auto logout scheduled in $timeToExpiry seconds');
  }
}
