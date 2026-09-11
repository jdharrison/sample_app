import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/core/models/commerce.dart';
import 'package:sample_app/core/services/store.dart';
import 'package:sample_app/features/cart/cart_page.dart';
import 'package:sample_app/features/checkout/riptide_checkout.dart';

class _ControlledOrderService implements OrderService {
  int calls = 0;
  Customer? customer;
  List<CartItem>? items;
  Completer<Order> pending = Completer<Order>();

  @override
  Future<Order> placeOrder({
    required Customer customer,
    required List<CartItem> items,
  }) {
    calls++;
    this.customer = customer;
    this.items = items;
    return pending.future;
  }
}

Future<void> _mount(
  WidgetTester tester,
  Store store, {
  OrderService? service,
  String initialLocation = '/checkout',
}) async {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/checkout',
        builder: (_, _) => Scaffold(
          body: RiptideCheckout(store: store, orderService: service),
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (_, _) => Scaffold(body: CartPage(store: store)),
      ),
      GoRoute(
        path: '/shop',
        builder: (_, _) => const Scaffold(body: Text('Shop destination')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String label) async {
  final finder = find.text(label);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _fill(WidgetTester tester, String label, String value) async {
  final finder = find.widgetWithText(TextFormField, label);
  await tester.ensureVisible(finder);
  await tester.enterText(finder, value);
  await tester.pump();
}

Future<void> _customer(WidgetTester tester, {bool pickup = false}) async {
  await _fill(tester, 'Full name', 'Demo Keeper');
  await _fill(tester, 'Email address', 'keeper@example.com');
  await _fill(tester, 'Phone number', '+1 555 010 1234');
  if (pickup) {
    await _tap(tester, 'Store pickup · Free demo');
  } else {
    await _fill(
      tester,
      'Delivery address',
      '123 Demo St, Portland, OR 97201, USA',
    );
  }
  await _fill(tester, 'Order notes (optional)', 'Fictional order for testing');
  await _tap(tester, 'Continue to mock payment');
}

void main() {
  testWidgets('validates labeled customer fields and delivery address', (
    tester,
  ) async {
    final store = Store()..add(mockProducts.first);
    addTearDown(store.dispose);
    await _mount(tester, store);
    await _tap(tester, 'Continue to mock payment');
    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(
      find.text('Enter a valid phone number (7–15 digits)'),
      findsOneWidget,
    );
    expect(find.text('Enter your delivery address'), findsOneWidget);
    expect(find.text('Step 2 of 3 · Mock payment'), findsNothing);

    await _fill(tester, 'Full name', 'Demo Keeper');
    await _fill(tester, 'Email address', 'not-an-email');
    await _fill(tester, 'Phone number', 'abc1234567');
    await _fill(tester, 'Delivery address', '   ');
    await _tap(tester, 'Continue to mock payment');
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(
      find.text('Enter a valid phone number (7–15 digits)'),
      findsOneWidget,
    );
    expect(find.text('Enter your delivery address'), findsOneWidget);
    expect(store.cartCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'default mock pickup checkout retains snapshot after clearing cart',
    (tester) async {
      final store = Store()..add(mockProducts.first, quantity: 2);
      addTearDown(store.dispose);
      final total = store.subtotalLabel;
      await _mount(tester, store);
      await _customer(tester, pickup: true);
      expect(find.text('No cards. No charges.'), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
      await _tap(tester, 'Review demo order');
      expect(find.text('Demo Keeper'), findsOneWidget);
      expect(find.text('keeper@example.com'), findsOneWidget);
      expect(find.text('Demo total: $total'), findsOneWidget);
      expect(find.text('Pickup: Free demo (\$0.00)'), findsOneWidget);
      expect(
        find.text('Taxes: Not applied in this demo (\$0.00)'),
        findsOneWidget,
      );
      await _tap(tester, 'Place demo order');
      expect(store.cart, isEmpty);
      expect(find.text('Demo order confirmed'), findsOneWidget);
      expect(find.textContaining('Fake order ID: RIP-DEMO-'), findsOneWidget);

      // The order view must not read the now-empty (or subsequently changed) cart.
      store.add(mockProducts.last);
      await _tap(tester, 'View Order');
      expect(find.text('Your demo order'), findsOneWidget);
      expect(find.text('Demo total: $total'), findsOneWidget);
      expect(
        find.textContaining('${mockProducts.first.name}\n2 ×'),
        findsOneWidget,
      );
      expect(find.textContaining(mockProducts.last.name), findsNothing);
      expect(find.text('Demo Keeper'), findsOneWidget);
      await _tap(tester, 'Continue Shopping');
      expect(find.text('Shop destination'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'delivery submit is single-flight, preserves cart on error and retries',
    (tester) async {
      final store = Store()..add(mockProducts.first);
      final service = _ControlledOrderService();
      addTearDown(store.dispose);
      await _mount(tester, store, service: service);
      await _customer(tester);
      await _tap(tester, 'Review demo order');
      expect(
        find.text('Shipping: Free demo delivery (\$0.00)'),
        findsOneWidget,
      );
      expect(find.text('123 Demo St, Portland, OR 97201, USA'), findsOneWidget);
      final submit = find.widgetWithText(FilledButton, 'Place demo order');
      await tester.ensureVisible(submit);
      await tester.pumpAndSettle();
      final callback = tester.widget<FilledButton>(submit).onPressed!;
      callback();
      callback();
      await tester.pump();
      expect(service.calls, 1);
      expect(store.cartCount, 1);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Placing demo order…'),
            )
            .onPressed,
        isNull,
      );
      expect(service.customer!.notes, contains('Fulfillment: delivery'));

      service.pending.completeError(StateError('Test failure'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Your cart is saved. Please try again.'),
        findsOneWidget,
      );
      expect(store.cartCount, 1);
      service.pending = Completer<Order>();
      await tester.ensureVisible(find.text('Place demo order'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Place demo order'));
      await tester.pump();
      expect(service.calls, 2);
      service.pending.complete(
        Order(
          id: 'RIP-DEMO-TEST',
          customer: service.customer!,
          items: service.items!,
          createdAt: DateTime.utc(2026),
        ),
      );
      await tester.pumpAndSettle();
      expect(store.cart, isEmpty);
      expect(find.text('Fake order ID: RIP-DEMO-TEST'), findsOneWidget);
      await _tap(tester, 'View Order');
      expect(find.text('123 Demo St, Portland, OR 97201, USA'), findsOneWidget);
      expect(
        find.textContaining('Fictional order for testing'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty checkout is guarded and responds when cart empties', (
    tester,
  ) async {
    final store = Store()..add(mockProducts.first);
    addTearDown(store.dispose);
    await _mount(tester, store);
    store.clearCart();
    await tester.pumpAndSettle();
    expect(
      find.text('Your cart is empty. Add an item before checking out.'),
      findsOneWidget,
    );
    expect(find.text('Continue to mock payment'), findsNothing);
    await _tap(tester, 'Continue Shopping');
    expect(find.text('Shop destination'), findsOneWidget);
  });

  testWidgets(
    'cart supports quantity, subtotal, removal and checkout navigation on phone',
    (tester) async {
      final store = Store()..add(mockProducts.first);
      addTearDown(store.dispose);
      await _mount(tester, store, initialLocation: '/cart');
      await tester.tap(
        find.byTooltip('Increase quantity of ${mockProducts.first.name}'),
      );
      await tester.pumpAndSettle();
      expect(store.cartCount, 2);
      expect(
        find.text('Subtotal (2 items): ${store.subtotalLabel}'),
        findsOneWidget,
      );
      await tester.tap(
        find.byTooltip('Decrease quantity of ${mockProducts.first.name}'),
      );
      await tester.pumpAndSettle();
      expect(store.cartCount, 1);
      await _tap(tester, 'Proceed to checkout');
      expect(find.text('Checkout'), findsOneWidget);
      await _tap(tester, 'Back to cart');
      await _tap(tester, 'Remove');
      expect(store.cart, isEmpty);
      expect(
        find.text('Your cart is empty. Find something for your aquarium.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
