import 'dart:convert';

import 'package:meta/meta.dart';

class Subject {
  String _refId;
  final String _subject;
  final List<dynamic> _books;

  Subject({@required String subject, @required List<dynamic> books})
      : this._subject = subject,
        this._books = books,
        assert(subject != null),
        assert(books != null);

  factory Subject.fromMap({@required Map<String, dynamic> map}) =>
      Subject(subject: map['subject'], books: map['books']);

  factory Subject.fromJson({@required String json}) =>
      Subject.fromMap(map: jsonDecode(json));

  set refId(String value) {
    _refId = value;
  }

  List<dynamic> get books => _books;

  String get subject => _subject;

  String get refId => _refId;

  Map<String, dynamic> get map => {
        'subject': _subject,
        'books': _books,
      };

  String get json => jsonEncode(map);
}
