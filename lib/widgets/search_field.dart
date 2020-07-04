import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController _controller;
  final Function _onChanged;

  const SearchField(
      {@required TextEditingController controller,
      @required Function onChanged})
      : this._controller = controller,
        this._onChanged = onChanged,
        assert(controller != null),
        assert(onChanged != null);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onChanged,
      controller: _controller,
      cursorColor: Colors.white,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Find student by ID",
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
    ;
  }
}
