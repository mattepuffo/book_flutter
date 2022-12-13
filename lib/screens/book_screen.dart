import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books_provider.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  static const routeName = '/book';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;

    final book = Provider.of<BooksProvider>(
      context,
      listen: false,
    ).getById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(book?.title ?? ""),
      ),
    );
  }
}
