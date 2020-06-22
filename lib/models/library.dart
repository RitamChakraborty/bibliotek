import 'dart:convert';

import 'package:meta/meta.dart';

class Library {
  final String _book;
  final int _copies;

  const Library({
    @required String book,
    int copies,
  })  : this._book = book,
        this._copies = copies;

  int get copies => _copies;

  String get book => _book;

  factory Library.fromJson(Map<String, dynamic> data) {
    return Library(
      book: data['book'],
      copies: data['copies'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'copies': copies,
    };
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }
}
