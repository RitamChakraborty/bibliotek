import 'dart:convert';

import 'package:meta/meta.dart';

class Subject {
  final String _subject;
  final List<String> _books;

  const Subject({
    @required String subject,
    @required List<String> books,
  })  : this._subject = subject,
        this._books = books;

  List<String> get books => _books;

  String get subject => _subject;

  factory Subject.fromJson(Map<String, dynamic> data) {
    return Subject(
      subject: data['subject'],
      books: data['books'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'books': books};
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }
}
