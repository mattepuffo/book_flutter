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
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.green,
        leading: Text('€ $price'),
        trailing: IconButton(
          icon: const Icon(Icons.update),
          onPressed: () {},
        ),
        title: Text(
          author!,
          textAlign: TextAlign.center,
        ),
      ),
      child: Text(
        title!,
        textAlign: TextAlign.center,
      ),
    );
  }
}
