import 'package:book_flutter/widgets/main_menu_widget.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_item_widget.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Book> _bookList = [
    Book(
      id: 1,
      title: 'IT',
      authorId: 2,
      author: 'Stephen King',
      editor: 'Mondadori',
      editorId: 2,
      price: 33.25,
      isbn: '',
      scaffale: 2,
      note: '',
      dataAggiunta: DateTime.now(),
    ),
    Book(
      id: 2,
      title: 'Sahara',
      authorId: 2,
      author: 'Clive Cussler',
      editor: 'Mondadori',
      editorId: 2,
      price: 23.05,
      isbn: '',
      scaffale: 2,
      note: '',
      dataAggiunta: DateTime.now(),
    ),
    Book(
      id: 3,
      title: 'Mars',
      authorId: 2,
      author: 'Weir',
      editor: 'Mondadori',
      editorId: 2,
      price: 90.25,
      isbn: '',
      scaffale: 2,
      note: '',
      dataAggiunta: DateTime.now(),
    ),
    Book(
      id: 3,
      title: 'Libro 4',
      authorId: 5,
      author: 'Stephen King',
      editor: 'Mondadori',
      editorId: 2,
      price: 33.25,
      isbn: '',
      scaffale: 2,
      note: '',
      dataAggiunta: DateTime.now(),
    ),
  ];

  final List<Book> _copyList = <Book>[];

  @override
  void initState() {
    _copyList.addAll(_bookList);
    super.initState();
  }

  void cercaLibro(String query) {
    if (query.isNotEmpty) {
      List<Book> searchList = <Book>[];
      for (Book book in _bookList) {
        if (book.title!.toLowerCase().contains(query.toLowerCase()) ||
            book.author!.toLowerCase().contains(query.toLowerCase())) {
          searchList.add(book);
        }
      }
      setState(() {
        _copyList.clear();
        _copyList.addAll(searchList);
      });
      return;
    } else {
      setState(() {
        _copyList.clear();
        _copyList.addAll(_bookList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
