import 'dart:core';
import 'package:flutter/material.dart';

import './screens/authors_screen.dart';
import './screens/books_screen.dart';
import './screens/book_screen.dart';
import './screens/form_book_screen.dart';
import 'screens/editors_screen.dart';

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
          headlineLarge: TextStyle(fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Hind',
            color: Colors.black,
          ),
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
        // '/': (ctx) => const BooksScreen(),
        '/': (ctx) => const FormBookScreen(),
        BookScreen.routeName: (ctx) => const BookScreen(),
        AuthorsScreen.routeName: (ctx) => const AuthorsScreen(),
        EditorsScreen.routeName: (ctx) => const EditorsScreen(),
        FormBookScreen.routeName: (ctx) => const FormBookScreen()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => const BooksScreen(),
        );
      },
    );
  }
}
