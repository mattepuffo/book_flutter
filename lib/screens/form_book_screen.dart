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

  static const routeName = '/form_author';

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
  static const double spazio = 15;

  String _titolo = "";
  int _autore = 0;
  int _editore = 0;
  String _prezzo = "";
  String _isbn = "";
  int _scaffale = 0;
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
        title: _titolo,
        authorId: _autore,
        editorId: _editore,
        price: double.parse(_prezzo),
        isbn: _isbn,
        scaffale: _scaffale,
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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Aggiungi / modifica Libro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text('Titolo *'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
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
                asyncItems: (String filter) => _authorService.getAll(),
                itemAsString: (Author u) => u.name!,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Autore *",
                    hintText: "Autore *",
                  ),
                ),
                validator: (value) {
                  if (value == null) {
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
                asyncItems: (String filter) => _editorService.getAll(),
                itemAsString: (Editor u) => u.name!,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Editore *",
                    hintText: "Editore",
                  ),
                ),
                validator: (value) {
                  if (value == null) {
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  label: Text('Prezzo *'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
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
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                ),
                decoration: const InputDecoration(
                  label: Text('Scaffale *'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Inserire uno scaffale!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _scaffale = int.parse(value!);
                },
              ),
              const SizedBox(
                height: spazio,
              ),
              TextFormField(
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
    );
  }
}
