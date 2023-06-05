import 'package:flutter/material.dart';

import '../models/author.dart';

class AuthorItem extends StatelessWidget {
  const AuthorItem({super.key, required this.item});

  final Author item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            (item.name ?? ""),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Wrap(
            spacing: 10,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove_red_eye),
                color: Colors.purple,
                onPressed: () => {
                  // Navigator.of(context).pushNamed(
                  //   BookScreen.routeName,
                  //   arguments: item.id,
                  // )
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
