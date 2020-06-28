import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController _textEditingController;
  final String _labelText;
  final String _errorText;
  final TextInputType _textInputType;
  final bool _isPassword;

  const CustomTextField(
      {@required TextEditingController controller,
      @required String labelText,
      String errorText,
      TextInputType textInputType,
      bool isPassword})
      : this._textEditingController = controller,
        this._labelText = labelText,
        this._errorText = errorText,
        this._textInputType = textInputType ?? TextInputType.text,
        this._isPassword = isPassword ?? false,
        assert(controller != null),
        assert(labelText != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: _textEditingController,
        textCapitalization: TextCapitalization.words,
        keyboardType: _textInputType,
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
