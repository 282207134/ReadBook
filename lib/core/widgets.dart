import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/catalog.dart';
import 'theme.dart';

void go(BuildContext context, String route, [Object? arguments]) =>
    Navigator.pushNamed(context, route, arguments: arguments);
void message(BuildContext context, String text) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
  );
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottom,
    this.navigation,
    this.back = true,
    this.leading,
  });
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottom, navigation, leading;
  final bool back;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      leading:
          leading ??
          (back
              ? IconButton(
                  tooltip: 'Back',
                  icon: const Icon(CupertinoIcons.back, color: muted),
                  onPressed: () => Navigator.maybePop(context),
                )
              : null),
      actions: actions,
    ),
    body: SafeArea(top: false, child: body),
    bottomNavigationBar: bottom == null && navigation == null
        ? null
        : SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (bottom != null)
                  Padding(padding: const EdgeInsets.all(16), child: bottom!),
                ?navigation,
              ],
            ),
          ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.text, {super.key, required this.onPressed});
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Opacity(
    opacity: onPressed == null ? .4 : 1,
    child: Container(
      height: 46,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: const LinearGradient(
          colors: [Color(0xFF79F1B4), Color(0xFF25C96F)],
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

class MainNavigation extends StatelessWidget {
  const MainNavigation(this.selected, {super.key});
  final int selected;
  static const routes = ['/home', '/search', '/wishlist', '/cart', '/profile'];
  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: line)),
    ),
    child: Row(
      children: List.generate(
        5,
        (i) => Expanded(
          child: Semantics(
            selected: selected == i,
            label: const ['Home', 'Search', 'Wishlist', 'Cart', 'Profile'][i],
            child: InkWell(
              key: ValueKey('nav-$i'),
              onTap: () {
                if (i == selected) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  routes[i],
                  (_) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    const [
                      CupertinoIcons.house,
                      CupertinoIcons.search,
                      CupertinoIcons.heart,
                      CupertinoIcons.bag,
                      CupertinoIcons.person,
                    ][i],
                    color: i == selected ? green : muted,
                    size: 25,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 24,
                    height: 2,
                    color: i == selected ? green : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class Cover extends StatelessWidget {
  const Cover(
    this.book, {
    super.key,
    this.width = 120,
    this.height = 187,
    this.shadow = false,
  });
  final Book book;
  final double width, height;
  final bool shadow;
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      boxShadow: shadow
          ? const [
              BoxShadow(
                color: Color(0x16000000),
                offset: Offset(0, 8),
                blurRadius: 14,
              ),
            ]
          : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(book.image, fit: BoxFit.cover),
    ),
  );
}

class Stars extends StatelessWidget {
  const Stars(this.value, {super.key, this.size = 15});
  final int value;
  final double size;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (i) => Icon(
        Icons.star,
        size: size,
        color: i < value ? const Color(0xFFFF6565) : const Color(0xFFD5D5D5),
      ),
    ),
  );
}

class BookTile extends StatelessWidget {
  const BookTile(this.book, {super.key, this.footer, this.trailing});
  final Book book;
  final Widget? footer, trailing;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: line)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => go(context, '/book', book),
          child: Cover(book, width: 72, height: 112),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stars(book.stars),
                  const Spacer(),
                  Text(
                    book.priceLabel,
                    style: const TextStyle(
                      color: green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () => go(context, '/book', book),
                child: Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'by ${book.author}',
                style: const TextStyle(color: muted, fontSize: 12),
              ),
              if (footer != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: footer!,
                ),
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.title, this.description, {super.key});
  final String title, description;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.book, color: muted, size: 44),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: muted),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (_) => false,
            ),
            child: const Text('Browse books'),
          ),
        ],
      ),
    ),
  );
}

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel(this.label, this.child, {super.key});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(label), const SizedBox(height: 7), child],
    ),
  );
}
