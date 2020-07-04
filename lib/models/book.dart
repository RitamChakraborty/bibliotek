import 'dart:convert';

import 'package:meta/meta.dart';

class Book {
  String _refId;
  final String _title;
  final String _author;
  final int _copies;

  Book({@required String title, @required String author, @required int copies})
      : this._title = title,
        this._author = author,
        this._copies = copies,
        assert(title != null),
        assert(author != null),
        assert(copies != null);

  factory Book.fromMap({@required Map<String, dynamic> map}) => Book(
        title: map['title'],
        author: map['author'],
        copies: map['copies'],
      );

  factory Book.fromJson({@required String json}) =>
      Book.fromMap(map: jsonDecode(json));

  set refId(String value) {
    _refId = value;
  }

  int get copies => _copies;

  String get author => _author;

  String get title => _title;

  String get refId => _refId;

  Map<String, dynamic> get map => {
        'title': _title,
        'author': _author,
        'copies': _copies,
      };

  String get json => jsonEncode(map);
}
