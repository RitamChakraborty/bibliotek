import 'dart:convert';

import 'package:meta/meta.dart';

class User {
  String _refId;
  final String _id;
  final String _password;
  final String _name;
  final bool _isAdmin;
  final List<dynamic> _issuedBooks;

  User(
      {@required String id,
      @required String password,
      @required String name,
      @required bool isAdmin,
      @required List<dynamic> issuedBooks})
      : this._id = id,
        this._password = password,
        this._name = name,
        this._isAdmin = isAdmin,
        this._issuedBooks = issuedBooks,
        assert(id != null),
        assert(password != null),
        assert(name != null),
        assert(isAdmin != null),
        assert(issuedBooks != null);

  factory User.fromMap({@required Map<String, dynamic> map}) => User(
      id: map['id'],
      password: map['password'],
      name: map['name'],
      isAdmin: map['is_admin'],
      issuedBooks: map['issued_books']);

  factory User.fromJson({@required String json}) =>
      User.fromMap(map: jsonDecode(json));

  set refId(String refId) {
    this._refId = refId;
  }

  List<dynamic> get issuedBooks => _issuedBooks;

  bool get isAdmin => _isAdmin;

  String get name => _name;

  String get password => _password;

  String get id => _id;

  String get refId => _refId;

  Map<String, dynamic> get map => {
        'id': _id,
        'password': _password,
        'name': _name,
        'is_admin': _isAdmin,
        'issued_books': _issuedBooks,
      };

  String get json => jsonEncode(map);
}
