import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/app_state.dart';
import '../../data/catalog.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key, required this.state});
  final AppState state;
  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final form = GlobalKey<FormState>();
  final values = <String, String>{};
  String country = 'United States', city = 'New York';
  @override
  void initState() {
    super.initState();
    values.addAll(widget.state.address);
    country = values['Country'] ?? country;
    city = values['City'] ?? city;
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Shipping Address',
    body: Form(
      key: form,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final label in [
              'First Name',
              'Last Name',
              'Address Line',
              'Address Line 2',
            ])
              _field(label),
            FormFieldLabel(
              'Country',
              DropdownButtonFormField<String>(
                initialValue: country,
                items: ['United States', 'Japan', 'United Kingdom', 'China']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() {
                  country = v!;
                  city = _cities(country).first;
                }),
              ),
            ),
            FormFieldLabel(
              'City',
              DropdownButtonFormField<String>(
                key: ValueKey(country),
                initialValue: city,
                items: _cities(country)
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => city = v!),
              ),
            ),
            _field('State/Province'),
            _field('Post Code'),
            PrimaryButton(
              'Continue',
              onPressed: () {
                if (!form.currentState!.validate()) return;
                form.currentState!.save();
                widget.state.address = {
                  ...values,
                  'Country': country,
                  'City': city,
                };
                FocusScope.of(context).unfocus();
                go(context, '/shipping-options');
              },
            ),
          ],
        ),
      ),
    ),
  );

  List<String> _cities(String country) => switch (country) {
    'Japan' => ['Tokyo', 'Osaka', 'Kyoto'],
    'United Kingdom' => ['London', 'Manchester'],
    'China' => ['Shanghai', 'Beijing', 'Shenzhen'],
    _ => ['New York', 'San Francisco', 'Los Angeles'],
  };

  Widget _field(String label) => FormFieldLabel(
    label,
    TextFormField(
      key: ValueKey(label),
      initialValue: values[label],
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(),
      onSaved: (v) => values[label] = v!.trim(),
      validator: (v) =>
          label != 'Address Line 2' && (v == null || v.trim().isEmpty)
          ? '$label is required'
          : null,
    ),
  );
}

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key, required this.state});
  final AppState state;
  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Shipping Options',
    bottom: PrimaryButton('Continue', onPressed: () => go(context, '/payment')),
    body: Column(
      children: [
        RadioGroup<int>(
          groupValue: widget.state.shipping,
          onChanged: (v) => setState(() => widget.state.shipping = v!),
          child: Column(
            children: List.generate(
              4,
              (i) => Container(
                color: widget.state.shipping == i
                    ? const Color(0xFFF8F8F8)
                    : Colors.white,
                child: RadioListTile<int>(
                  value: i,
                  activeColor: blue,
                  contentPadding: const EdgeInsets.only(left: 4, right: 16),
                  title: Text(
                    shippingNames[i],
                    style: const TextStyle(fontSize: 13, color: ink),
                  ),
                  secondary: Text(
                    i == 0 ? 'FREE' : money(shippingPrices[i]),
                    style: TextStyle(
                      color: i == 0 ? Colors.redAccent : green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.state});
  final AppState state;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final form = GlobalKey<FormState>();
  String month = 'MM', year = 'YY';
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Billing and Payment',
    bottom: PrimaryButton('Place Order', onPressed: _placeOrder),
    body: Form(
      key: form,
      child: ListView(
        children: [
          RadioGroup<String>(
            groupValue: widget.state.payment,
            onChanged: (v) => setState(() => widget.state.payment = v!),
            child: Column(
              children: ['Credit Card', 'Paypal']
                  .map(
                    (type) => Container(
                      color: type == widget.state.payment
                          ? const Color(0xFFF8F8F8)
                          : Colors.white,
                      child: RadioListTile<String>(
                        value: type,
                        activeColor: blue,
                        contentPadding: const EdgeInsets.only(
                          left: 4,
                          right: 16,
                        ),
                        title: Text(
                          type,
                          style: const TextStyle(fontSize: 14, color: ink),
                        ),
                        secondary: Text(
                          type == 'Paypal' ? 'PayPal' : 'VISA',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF253B80),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.state.payment == 'Credit Card') ...[
                  FormFieldLabel(
                    'Number Card',
                    TextFormField(
                      key: const ValueKey('card-number'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                      ],
                      validator: (v) => v == null || v.length < 13
                          ? 'Enter 13–19 digits'
                          : null,
                    ),
                  ),
                  FormFieldLabel(
                    'Name Card',
                    TextFormField(
                      key: const ValueKey('card-name'),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Cardholder name is required'
                          : null,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: FormFieldLabel(
                          'Expiry Date',
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: month,
                                  isExpanded: true,
                                  items:
                                      [
                                            'MM',
                                            ...List.generate(
                                              12,
                                              (i) => '${i + 1}'.padLeft(2, '0'),
                                            ),
                                          ]
                                          .map(
                                            (v) => DropdownMenuItem(
                                              value: v,
                                              child: Text(v),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (v) => setState(() => month = v!),
                                  validator: (v) => v == 'MM' ? 'Month' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: year,
                                  isExpanded: true,
                                  items:
                                      [
                                            'YY',
                                            ...List.generate(
                                              12,
                                              (i) =>
                                                  '${DateTime.now().year + i}'
                                                      .substring(2),
                                            ),
                                          ]
                                          .map(
                                            (v) => DropdownMenuItem(
                                              value: v,
                                              child: Text(v),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (v) => setState(() => year = v!),
                                  validator: (v) => v == 'YY' ? 'Year' : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: FormFieldLabel(
                          'CVV',
                          TextFormField(
                            key: const ValueKey('cvv'),
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (v) =>
                                v == null || v.length < 3 ? '3–4 digits' : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'PayPal is simulated locally. No external payment will be made.',
                    ),
                  ),
                const Text(
                  'Demo checkout · no real payment',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                _summary('Books', money(widget.state.subtotal)),
                _summary(
                  'Shipping',
                  money(shippingPrices[widget.state.shipping]),
                ),
                _summary('Total', money(widget.state.total), total: true),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _summary(String label, String value, {bool total = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Text(label),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: total ? green : ink,
            fontWeight: total ? FontWeight.w600 : null,
          ),
        ),
      ],
    ),
  );

  void _placeOrder() {
    if (widget.state.cart.isEmpty) {
      message(context, 'Your basket is empty');
      return;
    }
    if (widget.state.address.isEmpty) {
      message(context, 'Complete your shipping address first');
      return;
    }
    if (widget.state.payment == 'Credit Card') {
      if (!form.currentState!.validate()) return;
      final expiry = DateTime(2000 + int.parse(year), int.parse(month) + 1);
      if (expiry.isBefore(DateTime.now())) {
        message(context, 'This card has expired');
        return;
      }
    }
    final total = widget.state.total;
    final id = widget.state.placeOrder();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/order-success',
      (_) => false,
      arguments: {'id': id, 'total': total},
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key, required this.order});
  final Map<String, dynamic> order;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Order Confirmed',
    back: false,
    bottom: PrimaryButton(
      'Continue Shopping',
      onPressed: () =>
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: green, size: 72),
            const SizedBox(height: 24),
            const Text(
              'Thank you for your order!',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            Text(order['id'] as String),
            const SizedBox(height: 8),
            Text(
              money(order['total'] as int),
              style: const TextStyle(color: green, fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your demo order has been saved on this device.\nNo payment was charged.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),
            TextButton(
              onPressed: () => go(context, '/orders'),
              child: const Text('View Order History'),
            ),
          ],
        ),
      ),
    ),
  );
}
