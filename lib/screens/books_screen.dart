import 'package:book_flutter/models/book.dart';
import 'package:book_flutter/services/book_service.dart';
import 'package:book_flutter/widgets/main_menu_widget.dart';
import 'package:flutter/material.dart';

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
  final _searchController = TextEditingController();
  final _bookService = BookService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MP Book'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (Scaffale selectedValue) {},
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
              onChanged: (value) {},
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
                future: _bookService.getAll(),
                builder: (context, initialData) {
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
