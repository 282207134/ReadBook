import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/app_state.dart';
import '../../data/catalog.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({
    super.key,
    required this.state,
    this.bookmarks = false,
    this.author,
  });
  final AppState state;
  final bool bookmarks;
  final String? author;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) {
      final items = author == null
          ? books
                .where(
                  (b) => (bookmarks ? state.bookmarks : state.wishlist)
                      .contains(b.id),
                )
                .toList()
          : books.where((b) => b.author == author).toList();
      return PageFrame(
        title: author ?? (bookmarks ? 'Bookmarks' : 'Wishlist'),
        back: bookmarks || author != null,
        navigation: bookmarks || author != null
            ? null
            : const MainNavigation(2),
        bottom: !bookmarks && author == null && items.isNotEmpty
            ? PrimaryButton(
                'Add to Cart',
                onPressed: () {
                  for (final book in items) {
                    state.addToCart(book.id);
                  }
                  message(
                    context,
                    '${items.length} books added to your basket',
                  );
                },
              )
            : null,
        body: items.isEmpty
            ? EmptyState(
                author != null
                    ? 'No books available yet'
                    : 'Your ${bookmarks ? 'bookmarks' : 'wishlist'} is empty',
                author != null
                    ? 'Explore another author or browse the catalog.'
                    : 'Save a book from its detail page to find it here.',
              )
            : ListView(
                children: items
                    .map(
                      (book) => BookTile(
                        book,
                        footer: author != null
                            ? null
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(48, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () => bookmarks
                                      ? state.toggleBookmark(book.id)
                                      : state.toggleWishlist(book.id),
                                  child: const Text('REMOVE'),
                                ),
                              ),
                      ),
                    )
                    .toList(),
              ),
      );
    },
  );
}

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) => PageFrame(
      title: 'Cart',
      back: false,
      navigation: const MainNavigation(3),
      bottom: state.cart.isEmpty
          ? null
          : PrimaryButton(
              'Process to Checkout',
              onPressed: () => go(context, '/shipping-address'),
            ),
      body: state.cart.isEmpty
          ? const EmptyState(
              'Your basket is empty',
              'Find your next great read in our bookstore.',
            )
          : ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFFFAFAFA),
                  child: Text(
                    'You have ${state.count} items for a total of ${money(state.subtotal)} in your basket.',
                  ),
                ),
                for (final entry in state.cart.entries.toList())
                  BookTile(
                    books[entry.key],
                    footer: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Quantity',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFDDDDDD)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              key: ValueKey('quantity-${entry.key}'),
                              value: entry.value,
                              isDense: true,
                              style: const TextStyle(
                                color: muted,
                                fontSize: 13,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: muted,
                              ),
                              items: List.generate(
                                20,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1}'),
                                ),
                              ),
                              onChanged: (v) =>
                                  state.setQuantity(entry.key, v!),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove ${books[entry.key].title}',
                          icon: const Icon(Icons.close, size: 18, color: muted),
                          onPressed: () => state.setQuantity(entry.key, 0),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    ),
  );
}
