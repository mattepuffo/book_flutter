import 'dart:convert';

import 'package:book_flutter/screens/authors_bar_screen.dart';
import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../models/http_response.dart';
import '../../screens/form_book_screen.dart';
import '../../services/book_service.dart';
import '../main_menu_widget.dart';

class BooksTable extends StatefulWidget {
  const BooksTable({super.key});

  @override
  State<BooksTable> createState() => _BooksTableState();
}

class _BooksTableState extends State<BooksTable> {
  late Future<List<Book>> _items;
  late Future<List<Book>> _filterItems;
  final _bookService = BookService();
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    _items = _loadItems();
    _filterItems = _loadItems();
    super.initState();
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

    setState(() {
      _filterItems = _items;
    });

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final List<Book> books = await _items;

                    if (context.mounted) {
                      Navigator.of(context).pushNamed(
                        AuthorsBarScreen.routeName,
                        arguments: books,
                      );
                    }
                  },
                  child: const Text('Grafico Autori'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _filterItems = _bookService.cerca(_items, value);
                });
              },
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Cerca...",
                hintText: "Cerca...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder<List<Book>>(
            future: _filterItems,
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
                return Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 15,
                        columns: [
                          DataColumn(
                            label: const Text('Titolo'),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  data.sort(
                                      (a, b) => b.title!.compareTo(a.title!));
                                } else {
                                  data.sort(
                                      (a, b) => a.title!.compareTo(b.title!));
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          DataColumn(
                            label: const Text('Autore'),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  data.sort(
                                      (a, b) => b.author!.compareTo(a.author!));
                                } else {
                                  data.sort(
                                      (a, b) => a.author!.compareTo(b.author!));
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          DataColumn(
                            label: const Text('Editore'),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  data.sort(
                                      (a, b) => b.editor!.compareTo(a.editor!));
                                } else {
                                  data.sort(
                                      (a, b) => a.editor!.compareTo(b.editor!));
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          DataColumn(
                            label: const Text('Prezzo'),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  data.sort(
                                      (a, b) => b.price!.compareTo(a.price!));
                                } else {
                                  data.sort(
                                      (a, b) => a.price!.compareTo(b.price!));
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          DataColumn(
                            label: const Text('Scaffale'),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  data.sort((a, b) =>
                                      b.scaffale!.compareTo(a.scaffale!));
                                } else {
                                  data.sort((a, b) =>
                                      a.scaffale!.compareTo(b.scaffale!));
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          DataColumn(
                            label: const Text('ISBN'),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  data.sort(
                                      (a, b) => b.isbn!.compareTo(a.isbn!));
                                } else {
                                  data.sort(
                                      (a, b) => a.isbn!.compareTo(b.isbn!));
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          const DataColumn(
                            label: Text('Note'),
                          ),
                          const DataColumn(
                            label: Text(''),
                          ),
                        ],
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
                                    Row(
                                      children: [
                                        IconButton(
                                          icon:
                                              const Icon(Icons.remove_red_eye),
                                          color: Colors.purple,
                                          onPressed: () => {
                                            Navigator.of(context).pushNamed(
                                              FormBookScreen.routeName,
                                              arguments: b,
                                            )
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
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
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                            .toList(),
                        sortColumnIndex: _currentSortColumn,
                        sortAscending: _isSortAsc,
                        dataRowMaxHeight: double.infinity,
                        showBottomBorder: true,
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
