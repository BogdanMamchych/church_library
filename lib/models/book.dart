class Book {
  final String title;
  final String author;
  final int pages;
  final int publicationYear;

  Book({
    required this.title,
    required this.author,
    required this.pages,
    required this.publicationYear,
  });

  @override
  String toString() {
    return 'Book(title: $title, author: $author, pages: $pages, publicationYear: $publicationYear)';
  }
}