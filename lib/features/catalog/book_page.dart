import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/app_state.dart';
import '../../data/catalog.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key, required this.book, required this.state});
  final Book book;
  final AppState state;
  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool expanded = false;
  final liked = <int>{};
  final reviewsKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final state = widget.state;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => PageFrame(
        title: 'Book Detail',
        actions: [
          IconButton(
            tooltip: 'Bookmark',
            onPressed: () => state.toggleBookmark(book.id),
            icon: Icon(
              state.bookmarks.contains(book.id)
                  ? CupertinoIcons.bookmark_fill
                  : CupertinoIcons.bookmark,
              size: 21,
              color: green,
            ),
          ),
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () => state.toggleWishlist(book.id),
            icon: Icon(
              state.wishlist.contains(book.id)
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              size: 22,
              color: green,
            ),
          ),
        ],
        bottom: PrimaryButton(
          'Add to Basket - ${book.priceLabel}',
          onPressed: () {
            state.addToCart(book.id);
            message(context, '${book.title} added to your basket');
          },
        ),
        body: ListView(
          children: [
            const SizedBox(height: 32),
            Center(child: Cover(book, width: 177, height: 269, shadow: true)),
            const SizedBox(height: 24),
            Text(
              book.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
            Center(
              child: TextButton(
                onPressed: () => go(context, '/author', book.author),
                style: TextButton.styleFrom(foregroundColor: ink),
                child: Text(book.author, style: const TextStyle(fontSize: 16)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stars(book.stars, size: 18),
                TextButton(
                  onPressed: () => Scrollable.ensureVisible(
                    reviewsKey.currentContext!,
                    duration: const Duration(milliseconds: 400),
                  ),
                  child: const Text('38 Reviews'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    synopsis,
                    maxLines: expanded ? null : 6,
                    overflow: expanded ? null : TextOverflow.ellipsis,
                    style: const TextStyle(height: 1.7),
                  ),
                  if (expanded)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Discover a new perspective, one page at a time. Available in hardback from Venus Bookstore.',
                      ),
                    ),
                  TextButton(
                    onPressed: () => setState(() => expanded = !expanded),
                    child: Text(expanded ? 'READ LESS' : 'READ MORE'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Book Details', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  for (final entry in const {
                    'Format': 'Hardback | 320 pages',
                    'Language': 'English',
                    'Dimensions': '202 x 277 x 30mm | 1,396g',
                    'Publication Date': '06 Sep 2018',
                    'Publisher': 'Ebury Publishing',
                    'ISBN10': '1785031163',
                    'ISBN13': '9781785031168',
                  }.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text.rich(
                        TextSpan(
                          text: '${entry.key}: ',
                          children: [
                            TextSpan(
                              text: entry.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              key: reviewsKey,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Reviews This Book',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (_) => SizedBox(
                            height: 480,
                            child: ListView(
                              padding: const EdgeInsets.all(20),
                              children: [
                                const Text(
                                  'Reader reviews',
                                  style: TextStyle(fontSize: 20, color: ink),
                                ),
                                _review(0),
                                _review(1),
                              ],
                            ),
                          ),
                        ),
                        child: const Text('VIEW ALL'),
                      ),
                    ],
                  ),
                  _review(0),
                  _review(1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _review(int i) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/author_${i + 2}.png'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(i == 0 ? 'Nicholas Klein' : 'Allen Garcia'),
                Stars(i == 0 ? 3 : 4, size: 12),
              ],
            ),
            const Spacer(),
            Text(
              i == 0 ? 'July 15, 2018' : 'July 12, 2018',
              style: const TextStyle(fontSize: 11, color: muted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          i == 0
              ? 'This is one of the most interesting textbooks I have ever read. I actually read everything in this book and retained more than needed information.'
              : 'As a scientist, the claims presented in this book struck me as over confident. Science almost never gives clear cut, black and white answers.',
        ),
        TextButton.icon(
          onPressed: () => setState(() {
            liked.contains(i) ? liked.remove(i) : liked.add(i);
          }),
          icon: Icon(
            liked.contains(i)
                ? CupertinoIcons.hand_thumbsup_fill
                : CupertinoIcons.hand_thumbsup,
            size: 16,
          ),
          style: TextButton.styleFrom(foregroundColor: green),
          label: Text(
            '${(i == 0 ? 12 : 7) + (liked.contains(i) ? 1 : 0)} LIKE',
          ),
        ),
      ],
    ),
  );
}
