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
  Widget _body(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (isDesktop() || isWeb()) {
      if (screenWidth < 950) {
        return const BooksList();
      } else {
        return const BooksTable();
      }
    } else {
      return const BooksList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }
}
