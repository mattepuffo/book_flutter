import 'dart:convert';

import 'package:book_flutter/models/book.dart';
import 'package:flutter/material.dart';

import '../models/http_response.dart';
import '../screens/book_screen.dart';
import '../services/book_service.dart';

class BookItem extends StatelessWidget {
  BookItem({super.key, required this.book, required this.onDel});

  final _bookService = BookService();
  final Book book;
  final Function() onDel;

  @override
  Widget build(BuildContext context) {
    void _del(Book b) async {
      Future<String> resp = _bookService.del(book);
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

    Widget _confDialog() {
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
        return showDialog(context: context, builder: (ctx) => _confDialog());
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _del(book);
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
            subtitle: Text(book.author ?? ""),
            trailing: Wrap(
              spacing: 10,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  color: Colors.purple,
                  onPressed: () => {
                    Navigator.of(context).pushNamed(
                      BookScreen.routeName,
                      arguments: book.id,
                    )
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (ctx) => _confDialog(),
                    ).then(
                      (value) => {
                        if (value)
                          {
                            _del(book),
                          },
                      },
                    ),
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
