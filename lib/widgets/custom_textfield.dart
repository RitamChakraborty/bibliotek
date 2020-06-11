import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController _textEditingController;
  final String _labelText;

  const CustomTextField(
      {@required TextEditingController controller, @required String labelText})
      : this._textEditingController = controller,
        this._labelText = labelText,
        assert(controller != null),
        assert(labelText != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          labelText: _labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
