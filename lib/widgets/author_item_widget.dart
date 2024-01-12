import 'package:flutter/material.dart';

import '../models/author.dart';
import '../screens/form_author_screen.dart';
import 'list_divider_widget.dart';

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
          subtitle: Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              'No. libri: ${item.cnt}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          trailing: Wrap(
            spacing: 10,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove_red_eye),
                color: Colors.purple,
                onPressed: () => {
                  Navigator.of(context).pushNamed(
                    FormAuthorScreen.routeName,
                    arguments: item,
                  )
                },
              ),
            ],
          ),
        ),
        const ListDividerWidget(),
      ],
    );
  }
}
