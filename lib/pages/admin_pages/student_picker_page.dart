import 'package:flutter/material.dart';

enum Filter { Name, ID }

class StudentPickerPage extends StatefulWidget {
  @override
  _StudentPickerPageState createState() => _StudentPickerPageState();
}

class _StudentPickerPageState extends State<StudentPickerPage> {
  final TextEditingController _controller = TextEditingController();
  Filter currentValue = Filter.Name;

  @override
  Widget build(BuildContext context) {
    Widget leadingButton() {
      if (_controller.text.isEmpty) {
        return BackButton();
      } else {
        return IconButton(
          onPressed: () {
            setState(() {
              _controller.text = "";
            });
          },
          icon: Icon(Icons.close),
        );
      }
    }

    Widget filterListIcon = IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      children: Filter.values.map((Filter value) {
                        return RadioListTile<Filter>(
                          onChanged: (Filter value) {
                            setState(() {
                              currentValue = value;
                            });
                          },
                          value: value,
                          groupValue: currentValue,
                          title: Text("${value.toString().split("\.")[1]}"),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

    Widget searchBookField({@required StateSetter setState}) {
      return TextField(
        onChanged: (String value) {
          setState(() {});
        },
        controller: _controller,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Find student",
          hintStyle: TextStyle(color: Colors.white),
        ),
      );
    }

    return Material(
      child: Scaffold(
        appBar: AppBar(
          leading: leadingButton(),
          actions: <Widget>[
            filterListIcon,
          ],
          title: searchBookField(setState: setState),
        ),
      ),
    );
  }
}
