import 'package:flutter/foundation.dart';

class Authors with ChangeNotifier {
  List<Author> authors;

  Authors({
    required this.authors,
  });

  factory Authors.fromJson(Map<String, dynamic> json) => Authors(
        authors:
            List<Author>.from(json["authors"].map((x) => Author.fromJson(x))),
      );
}

class Author with ChangeNotifier {
  final int? id;
  final String? name;
  final int? cnt;

  Author({
    this.id,
    this.name,
    this.cnt,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        cnt: json["cnt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
