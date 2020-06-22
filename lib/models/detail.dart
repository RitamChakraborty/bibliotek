import 'dart:convert';

import 'package:meta/meta.dart';

class Detail {
  final String _name;
  final String _phNo;

  const Detail({
    @required String name,
    @required String phNo,
  })  : this._name = name,
        this._phNo = phNo,
        assert(name != null),
        assert(phNo != null);

  String get phNo => _phNo;

  String get name => _name;

  factory Detail.fromJson(Map<String, dynamic> data) {
    return Detail(
      name: data['name'],
      phNo: data['ph_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ph_no': phNo,
    };
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }
}
