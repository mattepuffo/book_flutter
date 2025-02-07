import 'dart:convert';

import 'package:book_flutter/models/book.dart';
import 'package:flutter/material.dart';

import '../../models/http_response.dart';
import '../../screens/form_book_screen.dart';
import '../../services/book_service.dart';
import '../list_divider_widget.dart';

class BookItem extends StatelessWidget {
  BookItem({super.key, required this.book, required this.onDel});

  final _bookService = BookService();
  final Book book;
  final Function() onDel;
  final double textPadding = 5;

  bool animate = true;
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    void del(Book b) async {
      Future<String> resp = _bookService.del(b);
      String rr = await resp;
      final httpResponse = HttpResponse.fromJson(json.decode(rr));

      if (httpResponse.res == 'ko') {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              httpResponse.message,
            ),
          ),
        );
      } else {
        if (!context.mounted) return;

        onDel();

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "CANCELLATO!",
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }

    Widget confDialog() {
      return AlertDialog(
        title: const Text('ATTENZIONE?'),
        content: const Text(
          'Sicuro di voler cancellare il libro?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Si'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    }

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 6),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (ctx) => confDialog());
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          del(book);
        }
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(
                    '€ ${book.price}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            title: Text(
              (book.title ?? ""),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: textPadding,
                    bottom: textPadding,
                  ),
                  child: Text(book.author ?? ""),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: textPadding,
                  ),
                  child: Text(book.editor ?? ""),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: textPadding,
                  ),
                  child: Text('Scaffale ${book.scaffale}'),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: textPadding,
                  ),
                  child: Text(book.isbn ?? ""),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: textPadding,
                    bottom: textPadding,
                  ),
                  child: Text(book.note ?? ""),
                ),
              ],
            ),
            trailing: Wrap(
              spacing: 10,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  color: Colors.purple,
                  onPressed: () => {
                    Navigator.of(context).pushNamed(
                      FormBookScreen.routeName,
                      arguments: book,
                    )
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (ctx) => confDialog(),
                    ).then(
                      (value) => {
                        if (value)
                          {
                            del(book),
                          },
                      },
                    ),
                  },
                ),
              ],
            ),
          ),
          const ListDividerWidget(),
        ],
      ),
    );
  }
}
