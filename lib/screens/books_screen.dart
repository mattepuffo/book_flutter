import 'package:book_flutter/widgets/main_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/products_provider.dart';
import '../widgets/book_item_widget.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController = TextEditingController();

  // final List<Book> _copyList = <Book>[];

  @override
  void initState() {
    // _copyList.addAll(_bookList);
    super.initState();
  }

  void cercaLibro(String query) {
    // if (query.isNotEmpty) {
    //   List<Book> searchList = <Book>[];
    //   for (Book book in _bookList) {
    //     if (book.title!.toLowerCase().contains(query.toLowerCase()) ||
    //         book.author!.toLowerCase().contains(query.toLowerCase())) {
    //       searchList.add(book);
    //     }
    //   }
    //   setState(() {
    //     _copyList.clear();
    //     _copyList.addAll(searchList);
    //   });
    //   return;
    // } else {
    //   setState(() {
    //     _copyList.clear();
    //     _copyList.addAll(_bookList);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final booksData = Provider.of<BooksProvider>(context);
    final _bookList = booksData.items;
    final _copyList = booksData.items;

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
                cercaLibro(value);
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
                setState(() {
                  _copyList.clear();
                  _copyList.addAll(_bookList);
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: _copyList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (ctx, i) => BookItem(
                  title: _copyList[i].title,
                  author: _copyList[i].author,
                  price: _copyList[i].price,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
