import 'package:church_library/models/book.dart';

class User {
  final String id;
  final String name;
  final String email;
  List<Map<Book, int>> bookmarks = [];

  User({
    required this.id,
    required this.name,
    required this.email,
  });
}