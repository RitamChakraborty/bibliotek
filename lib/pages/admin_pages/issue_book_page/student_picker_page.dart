import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    IssueBookBloc issueBookBloc = BlocProvider.of<IssueBookBloc>(context);

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
        body: SafeArea(
          child: BlocBuilder<IssueBookBloc, AbstractIssueBookState>(
              bloc: issueBookBloc,
              builder: (context, AbstractIssueBookState issueBookState) {
                return StreamBuilder(
                  stream: issueBookState.getStudents(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> data = snapshot.data[index].data;

                          return ListTile(
                            onTap: () {
                              User student = User(
                                id: data['id'],
                                password: data['password'],
                                name: data['name'],
                                isAdmin: data['is_admin'],
                                details: data['details'],
                              );

                              issueBookBloc
                                  .add(StudentPickedEvent(student: student));
                              Navigator.pop(context);
                            },
                            title: Text("${data['id']}"),
                            subtitle: Text("${data['name']}"),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                        itemCount: snapshot.data.length,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      );
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}