import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/commerce.dart';
import '../../core/services/store.dart';

enum _Stage { customer, payment, review, confirmation, order }

enum _Fulfillment { delivery, pickup }

/// Provider-independent mock checkout body; the shell owns the scaffold.
class RiptideCheckout extends StatefulWidget {
  const RiptideCheckout({super.key, required this.store, this.orderService});

  final Store store;
  final OrderService? orderService;

  @override
  State<RiptideCheckout> createState() => _RiptideCheckoutState();
}

class _RiptideCheckoutState extends State<RiptideCheckout> {
  final _form = GlobalKey<FormState>();
  final _scroll = ScrollController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _notes = TextEditingController();
  final OrderService _defaultService = MockOrderService();
  _Stage _stage = _Stage.customer;
  _Fulfillment _fulfillment = _Fulfillment.delivery;
  _Fulfillment? _orderedFulfillment;
  Order? _order;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _scroll.dispose();
    for (final controller in [_name, _email, _phone, _address, _notes]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _goTo(_Stage stage) {
    FocusScope.of(context).unfocus();
    setState(() {
      _stage = stage;
      _error = null;
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Customer get _customer => Customer(
    name: _name.text.trim(),
    email: _email.text.trim(),
    phone: _phone.text.trim(),
    // The service requires an address even for a pickup order.
    address: _fulfillment == _Fulfillment.pickup
        ? 'Store pickup (demo; no delivery address required)'
        : _address.text.trim(),
    notes:
        'Fulfillment: ${_fulfillment.name} (demo).'
        '${_notes.text.trim().isEmpty ? '' : '\n${_notes.text.trim()}'}',
  );

  Future<void> _submit() async {
    if (_submitting || _order != null || widget.store.cart.isEmpty) return;
    final store = widget.store;
    final items = List<CartItem>.unmodifiable(store.cart);
    final customer = _customer;
    final fulfillment = _fulfillment;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final order = await (widget.orderService ?? _defaultService).placeOrder(
        customer: customer,
        items: items,
      );
      if (mounted) {
        setState(() {
          _order = order;
          _orderedFulfillment = fulfillment;
          _stage = _Stage.confirmation;
        });
      }
      // Only a successful service response may clear the cart.
      store.clearCart();
      if (mounted && _scroll.hasClients) _scroll.jumpTo(0);
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'We could not create your demo order. Your cart is saved. Please try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) => SingleChildScrollView(
      controller: _scroll,
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                liveRegion: true,
                child: Text(switch (_stage) {
                  _Stage.confirmation => 'Demo order confirmed',
                  _Stage.order => 'Your demo order',
                  _ => 'Checkout',
                }, style: Theme.of(context).textTheme.headlineLarge),
              ),
              const SizedBox(height: 12),
              const Text(
                'Demo only. No real payment, email, shipment, or pickup reservation is made.',
              ),
              const SizedBox(height: 24),
              if (_order != null)
                ..._completed()
              else if (widget.store.cart.isEmpty && !_submitting) ...[
                const Text(
                  'Your cart is empty. Add an item before checking out.',
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go('/shop'),
                  child: const Text('Continue Shopping'),
                ),
              ] else ...[
                Text(switch (_stage) {
                  _Stage.customer => 'Step 1 of 3 · Customer & delivery',
                  _Stage.payment => 'Step 2 of 3 · Mock payment',
                  _ => 'Step 3 of 3 · Review',
                }, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                if (_stage == _Stage.customer) _customerForm(),
                if (_stage == _Stage.payment) ..._payment(),
                if (_stage == _Stage.review) ...[
                  _summary(_customer, widget.store.cart, _fulfillment),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: Text(
                      _submitting ? 'Placing demo order…' : 'Place demo order',
                    ),
                  ),
                  if (_submitting)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: LinearProgressIndicator(
                        semanticsLabel: 'Placing demo order',
                      ),
                    ),
                  TextButton(
                    onPressed: _submitting
                        ? null
                        : () => _goTo(_Stage.customer),
                    child: const Text('Edit customer & delivery'),
                  ),
                  TextButton(
                    onPressed: _submitting ? null : () => _goTo(_Stage.payment),
                    child: const Text('Back to mock payment'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    ),
  );

  Widget _customerForm() => Form(
    key: _form,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Use fictional contact details for this demo.'),
        const SizedBox(height: 16),
        _field(
          controller: _name,
          label: 'Full name',
          validator: (value) =>
              value!.trim().isEmpty ? 'Enter your full name' : null,
          keyboard: TextInputType.name,
        ),
        _field(
          controller: _email,
          label: 'Email address',
          keyboard: TextInputType.emailAddress,
          validator: (value) =>
              RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim())
              ? null
              : 'Enter a valid email address',
        ),
        _field(
          controller: _phone,
          label: 'Phone number',
          keyboard: TextInputType.phone,
          validator: (value) {
            final text = value!.trim();
            final digits = text.replaceAll(RegExp(r'\D'), '');
            return RegExp(r'^\+?[\d\s().-]+$').hasMatch(text) &&
                    digits.length >= 7 &&
                    digits.length <= 15
                ? null
                : 'Enter a valid phone number (7–15 digits)';
          },
        ),
        Text('Delivery method', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Delivery · Free demo'),
              selected: _fulfillment == _Fulfillment.delivery,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onSelected: (_) =>
                  setState(() => _fulfillment = _Fulfillment.delivery),
            ),
            ChoiceChip(
              label: const Text('Store pickup · Free demo'),
              selected: _fulfillment == _Fulfillment.pickup,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onSelected: (_) =>
                  setState(() => _fulfillment = _Fulfillment.pickup),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_fulfillment == _Fulfillment.delivery)
          _field(
            controller: _address,
            label: 'Delivery address',
            hint: 'Street, city, region, postal code, country',
            keyboard: TextInputType.streetAddress,
            maxLines: 3,
            validator: (value) =>
                value!.trim().isEmpty ? 'Enter your delivery address' : null,
          )
        else
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Demo store pickup: no address needed and no pickup is scheduled.',
            ),
          ),
        _field(
          controller: _notes,
          label: 'Order notes (optional)',
          maxLines: 3,
        ),
        FilledButton(
          onPressed: () {
            if (_form.currentState!.validate()) _goTo(_Stage.payment);
          },
          child: const Text('Continue to mock payment'),
        ),
        TextButton(
          onPressed: () => context.go('/cart'),
          child: const Text('Back to cart'),
        ),
      ],
    ),
  );

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboard,
    int maxLines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        helperText: hint,
        helperMaxLines: 3,
        border: const OutlineInputBorder(),
      ),
      keyboardType:
          keyboard ??
          (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : TextInputAction.next,
      maxLines: maxLines,
      validator: validator,
    ),
  );

  List<Widget> _payment() => [
    const Icon(Icons.science_outlined, size: 48),
    const SizedBox(height: 16),
    Text(
      'No cards. No charges.',
      style: Theme.of(context).textTheme.titleLarge,
    ),
    const SizedBox(height: 12),
    const Text(
      'This checkout simulates payment only. Do not enter card numbers or bank details. No payment provider is contacted and no money is collected.',
    ),
    const SizedBox(height: 24),
    FilledButton(
      onPressed: () => _goTo(_Stage.review),
      child: const Text('Review demo order'),
    ),
    TextButton(
      onPressed: () => _goTo(_Stage.customer),
      child: const Text('Back to customer details'),
    ),
  ];

  Widget _summary(
    Customer customer,
    List<CartItem> items,
    _Fulfillment fulfillment,
  ) {
    final subtotal = items.fold<int>(0, (sum, item) => sum + item.totalCents);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Customer', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(customer.name),
            Text(customer.email),
            Text(customer.phone),
            const SizedBox(height: 16),
            Text(
              fulfillment == _Fulfillment.delivery
                  ? 'Delivery · Free demo'
                  : 'Store pickup · Free demo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(customer.address),
            if (customer.notes.isNotEmpty) Text(customer.notes),
            const Divider(height: 32),
            Text('Items', style: Theme.of(context).textTheme.titleLarge),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '${item.product.name}\n${item.quantity} × ${item.product.priceLabel} = ${item.priceLabel}',
                ),
              ),
            const Divider(height: 24),
            Text('Subtotal: ${formatPrice(subtotal)}'),
            Text(
              fulfillment == _Fulfillment.delivery
                  ? 'Shipping: Free demo delivery (\$0.00)'
                  : 'Pickup: Free demo (\$0.00)',
            ),
            const Text('Taxes: Not applied in this demo (\$0.00)'),
            const SizedBox(height: 8),
            Text(
              'Demo total: ${formatPrice(subtotal)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text('Mock payment · Nothing is charged.'),
          ],
        ),
      ),
    );
  }

  List<Widget> _completed() => [
    const Icon(Icons.check_circle_outline, size: 56),
    const SizedBox(height: 16),
    const Text(
      'Your simulated order was created. This is not a real purchase.',
    ),
    const SizedBox(height: 8),
    SelectableText('Fake order ID: ${_order!.id}'),
    const SizedBox(height: 16),
    if (_stage == _Stage.order)
      _summary(_order!.customer, _order!.items, _orderedFulfillment!)
    else
      OutlinedButton(
        onPressed: () => _goTo(_Stage.order),
        child: const Text('View Order'),
      ),
    const SizedBox(height: 16),
    FilledButton(
      onPressed: () => context.go('/shop'),
      child: const Text('Continue Shopping'),
    ),
  ];
}
