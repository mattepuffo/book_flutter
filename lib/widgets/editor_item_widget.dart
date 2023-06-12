import 'package:flutter/material.dart';

import '../models/editor.dart';
import 'list_divider.dart';

class EditorItem extends StatelessWidget {
  const EditorItem({super.key, required this.item});

  final Editor item;

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
        const ListDivider(),
      ],
    );
  }
}
