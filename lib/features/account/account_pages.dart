import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/app_state.dart';
import '../../data/catalog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) => PageFrame(
      title: 'Profile',
      back: false,
      navigation: const MainNavigation(4),
      body: ListView(
        children: [
          for (final label in [
            'My Account',
            'Order History',
            'My Library',
            'My Coupons',
            'Need help',
            'About this app',
          ])
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: line)),
              ),
              child: ListTile(
                minTileHeight: 50,
                title: Text(label, style: const TextStyle(fontSize: 14)),
                trailing: const Icon(
                  CupertinoIcons.chevron_right,
                  size: 22,
                  color: muted,
                ),
                onTap: () => _open(context, label),
              ),
            ),
        ],
      ),
    ),
  );

  void _open(BuildContext context, String label) {
    if (label == 'My Library') {
      go(context, '/bookmarks');
      return;
    }
    if (label == 'My Account' && state.username == null) {
      go(context, '/login');
      return;
    }
    if (label == 'Order History') {
      go(context, '/orders');
      return;
    }
    final text = switch (label) {
      'My Account' =>
        'Welcome, ${state.username}. Your demo account is stored on this device.',
      'My Coupons' =>
        'You have no coupons yet. Check back for future bookstore offers.',
      'Need help' =>
        'Browse books, save your favorites, and add books to your basket. Complete the three checkout steps to create a local demo order.',
      _ =>
        'Venus Bookstore 1.0.0\nA Flutter implementation of the supplied Pixso screens.\n\nThis is an offline demo. Login and payment do not contact external services or charge money.',
    };
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(label),
        content: Text(text),
        actions: [
          if (label == 'My Account')
            TextButton(
              onPressed: () {
                state.logout();
                Navigator.pop(dialogContext);
              },
              child: const Text('Log Out'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.state, this.signUp = false});
  final AppState state;
  final bool signUp;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final username = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController(),
      confirm = TextEditingController();
  @override
  void dispose() {
    for (final c in [username, email, password, confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!form.currentState!.validate()) return;
    widget.state.login(username.text);
    Navigator.pushNamedAndRemoveUntil(context, '/profile', (_) => false);
    message(
      context,
      widget.signUp
          ? 'Demo account created'
          : 'Welcome back, ${username.text.trim()}',
    );
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: widget.signUp ? 'Sign Up' : 'Login',
    body: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 20),
            child: IntrinsicHeight(
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _input('Username', username, keyName: 'username'),
                    const SizedBox(height: 16),
                    if (widget.signUp) ...[
                      _input('Email address', email, emailField: true),
                      const SizedBox(height: 16),
                    ],
                    _input(
                      'Password',
                      password,
                      secret: true,
                      keyName: 'password',
                    ),
                    const SizedBox(height: 16),
                    if (widget.signUp) ...[
                      _input(
                        'Retype Password',
                        confirm,
                        secret: true,
                        match: true,
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      Center(
                        child: TextButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Forgot password?'),
                              content: const Text(
                                'Demo mode accepts any username and a password with at least 6 characters. No account is created on a server.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Got it'),
                                ),
                              ],
                            ),
                          ),
                          style: TextButton.styleFrom(foregroundColor: green),
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    PrimaryButton(
                      widget.signUp ? 'Sign Up' : 'Log In',
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Local demo account · no server authentication',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                    const Spacer(),
                    if (!widget.signUp) ...[
                      _social('Login with Facebook', const Color(0xFF3B5998)),
                      const SizedBox(height: 10),
                      _social(
                        'Login with Google Plus',
                        const Color(0xFFDB4437),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () => go(context, '/signup'),
                          style: TextButton.styleFrom(foregroundColor: green),
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _social(String text, Color color) => SizedBox(
    height: 46,
    child: TextButton(
      onPressed: () => message(
        context,
        'Social sign-in is unavailable in this offline demo. Use the login form.',
      ),
      style: TextButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    ),
  );

  Widget _input(
    String hint,
    TextEditingController controller, {
    bool secret = false,
    bool emailField = false,
    bool match = false,
    String? keyName,
  }) => TextFormField(
    key: keyName == null ? null : ValueKey(keyName),
    controller: controller,
    obscureText: secret,
    keyboardType: emailField ? TextInputType.emailAddress : TextInputType.text,
    autocorrect: !secret,
    decoration: InputDecoration(hintText: hint),
    validator: (value) {
      if (value == null || value.trim().isEmpty) return '$hint is required';
      if (match && value != password.text) return 'Passwords do not match';
      if (secret && value.length < 6) return 'Use at least 6 characters';
      if (emailField &&
          !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
        return 'Enter a valid email';
      }
      return null;
    },
  );
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Order History',
    body: state.orders.isEmpty
        ? const EmptyState(
            'No orders yet',
            'Your demo orders will appear here after checkout.',
          )
        : ListView(
            children: [
              for (final order in state.orders)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: line)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['id'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${order['count']} books · ${money(order['total'] as int)}',
                      ),
                      Text(
                        order['shipping'] as String,
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Demo order confirmed',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
            ],
          ),
  );
}
