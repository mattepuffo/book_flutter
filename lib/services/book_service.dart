import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/book.dart';

class BookService {
  Future<List<Book>> getAll() async {
    final url = Uri.parse('https://www.mattepuffo.com/api/book/get.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Books books = Books.fromJson(json.decode(response.body));
      List<Book> items = books.books;
      return items;
    } else {
      throw Exception('ERRORE!');
    }
  }
}
