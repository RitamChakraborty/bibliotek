import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_events/login_event.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/pages/admin_pages/home_page/show_all_books_page.dart';
import 'package:bibliotek/pages/student_pages/search_book_page.dart';
import 'package:bibliotek/widgets/custom_dawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocBuilder<LoginBloc, AbstractLoginState>(
      bloc: loginBloc,
      builder: (BuildContext context, AbstractLoginState loginState) {
        if (loginState is LoginSuccessState) {
          Widget drawer = CustomDrawer(
            // Todo: Name, id
            name: "",
            id: "",
            children: [
              ListTile(
                leading: Icon(Icons.book),
                title: Text("All Books"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ShowAllBooksPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("Change Password"),
              ),
              Divider(
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text("Logout"),
                onTap: () {
                  loginBloc.add(LogoutEvent());
                },
              )
            ],
          );

          Widget bookTile({
            @required String title,
            @required String author,
            @required String publisher,
            @required bool isAvailable,
          }) {
            return ListTile(
              title: Text("${title}"),
              subtitle: Text("by $author \npublished by $publisher"),
              trailing: Text(
                isAvailable ? "Available" : "Unavailable",
              ),
            );
          }

          return Material(
            child: Scaffold(
              drawer: drawer,
              appBar: AppBar(
                title: Text(
                  "Borrowed Books",
                ),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SearchBookPage();
                    },
                  ));
                },
                label: Text("Find Books"),
              ),
              body: SafeArea(
                child: Container(),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
