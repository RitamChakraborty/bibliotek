import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController _textEditingController;
  final String _labelText;
  final String _errorText;

  const CustomTextField(
      {@required TextEditingController controller,
      @required String labelText,
      String errorText})
      : this._textEditingController = controller,
        this._labelText = labelText,
        this._errorText = errorText,
        assert(controller != null),
        assert(labelText != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          labelText: _labelText,
          errorText: _errorText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
