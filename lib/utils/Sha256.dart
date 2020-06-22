import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

class Sha256 {
  static String convert({@required String string}) {
    List<int> bytes = utf8.encode(string);
    String hash = sha1.convert(bytes).toString();
    return hash;
  }
}
