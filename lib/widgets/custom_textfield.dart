import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController _textEditingController;
  final String _labelText;
  final String _errorText;
  final bool _isPassword;

  const CustomTextField(
      {@required TextEditingController controller,
      @required String labelText,
      String errorText,
      bool isPassword})
      : this._textEditingController = controller,
        this._labelText = labelText,
        this._errorText = errorText,
        this._isPassword = isPassword ?? false,
        assert(controller != null),
        assert(labelText != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: _textEditingController,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        obscureText: _isPassword,
        decoration: InputDecoration(
          labelText: _labelText,
          errorText: _errorText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
