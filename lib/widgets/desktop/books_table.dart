import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../models/http_response.dart';
import '../../services/book_service.dart';
import '../main_menu_widget.dart';

class BooksTable extends StatefulWidget {
  const BooksTable({super.key});

  @override
  State<BooksTable> createState() => _BooksTableState();
}

class _BooksTableState extends State<BooksTable> {
  late Future<List<Book>> _items;
  final _bookService = BookService();

  @override
  void initState() {
    _items = _loadItems();
    super.initState();
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(
        label: Text('Titolo'),
      ),
      const DataColumn(
        label: Text('Autore'),
      ),
      const DataColumn(
        label: Text('Editore'),
      ),
      const DataColumn(
        label: Text('Prezzo'),
      ),
      const DataColumn(
        label: Text('Scaffale'),
      ),
      const DataColumn(
        label: Text('ISBN'),
      ),
      const DataColumn(
        label: Text('Note'),
      ),
      const DataColumn(
        label: Text(''),
      ),
    ];
  }

  Future<List<Book>> _loadItems() async {
    return _bookService.getAll();
  }

  void _refreshBooks() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(
          child: CircularProgressIndicator(
            color: Colors.yellow,
          ),
        ),
        duration: Duration(seconds: 5000),
      ),
    );

    _items = _loadItems();

    Future.delayed(
      const Duration(seconds: 5),
      () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
    );
  }

  Widget _confDialog() {
    return AlertDialog(
      title: const Text('ATTENZIONE?'),
      content: const Text(
        'Sicuro di voler cancellare il libro?',
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text('Si'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  void _del(Book b) async {
    Future<String> resp = _bookService.del(b);
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

      // onDel();

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "CANCELLATO!",
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('MP Book'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: () {
              _refreshBooks();
            },
          ),
        ],
      ),
      drawer: const MainMenu(),
      body: FutureBuilder<List<Book>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nessun elemento trovato!'),
            );
          } else {
            List<Book> data = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: _createColumns(),
                rows: data
                    .map(
                      (b) => DataRow(
                        cells: [
                          DataCell(
                            Text(b.title ?? ""),
                          ),
                          DataCell(
                            Text(b.author ?? ""),
                          ),
                          DataCell(
                            Text(b.editor ?? ""),
                          ),
                          DataCell(
                            Text(b.price.toString()),
                          ),
                          DataCell(
                            Text(b.scaffale.toString()),
                          ),
                          DataCell(
                            Text(b.isbn ?? ""),
                          ),
                          DataCell(
                            Text(b.note ?? ""),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () => {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => _confDialog(),
                                ).then(
                                  (value) => {
                                    if (value)
                                      {
                                        _del(b),
                                      },
                                  },
                                ),
                              },
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
