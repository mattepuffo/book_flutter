import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final String? title;
  final String? author;
  final double? price;

  const BookItem({
    super.key,
    this.title,
    this.author,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: FittedBox(
                child: Text('€ $price'),
              ),
            ),
          ),
          title: Text(title!),
          subtitle: Text(author!),
          trailing: MediaQuery.of(context).size.width > 460
              ? OutlinedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Cancella'),
                  onPressed: () => {},
                )
              : IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () => {},
                ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
