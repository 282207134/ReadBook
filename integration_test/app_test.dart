import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:readbook/app.dart';
import 'package:readbook/data/app_state.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('16 screens and complete checkout on Android', (tester) async {
    final state = AppState();
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(ReadBookApp(state: state, navigatorKey: nav));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    final screens = <String, String>{
      '01_home': '/home',
      '02_categories': '/categories',
      '03_category_detail': '/category',
      '04_book_detail': '/book',
      '05_authors': '/authors',
      '06_search': '/search',
      '07_filter': '/filter',
      '08_wishlist': '/wishlist',
      '09_bookmarks': '/bookmarks',
      '10_cart': '/cart',
      '11_profile': '/profile',
      '12_login': '/login',
      '13_signup': '/signup',
      '14_shipping_address': '/shipping-address',
      '15_shipping_options': '/shipping-options',
      '16_payment': '/payment',
    };
    for (final screen in screens.entries) {
      nav.currentState!.pushNamedAndRemoveUntil(screen.value, (_) => false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: screen.key);
      await binding.takeScreenshot(screen.key);
      if (screen.value == '/home' ||
          screen.value == '/book' ||
          screen.value == '/shipping-address') {
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -900));
        await tester.pumpAndSettle();
        await binding.takeScreenshot('${screen.key}_bottom');
      }
    }

    // Verify real UI events: search, save, quantity editing, and a demo order.
    nav.currentState!.pushNamedAndRemoveUntil('/search', (_) => false);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('search-input')), 'Blue');
    await tester.pumpAndSettle();
    expect(find.text('Blue Highways'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('17_search_results');
    await tester.tap(find.text('Blue Highways'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Basket - \$18.99'));
    await tester.pumpAndSettle();
    expect(state.cart[2], 1);

    nav.currentState!.pushNamedAndRemoveUntil('/cart', (_) => false);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quantity-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();
    expect(state.cart[1], 2);
    await tester.tap(find.text('Process to Checkout'));
    await tester.pumpAndSettle();
    for (final field in {
      'First Name': 'Alex',
      'Last Name': 'Reader',
      'Address Line': '123 Book Street',
      'State/Province': 'New York',
      'Post Code': '10001',
    }.entries) {
      final finder = find.byKey(ValueKey(field.key));
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        finder,
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(finder, field.value);
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Continue'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Shipping Options'), findsOneWidget);
    expect(state.address['First Name'], 'Alex');
    expect(state.address['Last Name'], 'Reader');
    expect(state.address['Address Line'], '123 Book Street');
    expect(state.address['Post Code'], '10001');
    await tester.tap(find.text('Standard (5-9 Business Days)'));
    await tester.pumpAndSettle();
    expect(state.shipping, 0);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paypal'));
    await tester.pumpAndSettle();
    final total = state.total;
    await tester.tap(find.text('Place Order'));
    await tester.pumpAndSettle();
    expect(find.text('Thank you for your order!'), findsOneWidget);
    expect(state.cart, isEmpty);
    expect(state.orders.single['total'], total);
    await binding.takeScreenshot('18_order_success');
    await tester.tap(find.text('View Order History'));
    await tester.pumpAndSettle();
    expect(find.text('Demo order confirmed'), findsOneWidget);
    await binding.takeScreenshot('19_order_history');
    expect(tester.takeException(), isNull);
  });
}
