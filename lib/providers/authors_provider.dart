import 'package:flutter/material.dart';

import '../models/author.dart';

class AuthorsProvider with ChangeNotifier {
  String _searchString = "";

  final List<Author> _items = [
    Author(
      id: 1,
      name: 'Stephen King',
    ),
    Author(
      id: 2,
      name: 'Clive Cussler',
    ),
  ];

  List<Author> get items => _searchString.isEmpty
      ? getAll()
      : List.from(_items.where((el) =>
          el.name!.toLowerCase().contains(_searchString.toLowerCase())));

  void cerca(String value) {
    _searchString = value;
    notifyListeners();
  }

  List<Author> getAll() {
    return List.from(_items);
  }

  Author getById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  void add() {
    // _items.add(value);
    notifyListeners();
  }
}
