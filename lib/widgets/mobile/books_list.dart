import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../services/book_service.dart';
import '../../utils/ordinamenti.dart';
import '../../utils/scaffale.dart';
import '../main_menu_widget.dart';
import 'book_item_widget.dart';

class BooksList extends StatefulWidget {
  const BooksList({super.key});

  @override
  State<BooksList> createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  Scaffale selectedScaffale = Scaffale.Tutti;
  OrdinamentoLibro selectedOrdinamento = OrdinamentoLibro.titoloAsc;
  final _searchController = TextEditingController();
  final _bookService = BookService();
  late Future<List<Book>> _items;
  late Future<List<Book>> _filterItems;

  @override
  void initState() {
    _items = _loadItems();
    _filterItems = _loadItems();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<List<Book>> _loadItems() async {
    return _bookService.getAll();
  }

  void _refreshBooks() {
    _searchController.text = '';

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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.57),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    child: DropdownButton<Scaffale>(
                      value: selectedScaffale,
                      items: Scaffale.values.map((Scaffale item) {
                        return DropdownMenuItem<Scaffale>(
                          value: item,
                          child: Text(
                            item.name,
                          ),
                        );
                      }).toList(),
                      onChanged: (Scaffale? value) {
                        setState(() {
                          selectedScaffale = value!;
                          _filterItems = _bookService.perScaffale(
                            _items,
                            selectedScaffale.index,
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.57),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    child: DropdownButton<OrdinamentoLibro>(
                      value: selectedOrdinamento,
                      items:
                          OrdinamentoLibro.values.map((OrdinamentoLibro item) {
                        return DropdownMenuItem<OrdinamentoLibro>(
                          value: item,
                          child: Text(
                            item.desc,
                          ),
                        );
                      }).toList(),
                      onChanged: (OrdinamentoLibro? value) {
                        setState(() {
                          selectedOrdinamento = value!;
                          _filterItems = _bookService.ordinamento(
                            _items,
                            selectedOrdinamento.name,
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
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
          const Divider(),
          Expanded(
            child: RefreshIndicator(
              displacement: 150,
              backgroundColor: Colors.black38,
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                _searchController.text = '';
                await Future.delayed(const Duration(milliseconds: 1500));
              },
              child: FutureBuilder<List<Book>>(
                future: _filterItems,
                builder: (context, initialData) {
                  if (initialData.connectionState == ConnectionState.waiting) {
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

                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: initialData.data!.length,
                    itemBuilder: (ctx, i) => BookItem(
                      book: initialData.data![i],
                      onDel: _refreshBooks,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
