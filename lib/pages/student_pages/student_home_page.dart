import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_events/login_event.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/pages/admin_pages/home_page/show_all_books_page.dart';
import 'package:bibliotek/pages/student_pages/search_book_page.dart';
import 'package:bibliotek/widgets/custom_dawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  LoginBloc _loginBloc;

  final List<Book> books = [
    Book(
      bookName: "Programming in C",
      authorName: "Reema Tharesa",
      subjectName: "Computer Science Engineering",
    ),
    Book(
      bookName: "Gravitation",
      authorName: "Kip Thron",
      subjectName: "General Relativty",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
//    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, AbstractLoginState>(
      bloc: _loginBloc,
      builder: (BuildContext context, AbstractLoginState loginState) {
        if (loginState is LoginSuccessState) {
          Widget drawer = CustomDrawer(
            user: loginState.user,
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
                  _loginBloc.add(LogoutEvent());
                },
              )
            ],
          );

          Widget bookTile({@required Book book, @required bool isAvailable}) {
            return ListTile(
              title: Text("${book.bookName}"),
              subtitle: Text("${book.authorName}"),
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
                child: Builder(
                  builder: (BuildContext context) {
                    if (books.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text("No books pending submission..."),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: books.length,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (BuildContext context, int index) {
                          return bookTile(
                              book: books[index], isAvailable: false);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            indent: 16,
                            endIndent: 16,
                          );
                        },
                      );
                    }
                  },
                ),
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
