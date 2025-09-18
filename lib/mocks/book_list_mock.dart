import 'package:church_library/models/chapter.dart';
import '../models/book.dart';

final List<Chapter> firstBookChapters = List.generate(20, (i) => Chapter(title: "Chapter ${i + 1}", text: "This is the text of chapter ${i + 1}. " * 20));
final List<Chapter> secondBookChapters = List.generate(15, (i) => Chapter(title: "Chapter ${i + 1}", text: "This is the text of chapter ${i + 1}. " * 25));

final List<Book> mockBooks = [
  Book(title: "Неужели я обманут?", author: "Крэйг Хилл", pages: 228, publicationYear: 1986, chapters: firstBookChapters),
  Book(title: "Триумф распятого", author: "Эрих Зауер", pages: 220, publicationYear: 1993, chapters: secondBookChapters),
];