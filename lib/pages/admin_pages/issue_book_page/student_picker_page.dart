import 'package:bibliotek/bloc/issue_book_bloc/events/issue_book_event.dart';
import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/providers/firestore_provider.dart';
import 'package:bibliotek/widgets/search_field.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class StudentPickerPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FireStoreProvider firestore = Provider.of<FireStoreProvider>(context);
    IssueBookBloc issueBookBloc = BlocProvider.of<IssueBookBloc>(context);
    String filter = "";

    return Material(
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          appBar: AppBar(
            title: SearchField(
              controller: _controller,
              onChanged: (String value) {
                setState(() {
                  filter = value;
                });
              },
            ),
            actions: [
              filter.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          filter = "";
                          _controller.text = "";
                        });
                      },
                      icon: Icon(Icons.clear),
                    )
                  : Container(),
            ],
          ),
          body: SafeArea(
            child: StreamBuilder<List<User>>(
              stream: firestore.getStudents(),
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
