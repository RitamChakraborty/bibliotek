import 'dart:convert';

import 'package:meta/meta.dart';

class User {
  final String _id;
  final String _password;
  final bool _isAdmin;
  final Map<String, dynamic> _detail;

  const User({
    @required String id,
    @required String password,
    @required bool isAdmin,
    @required Map<String, dynamic> details,
  })  : this._id = id,
        this._password = password,
        this._isAdmin = isAdmin,
        this._detail = details,
        assert(id != null),
        assert(password != null),
        assert(isAdmin != null);

  String get id => _id;

  String get password => _password;

  bool get isAdmin => _isAdmin;

  Map<String, dynamic> get detail => _detail;

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        password: map['password'],
        isAdmin: map['is_admin'],
        details: map['detail']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'is_admin': isAdmin,
      'detail': detail
    };
  }

  String toRawJson() {
    return json.encode(toJson());
  }
}
