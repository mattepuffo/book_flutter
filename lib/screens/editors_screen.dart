import 'package:flutter/material.dart';

import '../models/editor.dart';
import '../services/editor_service.dart';
import '../utils/utils.dart';
import '../widgets/editor_item_widget.dart';
import '../widgets/main_menu_widget.dart';

class EditorsScreen extends StatefulWidget {
  const EditorsScreen({super.key});

  static const routeName = '/editors';

  @override
  State<StatefulWidget> createState() => _EditorsScreenState();
}

class _EditorsScreenState extends State<EditorsScreen> {
  final _utils = Utils();
  final _searchController = TextEditingController();
  final _editorService = EditorService();

  late Future<List<Editor>> _items;
  late Future<List<Editor>> _filterItems;

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

  Future<List<Editor>> _loadItems() async {
    return _editorService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Editori'),
      ),
      drawer: const MainMenu(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _filterItems = _editorService.cerca(_items, value);
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
              child: FutureBuilder<List<Editor>>(
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
                    itemBuilder: (ctx, i) => EditorItem(
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
