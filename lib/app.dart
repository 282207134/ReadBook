import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/widgets.dart';
import 'data/app_state.dart';
import 'data/catalog.dart';
import 'features/account/account_pages.dart';
import 'features/catalog/book_page.dart';
import 'features/catalog/browse_pages.dart';
import 'features/catalog/home_page.dart';
import 'features/catalog/search_pages.dart';
import 'features/checkout/checkout_pages.dart';
import 'features/collection/collection_pages.dart';

class ReadBookApp extends StatelessWidget {
  const ReadBookApp({super.key, required this.state, this.navigatorKey});
  final AppState state;
  final GlobalKey<NavigatorState>? navigatorKey;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Venus Bookstore',
    debugShowCheckedModeBanner: false,
    theme: bookstoreTheme(),
    navigatorKey: navigatorKey,
    initialRoute: '/home',
    onGenerateRoute: (settings) {
      final page = switch (settings.name) {
        '/home' || '/' => const HomePage(),
        '/categories' => const CategoriesPage(),
        '/category' => BookGridPage(
          title: settings.arguments as String? ?? 'Art & Photography',
        ),
        '/book' => BookPage(
          book: settings.arguments as Book? ?? books[2],
          state: state,
        ),
        '/authors' => const AuthorsPage(),
        '/author' => CollectionPage(
          state: state,
          author: settings.arguments as String? ?? 'Steven Curran',
        ),
        '/search' => SearchPage(state: state),
        '/filter' => FilterPage(state: state),
        '/wishlist' => CollectionPage(state: state),
        '/bookmarks' => CollectionPage(state: state, bookmarks: true),
        '/cart' => CartPage(state: state),
        '/profile' => ProfilePage(state: state),
        '/login' => AuthPage(state: state),
        '/signup' => AuthPage(state: state, signUp: true),
        '/shipping-address' => AddressPage(state: state),
        '/shipping-options' => ShippingPage(state: state),
        '/payment' => PaymentPage(state: state),
        '/orders' => OrdersPage(state: state),
        '/order-success' => OrderSuccessPage(
          order: settings.arguments as Map<String, dynamic>,
        ),
        _ => const PageFrame(
          title: 'Page not found',
          body: EmptyState(
            'Page not found',
            'Return to the bookstore to continue.',
          ),
        ),
      };
      return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
    },
  );
}
