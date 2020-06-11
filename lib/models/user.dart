import 'dart:convert';

import 'package:meta/meta.dart';

class User {
  final String _id;
  final String _name;

  const User({
    @required String id,
    @required String name,
  })  : this._id = id,
        this._name = name,
        assert(id != null),
        assert(name != null);

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  factory User.formJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  String toRawJson() {
    return json.encode(toJson());
  }
}
