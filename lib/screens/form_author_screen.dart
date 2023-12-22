import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/author.dart';
import '../models/http_response.dart';
import '../services/author_service.dart';
import 'authors_screen.dart';

class FormAuthorScreen extends StatefulWidget {
  const FormAuthorScreen({super.key});

  static const routeName = '/form_author';

  @override
  State<FormAuthorScreen> createState() {
    return _FormAuthorState();
  }
}

class _FormAuthorState extends State<FormAuthorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authorService = AuthorService();
  static const double spazio = 10;

  int _id = 0;
  String _nome = "";

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

      final author = Author(
        id: _id,
        name: _nome,
      );

      Future<String> resp = _authorService.salva(author);
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
            child: const AuthorsScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final objArgs = ModalRoute.of(context)?.settings.arguments;
    late Author author;

    if (objArgs != null) {
      author = objArgs as Author;
      _id = author.id!;
      _nome = author.name!;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Aggiungi / modifica Autore"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _nome,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Nome *'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return 'Inserire un nome!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nome = value!;
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
                            child: const AuthorsScreen(),
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
