import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Categories',
    body: ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, i) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: line)),
        ),
        child: ListTile(
          minTileHeight: 58,
          title: Text(categories[i], style: const TextStyle(fontSize: 14)),
          trailing: const Icon(
            CupertinoIcons.chevron_right,
            color: green,
            size: 22,
          ),
          onTap: () => go(context, '/category', categories[i]),
        ),
      ),
    ),
  );
}

class BookGridPage extends StatelessWidget {
  const BookGridPage({super.key, this.title = 'Art & Photography', this.items});
  final String title;
  final List<Book>? items;
  @override
  Widget build(BuildContext context) {
    final list =
        items ??
        (title == 'All Books' || title == 'Art & Photography'
            ? books
            : books.where((book) => book.category == title).toList());
    return PageFrame(
      title: title,
      body: list.isEmpty
          ? const EmptyState(
              'More books are coming',
              'Explore our other categories in the meantime.',
            )
          : LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                  mainAxisExtent: 278,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final book = list[i];
                  return InkWell(
                    onTap: () => go(context, '/book', book),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: line),
                          bottom: BorderSide(color: line),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Column(
                        children: [
                          Cover(book, width: 102, height: 158),
                          const SizedBox(height: 14),
                          Text(
                            book.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, height: 1.28),
                          ),
                          Text(
                            'by ${book.author}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 12,
                              height: 1.33,
                            ),
                          ),
                          Text(
                            book.priceLabel,
                            style: const TextStyle(
                              color: green,
                              fontWeight: FontWeight.w600,
                              height: 1.28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class AuthorsPage extends StatelessWidget {
  const AuthorsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'List Authors',
    actions: [
      IconButton(
        tooltip: 'Search',
        onPressed: () => go(context, '/search'),
        icon: const Icon(CupertinoIcons.search, color: muted),
      ),
    ],
    body: ListView(
      children: [
        for (final letter in ['A', 'B']) ...[
          Container(
            height: 48,
            color: const Color(0xFFFAFAFA),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(letter, style: const TextStyle(fontSize: 18)),
                const Spacer(),
                Text(
                  '${letter == 'A' ? 30 : 18} authors',
                  style: const TextStyle(color: muted),
                ),
              ],
            ),
          ),
          for (var i = letter == 'A' ? 0 : 6; i < (letter == 'A' ? 6 : 10); i++)
            ListTile(
              minTileHeight: 48,
              leading: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/author_$i.png'),
              ),
              title: Text(authors[i], style: const TextStyle(fontSize: 14)),
              onTap: () => go(context, '/author', authors[i]),
            ),
        ],
      ],
    ),
  );
}
