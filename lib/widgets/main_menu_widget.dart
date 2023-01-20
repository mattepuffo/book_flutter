import 'package:book_flutter/screens/authors_screen.dart';
import 'package:book_flutter/screens/books_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          buildListTile(
            'Libri',
            Icons.book,
            () {
              // Navigator.of(context).pushReplacementNamed('/');
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: const BooksScreen(),
                ),
              );
            },
          ),
          const Divider(),
          buildListTile(
            'Autori',
            Icons.person,
            () {
              // Navigator.of(context).pushReplacementNamed(AuthorsScreen.routeName);
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: const AuthorsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          buildListTile(
            'Editori',
            Icons.person,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(AuthorsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
