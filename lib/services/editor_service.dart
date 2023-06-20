import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/editor.dart';
import '../utils/utils.dart';

class EditorService {
  Future<List<Editor>> getAll() async {
    final url = Uri.parse('${Utils.basePathEditor}get.php');
    final response = await http.get(url);
    final Editors editors = Editors.fromJson(json.decode(response.body));
    List<Editor> items = editors.editors;
    return items;
  }

  Future<List<Editor>> cerca(Future<List<Editor>> items, String testo) async {
    List<Editor> tmpList = await items;
    return testo.isEmpty
        ? items
        : Future.value(List.from(tmpList.where(
            (el) => el.name!.toLowerCase().contains(testo.toLowerCase()))));
  }

  Future<String> salva(Editor item) async {
    final url = Uri.parse('${Utils.basePathEditor}add.php');

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
