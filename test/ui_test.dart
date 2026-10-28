import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbook/app.dart';
import 'package:readbook/data/app_state.dart';
import 'package:readbook/data/catalog.dart';

void main() {
  testWidgets('address validates fields that have scrolled out of view', (
    tester,
  ) async {
    final state = AppState();
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(ReadBookApp(state: state, navigatorKey: nav));
    nav.currentState!.pushNamed('/shipping-address');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Continue'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(
      find.text('First Name is required', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Post Code is required'), findsOneWidget);
    expect(state.address, isEmpty);
    expect(find.text('Shipping Options'), findsNothing);
  });
  testWidgets('all 16 Pixso pages render at a narrow phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey<NavigatorState>();
    await tester.pumpWidget(ReadBookApp(state: AppState(), navigatorKey: key));
    await tester.pumpAndSettle();
    for (final route in [
      '/home',
      '/categories',
      '/category',
      '/book',
      '/authors',
      '/search',
      '/filter',
      '/wishlist',
      '/bookmarks',
      '/cart',
      '/profile',
      '/login',
      '/signup',
      '/shipping-address',
      '/shipping-options',
      '/payment',
    ]) {
      key.currentState!.pushNamedAndRemoveUntil(route, (_) => false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: route);
    }
  });

  testWidgets('search shows matching books and a useful empty state', (
    tester,
  ) async {
    final state = AppState();
    final key = GlobalKey<NavigatorState>();
    await tester.pumpWidget(ReadBookApp(state: state, navigatorKey: key));
    key.currentState!.pushNamed('/search');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('search-input')),
      'Stop Time',
    );
    await tester.pumpAndSettle();
    expect(find.text('How to Stop Time'), findsOneWidget);
    expect(find.text('Blue Highways'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('search-input')),
      'not a book',
    );
    await tester.pumpAndSettle();
    expect(find.text('No books found'), findsOneWidget);
  });

  testWidgets(
    'adding a detail book updates the basket and wishlist toggle works',
    (tester) async {
      final state = AppState();
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(ReadBookApp(state: state, navigatorKey: key));
      key.currentState!.pushNamed('/book', arguments: books[2]);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Basket - \$18.99'));
      await tester.pumpAndSettle();
      expect(state.cart[2], 1);
      await tester.tap(find.byTooltip('Wishlist'));
      await tester.pumpAndSettle();
      expect(state.wishlist.contains(2), true);
    },
  );

  testWidgets('login rejects empty values and signs into the local account', (
    tester,
  ) async {
    final state = AppState();
    final key = GlobalKey<NavigatorState>();
    await tester.pumpWidget(ReadBookApp(state: state, navigatorKey: key));
    key.currentState!.pushNamed('/login');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    expect(find.text('Username is required'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('username')), 'Reader');
    await tester.enterText(find.byKey(const ValueKey('password')), 'demo123');
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    expect(state.username, 'Reader');
    expect(find.text('Profile'), findsOneWidget);
  });
}
