import 'package:flutter/foundation.dart';

class Author with ChangeNotifier {
  final int? id;
  final String? name;

  Author({
    this.id,
    this.name,
  });
}
