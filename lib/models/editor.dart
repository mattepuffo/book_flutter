import 'package:flutter/foundation.dart';

class Editors with ChangeNotifier {
  List<Editor> editors;

  Editors({
    required this.editors,
  });

  factory Editors.fromJson(Map<String, dynamic> json) => Editors(
        editors:
            List<Editor>.from(json["editors"].map((x) => Editor.fromJson(x))),
      );
}

class Editor with ChangeNotifier {
  final int? id;
  final String? name;
  final int? cnt;

  Editor({
    this.id,
    this.name,
    this.cnt,
  });

  factory Editor.fromJson(Map<String, dynamic> json) => Editor(
        id: json["id"],
        name: json["name"],
        cnt: json["cnt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
