import 'package:book_flutter/widgets/main_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books_provider.dart';
import '../widgets/book_item_widget.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final _searchController = TextEditingController();

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
    final booksData = Provider.of<BooksProvider>(context);
    final bookList = booksData.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MP Book'),
      ),
      drawer: const MainMenu(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                Provider.of<BooksProvider>(context, listen: false).cerca(value);
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
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: bookList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: bookList[i],
                  child: const BookItem(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
