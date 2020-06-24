import 'dart:convert';

import 'package:bibliotek/models/detail.dart';
import 'package:meta/meta.dart';

class StudentDetail extends Detail {
  final String _stream;
  final int _sem;
  final List<dynamic> _issuedBooks;
  final List<dynamic> _passedIssuedBooks;

  const StudentDetail({
    @required String name,
    @required String phNo,
    @required String stream,
    @required int sem,
    @required List<dynamic> issuedBooks,
    @required List<dynamic> passedIssuedBooks,
  })  : this._stream = stream,
        this._sem = sem,
        this._issuedBooks = issuedBooks,
        this._passedIssuedBooks = passedIssuedBooks,
        assert(name != null),
        assert(phNo != null),
        assert(stream != null),
        assert(sem != null),
        assert(issuedBooks != null),
        assert(passedIssuedBooks != null),
        super(name: name, phNo: phNo);

  List<dynamic> get passedIssuedBooks => _passedIssuedBooks;

  List<dynamic> get issuedBooks => _issuedBooks;

  int get sem => _sem;

  String get stream => _stream;

  factory StudentDetail.fromJson(Map<String, dynamic> data) {
    return StudentDetail(
      name: data['name'],
      phNo: data['ph_no'],
      stream: data['stream'],
      sem: data['sem'],
      issuedBooks: data['issued_books'],
      passedIssuedBooks: data['passed_issued_books'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phNo': phNo,
      'stream': stream,
      'sem': sem,
      'issued_books': issuedBooks,
      'passedIssuedBooks': passedIssuedBooks,
    };
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }
}
