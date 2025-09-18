import 'package:church_library/models/chapter.dart';

class Book {
  final String title;
  final String author;
  final int pages;
  final int publicationYear;
  final List<Chapter> chapters;

  Book({
    required this.title,
    required this.author,
    required this.pages,
    required this.publicationYear,
    required this.chapters,
  });

  @override
  String toString() {
    return 'Book(title: $title, author: $author, pages: $pages, publicationYear: $publicationYear)';
  }
}