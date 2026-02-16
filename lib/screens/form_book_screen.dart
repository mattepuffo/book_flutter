import 'dart:convert';

import 'package:book_flutter/services/editor_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/author.dart';
import '../models/book.dart';
import '../models/editor.dart';
import '../models/http_response.dart';
import '../services/author_service.dart';
import '../services/book_service.dart';
import 'books_screen.dart';

class FormBookScreen extends StatefulWidget {
  const FormBookScreen({super.key});

  static const routeName = '/form_book';

  @override
  State<FormBookScreen> createState() {
    return _FormBookState();
  }
}

class _FormBookState extends State<FormBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bookService = BookService();
  final _authorService = AuthorService();
  final _editorService = EditorService();
  static const double spazio = 10;

  int _id = 0;
  String _titolo = "";
  int _autore = 0;
  Author? _objAutore = Author(id: 0, name: "");
  Editor? _objEditore = Editor(id: 0, name: "");
  int _editore = 0;
  String _prezzo = "0.0";
  String _isbn = "";
  String _scaffale = "0";
  String _note = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _salva() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final book = Book(
        id: _id,
        title: _titolo,
        authorId: _autore,
        editorId: _editore,
        price: double.parse(_prezzo),
        isbn: _isbn,
        scaffale: int.parse(_scaffale),
        note: _note,
      );

      Future<String> resp = _bookService.salva(book);
      String rr = await resp;
      final httpResponse = HttpResponse.fromJson(json.decode(rr));

      if (httpResponse.res == 'ko') {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              httpResponse.message,
            ),
          ),
        );
      } else {
        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const BooksScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final objArgs = ModalRoute.of(context)?.settings.arguments;
    late Book book;
    if (objArgs != null) {
      book = objArgs as Book;
      _id = book.id!;
      _titolo = book.title!;
      _autore = book.authorId!;
      _editore = book.editorId!;
      _prezzo = book.price!.toString();
      _isbn = book.isbn!;
      _scaffale = book.scaffale!.toString();
      _note = book.note!;

      _objAutore = Author(id: book.authorId, name: book.author);
      _objEditore = Editor(id: book.editorId, name: book.editor);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Aggiungi / modifica Libro"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _titolo,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Titolo *'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return 'Inserire un titolo!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _titolo = value!;
                  },
                ),
                const SizedBox(
                  height: spazio,
                ),
                DropdownSearch<Author>(
                  items: (filter, infiniteScrollProps) =>
                      _authorService.getAll(),
                  selectedItem: _objAutore,
                  itemAsString: (Author u) => u.name!,
                  compareFn: (Author? a, Author? b) => a?.id == b?.id,
                  decoratorProps: const DropDownDecoratorProps(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      labelText: "Autore *",
                      hintText: "Autore *",
                    ),
                  ),
                  suffixProps: const DropdownSuffixProps(
                    clearButtonProps: ClearButtonProps(isVisible: true),
                  ),
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                  ),
                  validator: (value) {
                    if (value == null || value.id == 0) {
                      return 'Inserire un autore!';
                    }
                    return null;
                  },
                  onChanged: (Author? value) {
                    _autore = value!.id!;
                  },
                ),
                const SizedBox(
                  height: spazio,
                ),
                DropdownSearch<Editor>(
                  items: (filter, infiniteScrollProps) =>
                      _editorService.getAll(),
                  selectedItem: _objEditore,
                  itemAsString: (Editor u) => u.name!,
                  compareFn: (Editor? a, Editor? b) => a?.id == b?.id,
                  decoratorProps: const DropDownDecoratorProps(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      labelText: "Editore *",
                      hintText: "Editore *",
                    ),
                  ),
                  suffixProps: const DropdownSuffixProps(
                    clearButtonProps: ClearButtonProps(isVisible: true),
                  ),
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                  ),
                  validator: (value) {
                    if (value == null || value.id == 0) {
                      return 'Inserire un editore!';
                    }
                    return null;
                  },
                  onChanged: (Editor? value) {
                    _editore = value!.id!;
                  },
                ),
                const SizedBox(
                  height: spazio,
                ),
                TextFormField(
                  initialValue: _prezzo,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    label: Text('Prezzo *'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return 'Inserire un prezzo!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _prezzo = value!;
                  },
                ),
                const SizedBox(
                  height: spazio,
                ),
                TextFormField(
                  initialValue: _isbn,
                  decoration: const InputDecoration(
                    label: Text('ISBN'),
                  ),
                  onSaved: (value) {
                    _isbn = value!;
                  },
                ),
                const SizedBox(
                  height: spazio,
                ),
                TextFormField(
                  initialValue: _scaffale,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                  ),
                  decoration: const InputDecoration(
                    label: Text('Scaffale *'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return 'Inserire uno scaffale!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _scaffale = value!;
                  },
                ),
                const SizedBox(
                  height: spazio,
                ),
                TextFormField(
                  initialValue: _note,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    label: Text('Note'),
                  ),
                  onSaved: (value) {
                    _note = value!;
                  },
                ),
                const SizedBox(
                  height: spazio,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _salva,
                      child: const Text('Salva'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const BooksScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                      ),
                      child: const Text('Annulla'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
