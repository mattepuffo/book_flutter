import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_detector/platform_detector.dart';

import '../widgets/desktop/books_table.dart';
import '../widgets/mobile/books_list.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  Widget _body() {
    if (isDesktop() || isWeb()) {
      return const BooksTable();
    } else {
      return const BooksList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }
}
