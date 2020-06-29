import 'package:bibliotek/bloc/issue_book_bloc/events/issue_book_event.dart';
import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPickerPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    IssueBookBloc issueBookBloc = BlocProvider.of<IssueBookBloc>(context);
    String filter = "";

    Widget searchBookField({@required StateSetter setState}) {
      return TextField(
        onChanged: (String value) {
          setState(() {
            filter = value;
          });
        },
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
    }

    return Material(
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          appBar: AppBar(
            title: searchBookField(setState: setState),
          ),
          body: SafeArea(
            child: StreamBuilder<List<User>>(
              stream: _firestoreServices.getStudents(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<User> users = snapshot.data;

                  if (users.isNotEmpty) {
                    List<User> filteredUsers = users
                        .where((element) => element.id.startsWith(filter))
                        .toList();

                    return ListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MaterialButton(
                          onPressed: () {
                            issueBookBloc.add(StudentPickedEvent(
                              student: filteredUsers[index],
                            ));
                            Navigator.pop(context);
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ValueTile(
                                    label: "ID",
                                    value: filteredUsers[index].id,
                                  ),
                                  ValueTile(
                                    label: "Name",
                                    value: filteredUsers[index].name,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    );
                  }
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        );
      }),
    );
  }
}
