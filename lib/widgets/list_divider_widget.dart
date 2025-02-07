import 'package:flutter/material.dart';

class ListDividerWidget extends StatelessWidget {
  const ListDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.yellow,
      indent: 10,
      endIndent: 10,
    );
  }
}
