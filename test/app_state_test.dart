import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readbook/data/app_state.dart';

void main() {
  test(
    'basket uses integer cents, clamps quantities, and removes zero quantities',
    () {
      final state = AppState();
      expect(state.subtotal, 3737);
      state.addToCart(1, 2);
      expect(state.count, 4);
      expect(state.subtotal, 7761);
      state.setQuantity(1, 100);
      expect(state.cart[1], 20);
      state.setQuantity(1, 0);
      expect(state.cart.containsKey(1), false);
      expect(state.subtotal, 1725);
    },
  );

  test('search combines query, category, author, and price filters', () {
    final state = AppState();
    expect(state.search('MATT HAIG').single.id, 1);
    state.setFilters(category: 'Fiction', min: 22);
    expect(state.search('').single.id, 5);
    state.setFilters(author: 'Steven Curran');
    expect(state.search('').single.id, 0);
    state.setFilters();
    expect(state.search('').length, 6);
    expect(state.search('missing title'), isEmpty);
  });

  test(
    'wishlist, basket, account, and orders survive reload; payment fields are absent',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final state = AppState(preferences);
      state.toggleWishlist(2);
      state.toggleBookmark(5);
      state.login('Reader');
      state.shipping = 1;
      state.address = {'First Name': 'Reader'};
      final id = state.placeOrder();
      await state.flush();
      final restored = AppState(preferences);
      expect(restored.wishlist.contains(2), true);
      expect(restored.bookmarks.contains(5), false);
      expect(restored.username, 'Reader');
      expect(restored.cart, isEmpty);
      expect(restored.orders.single['id'], id);
      expect(restored.orders.single['total'], 3936);
      final data = jsonDecode(preferences.getString('readbook.v1')!) as Map;
      expect(data.containsKey('password'), false);
      expect(data.containsKey('address'), false);
      expect(data.containsKey('cardNumber'), false);
    },
  );

  test('checkout requires a basket and an address', () {
    final state = AppState();
    expect(state.placeOrder, throwsStateError);
    state.cart.clear();
    state.address = {'First Name': 'Reader'};
    expect(state.placeOrder, throwsStateError);
  });

  test('broken local JSON falls back to demo data', () async {
    SharedPreferences.setMockInitialValues({'readbook.v1': '{bad json'});
    final state = AppState(await SharedPreferences.getInstance());
    expect(state.subtotal, 3737);
    expect(state.wishlist, {0, 1, 3});
  });
}
