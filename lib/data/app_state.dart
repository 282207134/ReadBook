import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'catalog.dart';

/// UI state and local demo repository. Prices are integer cents.
class AppState extends ChangeNotifier {
  AppState([this.preferences]) {
    final raw = preferences?.getString('readbook.v1');
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final savedWishlist = _ids(data['wishlist']);
      final savedBookmarks = _ids(data['bookmarks']);
      final savedCart = {
        for (final e in (data['cart'] as Map<String, dynamic>).entries)
          if (int.tryParse(e.key) case final int id)
            if (id >= 0 && id < books.length && e.value is int && e.value > 0)
              id: (e.value as int).clamp(1, 20),
      };
      final savedUsername = data['username'] as String?;
      final savedOrders = (data['orders'] as List)
          .cast<Map<String, dynamic>>()
          .toList();
      wishlist = savedWishlist;
      bookmarks = savedBookmarks;
      cart = savedCart;
      username = savedUsername;
      orders = savedOrders;
    } catch (_) {
      // Ignore an incompatible local cache and retain the demo defaults.
    }
  }

  final SharedPreferences? preferences;
  Set<int> wishlist = {0, 1, 3};
  Set<int> bookmarks = {0, 1, 3, 5};
  Map<int, int> cart = {1: 1, 3: 1};
  List<Map<String, dynamic>> orders = [];
  String? username;
  Map<String, String> address = {};
  int shipping = 2;
  String payment = 'Credit Card';
  String? authorFilter, categoryFilter;
  double minPrice = 0, maxPrice = 70;
  Future<void> _pendingSave = Future.value();

  static Set<int> _ids(dynamic value) => (value as List)
      .whereType<int>()
      .where((i) => i >= 0 && i < books.length)
      .toSet();

  int get count => cart.values.fold(0, (a, b) => a + b);
  int get subtotal =>
      cart.entries.fold(0, (sum, e) => sum + books[e.key].price * e.value);
  int get total => subtotal + shippingPrices[shipping];
  bool get filtered =>
      authorFilter != null ||
      categoryFilter != null ||
      minPrice > 0 ||
      maxPrice < 70;

  List<Book> search(String query) => books.where((book) {
    final text = '${book.title} ${book.author} ${book.category}'.toLowerCase();
    return text.contains(query.toLowerCase().trim()) &&
        (authorFilter == null || book.author == authorFilter) &&
        (categoryFilter == null || book.category == categoryFilter) &&
        book.price >= minPrice * 100 &&
        book.price <= maxPrice * 100;
  }).toList();

  void toggleWishlist(int id) {
    wishlist.contains(id) ? wishlist.remove(id) : wishlist.add(id);
    _changed();
  }

  void toggleBookmark(int id) {
    bookmarks.contains(id) ? bookmarks.remove(id) : bookmarks.add(id);
    _changed();
  }

  void addToCart(int id, [int quantity = 1]) {
    cart[id] = ((cart[id] ?? 0) + quantity).clamp(1, 20);
    _changed();
  }

  void setQuantity(int id, int quantity) {
    if (quantity <= 0) {
      cart.remove(id);
    } else {
      cart[id] = quantity.clamp(1, 20);
    }
    _changed();
  }

  void login(String name) {
    username = name.trim();
    _changed();
  }

  void logout() {
    username = null;
    _changed();
  }

  void setFilters({
    String? author,
    String? category,
    double min = 0,
    double max = 70,
  }) {
    authorFilter = author;
    categoryFilter = category;
    minPrice = min;
    maxPrice = max;
    notifyListeners();
  }

  String placeOrder() {
    if (cart.isEmpty) throw StateError('Your basket is empty.');
    if (address.isEmpty) throw StateError('A shipping address is required.');
    final id = 'VB-${DateTime.now().millisecondsSinceEpoch}';
    orders.insert(0, {
      'id': id,
      'total': total,
      'count': count,
      'items': [
        for (final e in cart.entries) {'bookId': e.key, 'quantity': e.value},
      ],
      'shipping': shippingNames[shipping],
      'payment': payment,
    });
    cart.clear();
    _changed();
    return id;
  }

  Future<void> flush() => _pendingSave;

  void _changed() {
    notifyListeners();
    final raw = jsonEncode({
      'wishlist': wishlist.toList(),
      'bookmarks': bookmarks.toList(),
      'cart': cart.map((k, v) => MapEntry('$k', v)),
      'username': username,
      'orders': orders,
    });
    // Serial saves prevent an older tap from overwriting a later update.
    _pendingSave = _pendingSave.then((_) async {
      await preferences?.setString('readbook.v1', raw);
    });
  }
}
