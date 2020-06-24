import 'package:bibliotek/bloc/books_bloc/books_bloc.dart';
import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/pages/home_page.dart';
import 'package:bibliotek/providers/books_provider.dart';
import 'package:bibliotek/providers/students_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp((MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookBloc>.value(value: BookBloc()),
        BlocProvider<IssueBookBloc>.value(value: IssueBookBloc()),
      ],
      child: MultiProvider(
        providers: [
          Provider<BooksProvider>.value(value: BooksProvider()),
          Provider<StudentsProvider>.value(value: StudentsProvider()),
        ],
        child: MaterialApp(
          title: 'Bibliotek',
          theme: ThemeData(
              primaryColor: Colors.red,
              accentColor: Colors.pinkAccent,
              disabledColor: Colors.red[200]),
          home: HomePage(),
        ),
      ),
    );
  }
}
