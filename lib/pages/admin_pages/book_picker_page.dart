import 'package:bibliotek/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Filter {
  Name,
  Author,
  Stream,
  Subject,
}

class BookPickerPage extends StatefulWidget {
  @override
  _BookPickerPageState createState() => _BookPickerPageState();
}

class _BookPickerPageState extends State<BookPickerPage> {
  final TextEditingController _controller = TextEditingController();
  Filter currentValue = Filter.Name;

  @override
  Widget build(BuildContext context) {
    BooksProvider booksProvider = Provider.of<BooksProvider>(context);

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
          hintText: "Search book",
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
          child: StreamBuilder(
            stream: booksProvider.getBooks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text("${snapshot.data[index].data['book_name']}"),
                      subtitle: Text(
                          "by ${snapshot.data[index].data['author_name']}\n Subject: ${snapshot.data[index].data['subject_name']}"),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                );
              } else if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
