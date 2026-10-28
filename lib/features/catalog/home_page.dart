import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Venus Bookstore',
    back: false,
    navigation: const MainNavigation(0),
    actions: [
      IconButton(
        tooltip: 'Filter books',
        onPressed: () => go(context, '/filter'),
        icon: const Icon(
          CupertinoIcons.line_horizontal_3_decrease,
          color: muted,
        ),
      ),
    ],
    body: ListView(
      children: [
        const SizedBox(height: 16),
        _heading(context, 'Top New Releases', '/category', 'All Books'),
        _shelf(books.take(3).toList()),
        const SizedBox(height: 22),
        _heading(context, 'Top Categories', '/categories'),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final colors = [
                const [Color(0xFFE2B0FF), Color(0xFF9F44D3)],
                const [Color(0xFFABDCFF), Color(0xFF0396FF)],
                const [Color(0xFFFEB692), Color(0xFFEA5455)],
              ];
              return InkWell(
                onTap: () => go(
                  context,
                  '/category',
                  const ['Fiction', 'Art & Photography', 'Biography'][i],
                ),
                child: Container(
                  width: 144,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: colors[i],
                    ),
                  ),
                  child: Text(
                    const ['Drama', 'Photography', 'Biography'][i],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        _heading(context, 'Top New Releases', '/category', 'All Books'),
        _shelf(books.skip(3).toList()),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () => go(context, '/category', 'All Books'),
            child: Container(
              height: 90,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  colors: [Color(0xFFEE9AE5), Color(0xFF5961F9)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top 10',
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                  Text(
                    'Most read book in the world',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        ListTile(
          title: const Text('Discover Authors'),
          trailing: const Icon(CupertinoIcons.chevron_right, color: green),
          onTap: () => go(context, '/authors'),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );

  Widget _heading(
    BuildContext context,
    String title,
    String route, [
    Object? args,
  ]) => Padding(
    padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => go(context, route, args),
          child: const Text('VIEW ALL'),
        ),
      ],
    ),
  );

  Widget _shelf(List<Book> items) => SizedBox(
    height: 262,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 20),
      itemBuilder: (context, i) {
        final book = items[i];
        return SizedBox(
          width: 120,
          child: InkWell(
            onTap: () => go(context, '/book', book),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Cover(book, shadow: true),
                const SizedBox(height: 10),
                Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  'by ${book.author}',
                  maxLines: 1,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
                Text(
                  book.priceLabel,
                  style: const TextStyle(
                    color: green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
