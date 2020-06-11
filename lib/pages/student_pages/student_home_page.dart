import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/student_pages/search_book_page.dart';
import 'package:bibliotek/widgets/custom_dawer.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  final List<Book> books = [
    Book(
      bookName: "Programming in C",
      author: "Reema Tharesa",
      subject: "Computer Science Engineering",
    ),
    Book(
      bookName: "Gravitation",
      author: "Kip Thron",
      subject: "General Relativty",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget drawer = CustomDrawer(
      user: User(
        name: "Ritam Chakraborty",
        id: "161001001070",
      ),
    );

    Widget bookTile({@required Book book, @required bool isAvailable}) {
      return ListTile(
        title: Text("${book.bookName}"),
        subtitle: Text("${book.author}"),
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
                    return bookTile(book: books[index], isAvailable: false);
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
  }
}
