import 'package:dropdown_textfield/dropdown_textfield.dart';
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
  late SingleValueDropDownController _cnt;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late List<Author> _itemsAuthors = [];
  final _authorService = AuthorService();

  @override
  void initState() {
    super.initState();
    _cnt = SingleValueDropDownController();
    _loadAuthors();
  }

  @override
  void dispose() {
    super.dispose();
    _cnt.dispose();
  }

  void _salva() {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
  }

  void _loadAuthors() async {
    List<Author> _tmpList = await _authorService.getAll();

    setState(() {
      _itemsAuthors = _tmpList;
    });
  }

  List<DropDownValueModel> _drpAuthors() {
    for (final autore in _itemsAuthors) {
      _itemsAuthors.add(autore);
    }

    return const [
      DropDownValueModel(name: 'name1', value: "value1"),
      DropDownValueModel(
          name: 'name2',
          value: "value2",
          toolTipMsg:
              "DropDownButton is a widget that we can use to select one unique value from a set of values"),
      DropDownValueModel(name: 'name3', value: "value3"),
      DropDownValueModel(
          name: 'name4',
          value: "value4",
          toolTipMsg:
              "DropDownButton is a widget that we can use to select one unique value from a set of values"),
      DropDownValueModel(name: 'name5', value: "value5"),
      DropDownValueModel(name: 'name6', value: "value6"),
      DropDownValueModel(name: 'name7', value: "value7"),
      DropDownValueModel(name: 'name8', value: "value8"),
    ];
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
              DropDownTextField(
                textFieldDecoration: const InputDecoration(
                  label: Text('Autore'),
                ),
                searchDecoration: const InputDecoration(
                  label: Text('Cerca autore'),
                ),
                clearOption: false,
                textFieldFocusNode: textFieldFocusNode,
                searchFocusNode: searchFocusNode,
                // searchAutofocus: true,
                dropDownItemCount: _drpAuthors().length,
                searchShowCursor: false,
                enableSearch: true,
                searchKeyboardType: TextInputType.number,
                dropDownList: _drpAuthors(),
                onChanged: (val) {
                  print(val.name);
                },
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
