import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../models/author.dart';
import '../services/author_service.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _salva() {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
  }

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
                  // if (value == null || value.isEmpty || value.trim().isEmpty) {
                  //   return 'Inserire un titolo!';
                  // }
                  // return null;
                },
                onSaved: (value) {
                  print(value);
                },
              ),
              Center(
                child: FutureBuilder<List<Author>>(
                  future: _authorService.getAll(),
                  builder: (context, initialData) {
                    if (initialData.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (initialData.hasError) {
                      return Center(
                        child: Text(
                          initialData.error.toString(),
                        ),
                      );
                    }

                    if (initialData.data!.isEmpty) {
                      return const Center(
                        child: Text('Nessun elemento trovato!'),
                      );
                    }

                    List<String> items = [];
                    for (var e in initialData.data!) {
                      items.add(e.name!);
                    }

                    // return DropdownSearch<String>(
                    //   popupProps: const PopupProps.menu(
                    //     showSelectedItems: true,
                    //     // disabledItemFn: (String s) => s.startsWith('I'),
                    //   ),
                    //   // items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                    //   items: items,
                    //   dropdownDecoratorProps: const DropDownDecoratorProps(
                    //     dropdownSearchDecoration: InputDecoration(
                    //       labelText: "Autore",
                    //       hintText: "Autore",
                    //     ),
                    //   ),
                    //   onChanged: print,
                    //   // selectedItem: "Brazil",
                    // );

                    return DropdownButton<String>(
                      items: initialData.data!.map(
                        (item) {
                          return DropdownMenuItem<String>(
                            value: item.id.toString(),
                            child: Text(item.name!),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        print(value);
                      },
                    );
                  },
                ),
              ),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  label: Text('Prezzo'),
                ),
                validator: (value) {
                  // if (value == null || value.isEmpty || value.trim().isEmpty) {
                  //   return 'Inserire un prezzo!';
                  // }
                  // return null;
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
