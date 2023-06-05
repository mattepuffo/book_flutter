import 'package:book_flutter/services/book_service.dart';
import 'package:book_flutter/utils/utils.dart';
import 'package:book_flutter/widgets/main_menu_widget.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_item_widget.dart';

enum Scaffale {
  Zero,
  Uno,
  Due,
  Tre,
}

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final _utils = Utils();
  final _searchController = TextEditingController();
  final _bookService = BookService();

  late Future<List<Book>> _items;
  late Future<List<Book>> _filterItems;

  @override
  void initState() {
    super.initState();
    _items = _loadItems();
    _filterItems = _items;

    if (_utils.isMobile()) {
      _utils.checkConnetcion();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<List<Book>> _loadItems() async {
    return _bookService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MP Book'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (Scaffale selectedValue) {
              setState(() {
                _filterItems =
                    _bookService.perScaffale(_items, selectedValue.index);
              });
            },
            icon: const Icon(
              Icons.more_vert_outlined,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: Scaffale.Zero,
                child: Text('Tutti'),
              ),
              const PopupMenuItem(
                value: Scaffale.Uno,
                child: Text('Scaffale uno'),
              ),
              const PopupMenuItem(
                value: Scaffale.Due,
                child: Text('Scaffale due'),
              ),
              const PopupMenuItem(
                value: Scaffale.Tre,
                child: Text('Scaffale tre'),
              ),
            ],
          ),
        ],
      ),
      drawer: const MainMenu(),
      body: Column(
        children: <Widget>[
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
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) => BookItem(
                      book: initialData.data![i],
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
