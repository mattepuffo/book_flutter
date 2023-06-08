import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../utils/utils.dart';

class BookService {
  Future<List<Book>> getAll() async {
    final url = Uri.parse('${Utils.basePathBook}get.php');
    final response = await http.get(url);
    final Books books = Books.fromJson(json.decode(response.body));
    List<Book> items = books.books;
    return items;
  }

  Future<List<Book>> cerca(Future<List<Book>> items, String testo) async {
    List<Book> tmpList = await items;
    return testo.isEmpty
        ? items
        : Future.value(List.from(tmpList.where((el) =>
            el.title!.toLowerCase().contains(testo.toLowerCase()) ||
            el.author!.toLowerCase().contains(testo.toLowerCase()))));
  }

  Future<List<Book>> perScaffale(Future<List<Book>> items, int scaffale) async {
    List<Book> tmpList = await items;
    return scaffale > 0
        ? Future.value(
            List.from(tmpList.where((el) => el.scaffale == scaffale)))
        : items;
  }

  void invia() async{

  }
}
