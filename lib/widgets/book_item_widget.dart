import 'package:book_flutter/models/book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/book_screen.dart';

class BookItem extends StatelessWidget {
  const BookItem({super.key});

  @override
  Widget build(BuildContext context) {
    final book = Provider.of<Book>(context, listen: false);

    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
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
                onPressed: () => {},
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
