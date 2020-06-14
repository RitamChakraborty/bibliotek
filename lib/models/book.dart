import 'dart:convert';

import 'package:meta/meta.dart';

class Book {
  final String _bookName;
  final String _authorName;
  final String _subjectName;

  const Book({
    @required String bookName,
    @required String authorName,
    @required String subjectName,
  })  : this._bookName = bookName,
        this._authorName = authorName,
        this._subjectName = subjectName,
        assert(bookName != null),
        assert(authorName != null),
        assert(subjectName != null);

  String get subject {
    return _subjectName;
  }

  String get authorName {
    return _authorName;
  }

  String get bookName {
    return _bookName;
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      bookName: map['book_name'],
      authorName: map['author_name'],
      subjectName: map['subject_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_name': bookName,
      'author_name': authorName,
      'subject_name': subject,
    };
  }

  String toRawJson() {
    return json.encode(toJson());
  }
}
