import 'package:book_flutter/widgets/author_item_widget.dart';
import 'package:flutter/material.dart';

import '../models/author.dart';
import '../services/author_service.dart';
import '../utils/utils.dart';
import '../widgets/main_menu_widget.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  static const routeName = '/authors';

  @override
  State<StatefulWidget> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  final _utils = Utils();
  final _searchController = TextEditingController();
  final _authorService = AuthorService();

  late Future<List<Author>> _items;
  late Future<List<Author>> _filterItems;

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

  Future<List<Author>> _loadItems() async {
    return _authorService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Autori'),
      ),
      drawer: const MainMenu(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _filterItems = _authorService.cerca(_items, value);
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
              child: FutureBuilder<List<Author>>(
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
                    itemBuilder: (ctx, i) => AuthorItem(
                      item: initialData.data![i],
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
