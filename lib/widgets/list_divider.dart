import 'package:flutter/material.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.yellow,
      indent: 10,
      endIndent: 10,
    );
  }
}
