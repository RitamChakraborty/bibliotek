import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget _child;

  const CustomCard({@required Widget child})
      : this._child = child,
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _child,
      ),
    );
  }
}
