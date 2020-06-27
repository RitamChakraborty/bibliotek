import 'dart:convert';

import 'package:meta/meta.dart';

class IssuedBook {
  String _refId;
  final String _issuedBy;
  final String _issuedTo;
  final String _book;
  final DateTime _issuedOn;
  final DateTime _dueDate;

  IssuedBook(
      {@required String issuedBy,
      @required String issuedTo,
      @required String book,
      @required DateTime issuedOn,
      @required DateTime dueDate})
      : this._issuedBy = issuedBy,
        this._issuedTo = issuedTo,
        this._book = book,
        this._issuedOn = issuedOn,
        this._dueDate = dueDate;

  factory IssuedBook.fromMap({@required Map<String, dynamic> map}) =>
      IssuedBook(
          issuedBy: map['issued_by'],
          issuedTo: map['issued_to'],
          book: map['book'],
          issuedOn: map['issued_on'],
          dueDate: map['due_date']);

  factory IssuedBook.fromJson({@required String json}) =>
      IssuedBook.fromMap(map: jsonDecode(json));

  set refId(String refId) {
    this._refId = refId;
  }

  DateTime get dueDate => _dueDate;

  DateTime get issuedOn => _issuedOn;

  String get book => _book;

  String get issuedTo => _issuedTo;

  String get issuedBy => _issuedBy;

  String get refId => _refId;

  Map<String, dynamic> get map => {
        'issued_by': _issuedBy,
        'issued_to': _issuedTo,
        'book': _book,
        'issued_on': _issuedOn,
        'due_date': _dueDate,
      };

  String get json => jsonEncode(map);
}
