import 'dart:convert';

import 'package:meta/meta.dart';

class User {
  final String _id;
  final String _password;
  final String _name;
  final bool _isAdmin;
  final Map<String, dynamic> _details;

  const User({
    @required String id,
    @required String password,
    @required String name,
    @required bool isAdmin,
    @required Map<String, dynamic> details,
  })  : this._id = id,
        this._password = password,
        this._name = name,
        this._isAdmin = isAdmin,
        this._details = details,
        assert(id != null),
        assert(password != null),
        assert(name != null),
        assert(isAdmin != null);

  String get id => _id;

  String get password => _password;

  String get name => _name;

  bool get isAdmin => _isAdmin;

  Map<String, dynamic> get details => _details;

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        password: map['password'],
        name: map['name'],
        isAdmin: map['is_admin'],
        details: map['details']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'name': name,
      'is_admin': isAdmin,
      'details': details
    };
  }

  String toRawJson() {
    return json.encode(toJson());
  }
}
