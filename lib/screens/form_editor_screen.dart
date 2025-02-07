import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/editor.dart';
import '../models/http_response.dart';
import '../services/editor_service.dart';
import 'editors_screen.dart';

class FormEditorScreen extends StatefulWidget {
  const FormEditorScreen({super.key});

  static const routeName = '/form_editor';

  @override
  State<FormEditorScreen> createState() {
    return _FormEditorState();
  }
}

class _FormEditorState extends State<FormEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _editorService = EditorService();
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

      final editor = Editor(
        id: _id,
        name: _nome,
      );

      Future<String> resp = _editorService.salva(editor);
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
            child: const EditorsScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final objArgs = ModalRoute.of(context)?.settings.arguments;
    late Editor editor;

    if (objArgs != null) {
      editor = objArgs as Editor;
      _id = editor.id!;
      _nome = editor.name!;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Aggiungi / modifica Editore"),
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
                            child: const EditorsScreen(),
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
