import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

class Sha256 {
  String convert({@required String string}) {
    List<int> bytes = utf8.encode(string);
    String hash = sha256.convert(bytes).toString();
    return hash;
  }
}
