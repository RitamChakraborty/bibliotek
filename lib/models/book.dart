import 'dart:convert';

import 'package:meta/meta.dart';

class Book {
  final String _bookName;
  final String _authorName;
  final String _subject;

  const Book({
    @required String bookName,
    @required String authorName,
    @required String subject,
  })  : this._bookName = bookName,
        this._authorName = authorName,
        this._subject = subject,
        assert(bookName != null),
        assert(authorName != null),
        assert(subject != null);

  String get subject {
    return _subject;
  }

  String get author {
    return _authorName;
  }

  String get bookName {
    return _bookName;
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      bookName: map['bookName'],
      authorName: map['author'],
      subject: map['subject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookName': bookName,
      'author': author,
      'subject': subject,
    };
  }

  String toRawJson() {
    return json.encode(toJson());
  }
}
