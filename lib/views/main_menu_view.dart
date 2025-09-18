import 'package:church_library/common/styles/text_styles.dart';
import 'package:church_library/views/reading_view.dart';
import 'package:flutter/material.dart';
import '../mocks/book_list_mock.dart';

class MainMenuView extends StatelessWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        centerTitle: true,
        title: const Text('Церковна Бібліотека',
            style: TextStyles.appBarTitleStyle),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/AppBarBackground.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(73, 0, 0, 0),
              BlendMode.darken,
            ),
          )),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Center(
              child: ListView.builder(
            itemCount: mockBooks.length,
            itemBuilder: (context, index) {
              final book = mockBooks[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Material(
                  color: Colors.green,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingView(book: book,)));
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Center(
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text(
                            'Автор: ${book.author} (${book.publicationYear}) - ${book.pages} сторінок'),
                        leading: const Icon(Icons.book),
                      ),
                    ),
                  ),
                ),
              );
            },
          ))),
    );
  }
}
