import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MP Book',
      theme: ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        primarySwatch: Colors.amber,
        textTheme: const TextTheme(
          // headline1: TextStyle(fontWeight: FontWeight.bold),
          headline6: TextStyle(fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MP Book'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: <Widget>[
          const Center(
            child: Text('Let\'s build a shop!'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Salva'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Salva'),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }
}
