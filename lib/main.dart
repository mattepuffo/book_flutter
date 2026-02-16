import 'package:book_flutter/screens/authors_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import './screens/authors_screen.dart';
import './screens/books_screen.dart';
import './screens/form_book_screen.dart';
import './screens/editors_screen.dart';
import 'screens/form_author_screen.dart';
import 'screens/form_editor_screen.dart';
import 'utils/utils.dart';

void main() async {
  final utils = Utils();
  if (utils.isDesktop()) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      center: true,
      // title: 'MP Book',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

// void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MP Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
        ),
        useMaterial3: true,
        fontFamily: 'Raleway',
        primarySwatch: Colors.amber,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const BooksScreen(),
        // '/': (ctx) => const FormBookScreen(),
        AuthorsScreen.routeName: (ctx) => const AuthorsScreen(),
        EditorsScreen.routeName: (ctx) => const EditorsScreen(),
        FormBookScreen.routeName: (ctx) => const FormBookScreen(),
        FormAuthorScreen.routeName: (ctx) => const FormAuthorScreen(),
        FormEditorScreen.routeName: (ctx) => const FormEditorScreen(),
        AuthorsBarScreen.routeName: (ctx) => const AuthorsBarScreen()
    },
    );
  }
}