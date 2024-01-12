import 'package:flutter/material.dart';

import '../models/editor.dart';
import '../screens/form_editor_screen.dart';
import 'list_divider_widget.dart';

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
                    FormEditorScreen.routeName,
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
