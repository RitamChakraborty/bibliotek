import 'dart:convert';

import 'package:bibliotek/models/detail.dart';
import 'package:meta/meta.dart';

class AdminDetail extends Detail {
  final List<dynamic> _addedBooks;

  const AdminDetail({
    @required String name,
    @required String phNo,
    @required List<dynamic> addedBooks,
  })  : this._addedBooks = addedBooks,
        assert(name != null),
        assert(phNo != null),
        assert(addedBooks != null),
        super(name: name, phNo: phNo);

  List<dynamic> get addedBooks => _addedBooks;

  factory AdminDetail.fromJson(Map<String, dynamic> data) {
    return AdminDetail(
      name: data['name'],
      phNo: data['ph_no'],
      addedBooks: data['added_books'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': super.name,
      'ph_no': super.phNo,
      'added_books': addedBooks,
    };
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }
}
