import 'package:church_library/common/styles/text_styles.dart';
import 'package:church_library/models/book.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReadingView extends StatefulWidget {
  const ReadingView({super.key, required this.book});
  final Book book;

  @override
  State<ReadingView> createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> {
  String get bookName => "${widget.book.author}\n${widget.book.title}";
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentTopIndex = 0;

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_onItemPositionsChanged);
  }

  void _onItemPositionsChanged() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final minIndex = positions
          .where((position) => position.itemLeadingEdge >= 0)
          .reduce(
              (min, position) => position.index < min.index ? position : min)
          .index;
      if (minIndex != _currentTopIndex) {
        setState(() {
          _currentTopIndex = minIndex;
        });
      }
    }
  }

  void dispose() {
    _itemPositionsListener.itemPositions
        .removeListener(_onItemPositionsChanged);
    super.dispose();
  }

  Future<void> _scrollToChapter(int index, {double alignment = 0.5}) async {
    // Захист від виходу за межі
    final lastIndex = (widget.book.chapters.length - 1)
        .clamp(0, widget.book.chapters.length - 1);
    final safeIndex = index.clamp(0, lastIndex);

    // Якщо контролер вже прив'язаний — скролимо одразу
    if (_itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: safeIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: alignment,
      );
      return;
    }

    // Якщо ще не прив'язаний (наприклад, виклик дуже рано після старту),
    // відкладемо виклик на наступний фрейм і спробуємо ще раз
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
          index: safeIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          alignment: alignment,
        );
      }
    });
  }

  void _searchAndGo(String query) {
    if (query.trim().isEmpty) return;
    final index = widget.book.chapters.indexWhere((c) =>
        c.title.toLowerCase().contains(query.toLowerCase()) ||
        c.text.toLowerCase().contains(query.toLowerCase()));
    if (index > 0) {
      _scrollToChapter(index);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Found at chapter: ${widget.book.chapters[index].title}')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No match found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double? progress = (widget.book.chapters.isEmpty)
        ? 0
        : ((_currentTopIndex + 1) / widget.book.chapters.length);

    return Scaffold(
      appBar: AppBar(
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(widget.book.author, style: TextStyles.appBarTitleStyle),
            SizedBox(height: 12),
            Text(widget.book.title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ]),
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
                  )),
            ),
          ),
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.menu_book),
              onSelected: (i) => _scrollToChapter(i),
              itemBuilder: (ctx) => [
                for (int i = 0; i < widget.book.chapters.length; i++)
                  PopupMenuItem(
                      value: i, child: Text(widget.book.chapters[i].title)),
              ],
            ),
          ]),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search in book...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onSubmitted: _searchAndGo,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                            '${_currentTopIndex + 1}/${widget.book.chapters.length}'),
                        SizedBox(
                          width: 80,
                          child: LinearProgressIndicator(value: progress),
                        ),
                      ],
                    ),
                  ],
                )),
            const Divider(height: 1),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: widget.book.chapters.length,
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemBuilder: (context, index) {
                  final ch = widget.book.chapters[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 28),
                    // Кожна глава — окремий елемент списку.
                    // Оскільки елементи створюються по потребі, це економить пам'ять.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          ch.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Якщо глава дуже довга, вона все одно вміщується в межах item'а —
                        // ScrollablePositionedList нормально обробляє високі елементи.
                        SelectableText(
                          ch.text,
                          style: TextStyle(fontSize: 16, height: 1.45),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Кнопки для швидкої навігації
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'toTop',
            mini: true,
            tooltip: 'До початку',
            child: const Icon(Icons.arrow_upward),
            onPressed: () => _scrollToChapter(0, alignment: 0.0),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'toNext',
            mini: true,
            tooltip: 'Наступна глава',
            child: const Icon(Icons.skip_next),
            onPressed: () {
              final next = (_currentTopIndex + 1)
                  .clamp(0, widget.book.chapters.length - 1);
              _scrollToChapter(next);
            },
          ),
        ],
      ),
    );
  }
}
