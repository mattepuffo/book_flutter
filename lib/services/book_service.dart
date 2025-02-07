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
        : Future.value(
            List.from(
              tmpList.where(
                (el) =>
                    el.title!.toLowerCase().contains(testo.toLowerCase()) ||
                    el.author!.toLowerCase().contains(testo.toLowerCase()) ||
                    el.note!.toLowerCase().contains(testo.toLowerCase()),
              ),
            ),
          );
  }

  Future<List<Book>> perScaffale(Future<List<Book>> items, int scaffale) async {
    List<Book> tmpList = await items;
    return scaffale > 0
        ? Future.value(
            List.from(tmpList.where((el) => el.scaffale == scaffale)))
        : items;
  }

  Future<List<Book>> ordinamento(Future<List<Book>> items, String campo) async {
    List<Book> tmpList = await items;

    switch (campo) {
      case 'prezzoAsc':
        tmpList.sort((a, b) => a.price!.compareTo(b.price!));
        break;
      case 'prezzoDesc':
        tmpList.sort((a, b) => b.price!.compareTo(a.price!));
        break;
      case 'titoloAsc':
        tmpList.sort((a, b) => a.title!.compareTo(b.title!));
        break;
      case 'titoloDesc':
        tmpList.sort((a, b) => b.title!.compareTo(a.title!));
        break;
      case 'autoreAsc':
        tmpList.sort((a, b) => a.author!.compareTo(b.author!));
        break;
      case 'autoreDesc':
        tmpList.sort((a, b) => b.author!.compareTo(a.author!));
        break;
      case 'editoreAsc':
        tmpList.sort((a, b) => a.editor!.compareTo(b.editor!));
        break;
      case 'editoreDesc':
        tmpList.sort((a, b) => b.editor!.compareTo(a.editor!));
        break;
      case 'scaffaleAsc':
        tmpList.sort((a, b) => a.scaffale!.compareTo(b.scaffale!));
        break;
      case 'scaffaleDesc':
        tmpList.sort((a, b) => b.scaffale!.compareTo(a.scaffale!));
        break;
      default:
        break;
    }

    return Future.value(List.from(tmpList));
  }

  Future<String> salva(Book item) async {
    final url = Uri.parse('${Utils.basePathBook}add2.php');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(item),
    );

    return response.body;
  }

  Future<String> del(Book item) async {
    final url = Uri.parse('${Utils.basePathBook}del.php');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(item),
    );

    return response.body;
  }
}
