import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormAuthorScreen extends StatelessWidget {
  FormAuthorScreen({super.key});

  static const routeName = '/form_author';

  final _formKey = GlobalKey<FormState>();

  void _salva() {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  label: Text('Titolo'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Inserire un titolo!';
                  }
                  return null;
                },
                onSaved: (value) {
                  print(value);
                },
              ),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  label: Text('Prezzo'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Inserire un prezzo!';
                  }
                  return null;
                },
                onSaved: (value) {
                  print(value);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _salva,
                    child: const Text('Salva'),
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
