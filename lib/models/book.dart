import 'dart:convert';

import 'package:meta/meta.dart';

class Book {
  final String _title;
  final String _author;
  final String _subject;
  final String _publisher;

  const Book(
      {@required String title,
      @required String author,
      @required String subject,
      @required String publisher})
      : this._title = title,
        this._author = author,
        this._subject = subject,
        this._publisher = publisher,
        assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(publisher != null);

  String get title => _title;

  String get author => _author;

  String get subject => _subject;

  String get publisher => _publisher;

  factory Book.fromJson(Map<String, dynamic> data) {
    return Book(
      title: data['title'],
      author: data['author_name'],
      subject: data['subject_name'],
      publisher: data['publisher_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'subject': subject,
      'publisher': publisher,
    };
  }

  String toRawJson() {
    return json.encode(toJson());
  }
}
