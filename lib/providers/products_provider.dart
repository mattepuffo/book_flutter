import 'package:flutter/material.dart';

import '../models/book.dart';

class BooksProvider with ChangeNotifier {
  String _searchString = "";
  final List<Book> _items = [
    Book(
      id: 1,
      title: 'IT',
      authorId: 2,
      author: 'Stephen King',
      editor: 'Mondadori',
      editorId: 2,
      price: 33.25,
      isbn: '',
      scaffale: 2,
      note: '',
      dataAggiunta: DateTime.now(),
    ),
    Book(
      id: 2,
      title: 'Sahara',
      authorId: 2,
      author: 'Clive Cussler',
      editor: 'Mondadori',
      editorId: 2,
      price: 23.05,
      isbn: '',
      scaffale: 2,
      note: '',
      dataAggiunta: DateTime.now(),
    ),
    Book(
      id: 3,
      title: 'Mars',
      authorId: 2,
      author: 'Weir',
      editor: 'Mondadori',
      editorId: 2,
      price: 90.25,
      isbn: '',
      scaffale: 2,
      note: '',
      dataAggiunta: DateTime.now(),
    ),
    Book(
      id: 3,
      title: 'Libro 4',
      authorId: 5,
      author: 'Stephen King',
      editor: 'Mondadori',
      editorId: 2,
      price: 33.25,
      isbn: '',
      scaffale: 2,
      note: '',
      dataAggiunta: DateTime.now(),
    ),
  ];

  List<Book> get items => _searchString.isEmpty
      ? List.from(_items)
      : List.from(_items.where((el) =>
          el.title!.toLowerCase().contains(_searchString.toLowerCase()) ||
          el.author!.toLowerCase().contains(_searchString.toLowerCase())));

  void onSearchString(String value) {
    _searchString = value;
    notifyListeners();
  }

  void add() {
    // _items.add(value);
    notifyListeners();
  }
}
