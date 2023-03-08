import 'package:book_flutter/models/book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books_provider.dart';
import '../screens/book_screen.dart';

class BookItem extends StatelessWidget {
  const BookItem({super.key});

  @override
  Widget build(BuildContext context) {
    final book = Provider.of<Book>(context, listen: false);

    void _showSnackBar() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "CANCELLATO!",
          ),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: "Annulla",
            onPressed: () {
              print("ANNULLATO");
            },
          ),
        ),
      );
    }

    void _del() {
      Provider.of<BooksProvider>(context, listen: false).del(book);
      _showSnackBar();
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
            child: const Text('Yes'),
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
          _del();
        }

        if (direction == DismissDirection.startToEnd) {
          print('ALTRA AZIONE');
        }
      },
      child: Column(
        children: [
          ListTile(
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(
            //     color: Theme.of(context).primaryColor,
            //     width: 1,
            //   ),
            //   borderRadius: BorderRadius.circular(5),
            // ),
            leading: CircleAvatar(
              radius: 20,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(
                    '€ ${book.price}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
            title: Text(
              (book.title ?? ""),
              style: Theme.of(context).textTheme.bodyText1,
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
                  color: Theme.of(context).errorColor,
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (ctx) => _confDialog(),
                    ).then(
                      (value) => {
                        if (value)
                          {
                            _del(),
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
