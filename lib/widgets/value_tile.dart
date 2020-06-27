import 'package:flutter/material.dart';

class ValueTile extends StatelessWidget {
  final String _label;
  final String _value;

  const ValueTile({@required String label, @required String value})
      : this._label = label,
        this._value = value,
        assert(label != null),
        assert(value != null);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_label),
      trailing: Text(_value),
    );
  }
}
