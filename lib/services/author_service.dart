import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/author.dart';
import '../utils/utils.dart';

class AuthorService {
  Future<List<Author>> getAll() async {
    final url = Uri.parse('${Utils.basePathAuthor}get.php');
    final response = await http.get(url);
    final Authors authors = Authors.fromJson(json.decode(response.body));
    List<Author> items = authors.authors;
    return items;
  }

  Future<List<Author>> cerca(Future<List<Author>> items, String testo) async {
    List<Author> tmpList = await items;
    return testo.isEmpty
        ? items
        : Future.value(List.from(tmpList.where(
            (el) => el.name!.toLowerCase().contains(testo.toLowerCase()))));
  }

  Future<String> salva(Author item) async {
    final url = Uri.parse('${Utils.basePathAuthor}add.php');

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
