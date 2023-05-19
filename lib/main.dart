import 'dart:core';
import 'package:flutter/material.dart';

import './screens/authors_screen.dart';
import './screens/books_screen.dart';
import './screens/book_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MP Book',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.amber,
        textTheme: const TextTheme(
          headline6: TextStyle(fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const BooksScreen(),
        AuthorsScreen.routeName: (ctx) => const AuthorsScreen(),
        BookScreen.routeName: (ctx) => const BookScreen()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => const BooksScreen(),
        );
      },
    );
  }
}
