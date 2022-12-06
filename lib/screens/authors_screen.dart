import 'package:flutter/material.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  static const routeName = '/authors';

  @override
  State<StatefulWidget> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autori'),
      ),
      body: const Text('AUTORI'),
    );
  }
}
