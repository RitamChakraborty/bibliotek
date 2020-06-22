import 'dart:convert';

import 'package:meta/meta.dart';

class IssuedBook {
  final String _issuedTo;
  final String _issuedBy;
  final DateTime _issueDate;
  final DateTime _dueDate;
  final bool _submitted;

  const IssuedBook({
    @required String issuedTo,
    @required String issuedBy,
    @required DateTime issueDate,
    @required DateTime dueDate,
    @required bool submitted,
  })  : this._issuedTo = issuedTo,
        this._issuedBy = issuedBy,
        this._issueDate = issueDate,
        this._dueDate = dueDate,
        this._submitted = submitted,
        assert(issuedTo != null),
        assert(issuedBy != null),
        assert(issueDate != null),
        assert(dueDate != null),
        assert(submitted != null);

  bool get submitted => _submitted;

  DateTime get dueDate => _dueDate;

  DateTime get issueDate => _issueDate;

  String get issuedBy => _issuedBy;

  String get issuedTo => _issuedTo;

  factory IssuedBook.fromJson(Map<String, dynamic> data) {
    return IssuedBook(
      issuedTo: data['issued_to'],
      issuedBy: data['issued_by'],
      issueDate: data['issue_date'],
      dueDate: data['due_date'],
      submitted: data['submitted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'issued_to': issuedTo,
      'issued_by': issuedBy,
      'issue_date': issueDate,
      'due_date': dueDate,
      'submitted': submitted,
    };
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }
}
