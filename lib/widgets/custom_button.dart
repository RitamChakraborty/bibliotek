import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String _label;
  final VoidCallback _onPressed;

  const CustomButton({@required String label, @required VoidCallback onPressed})
      : this._label = label,
        this._onPressed = onPressed,
        assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: MaterialButton(
        onPressed: _onPressed,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Theme.of(context).accentColor,
        disabledColor: Theme.of(context).disabledColor,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Text(
            "$_label",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
