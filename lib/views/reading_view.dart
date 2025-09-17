import 'package:flutter/material.dart';
import '../mocks/book_list_mock.dart';

class ReadingView extends StatelessWidget {
  final bookName;
  const ReadingView({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          bookName,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        toolbarHeight: 120,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/AppBarBackground.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Color.fromARGB(73, 0, 0, 0),
                BlendMode.darken,
              )
            ),
          ),
        ),
      ),
    );
  }
}
