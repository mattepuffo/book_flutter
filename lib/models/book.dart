import 'package:flutter/foundation.dart';

class Books with ChangeNotifier {
  List<Book> books;

  Books({
    required this.books,
  });

  factory Books.fromJson(Map<String, dynamic> json) => Books(
        books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
      );

// Map<String, dynamic> toJson() => {
//       "books": List<dynamic>.from(books.map((x) => x.toJson())),
//     };
}

class Book with ChangeNotifier {
  final int? id;
  final String? title;
  final int? authorId;
  final String? author;
  final int? editorId;
  final String? editor;
  final double? price;
  final String? isbn;
  final String? note;
  final int? scaffale;
  final DateTime? dataAggiunta;

  Book({
    this.id,
    this.title,
    this.authorId,
    this.author,
    this.editorId,
    this.editor,
    this.price,
    this.isbn,
    this.note,
    this.scaffale,
    this.dataAggiunta,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        authorId: json["author_id"],
        author: json["author"],
        editorId: json["editor_id"],
        editor: json["editor"],
        price: json["price"]?.toDouble(),
        isbn: json["isbn"],
        note: json["note"],
        scaffale: json["scaffale"],
        dataAggiunta: DateTime.parse(json["data_aggiunta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author_id": authorId,
        "author": author,
        "editor_id": editorId,
        "editor": editor,
        "price": price,
        "isbn": isbn,
        "note": note,
        "scaffale": scaffale,
      };
}
