import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/book.dart';

class BookService {
  Future<List<Book>> getAll() async {
    final url = Uri.https('www.mattepuffo.com', '/api/book/get.php');
    final response = await http.get(url);
    Books books = Books.fromJson(json.decode(response.body));
    List<Book> items = books.books;
    for (final item in items) {
      print(item.title);
    }
    return items;
  }
}
