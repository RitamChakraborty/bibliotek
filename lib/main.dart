import 'package:bibliotek/bloc/books_bloc/books_bloc.dart';
import 'package:bibliotek/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/bloc/submit_book_bloc/submit_book_bloc.dart';
import 'package:bibliotek/pages/login_pages/home_page.dart';
import 'package:bibliotek/providers/firestore_provider.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/services/firestore_services.dart';
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
        BlocProvider<LoginBloc>.value(value: LoginBloc()),
        BlocProvider<ChangePasswordBloc>.value(value: ChangePasswordBloc()),
        BlocProvider<IssueBookBloc>.value(value: IssueBookBloc()),
        BlocProvider<BookBloc>.value(value: BookBloc()),
        BlocProvider<SubmitBookBloc>.value(value: SubmitBookBloc()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>.value(
            value: UserProvider(user: null),
          ),
          Provider<FireStoreProvider>.value(
            value: FireStoreProvider(
              firestoreServices: FirestoreServices(),
            ),
          ),
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
