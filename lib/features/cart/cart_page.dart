import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/commerce.dart';
import '../../core/services/store.dart';

/// A scrollable body for the application's shared scaffold.
class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your cart',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              if (store.cart.isEmpty) ...[
                const Text(
                  'Your cart is empty. Find something for your aquarium.',
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: () => context.go('/shop'),
                    child: const Text('Continue Shopping'),
                  ),
                ),
              ] else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final lines = Column(
                      children: [
                        for (final item in store.cart) _line(context, item),
                      ],
                    );
                    final summary = Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Order summary',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Subtotal (${store.cartCount} items): ${store.subtotalLabel}',
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Demo checkout: free delivery or pickup. No taxes or real charges.',
                            ),
                            const SizedBox(height: 20),
                            FilledButton(
                              onPressed: () => context.go('/checkout'),
                              child: const Text('Proceed to checkout'),
                            ),
                            TextButton(
                              onPressed: () => context.go('/shop'),
                              child: const Text('Continue Shopping'),
                            ),
                          ],
                        ),
                      ),
                    );
                    if (constraints.maxWidth < 760) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [lines, const SizedBox(height: 16), summary],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: lines),
                        const SizedBox(width: 24),
                        SizedBox(width: 320, child: summary),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _line(BuildContext context, CartItem item) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.product.imageAsset,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                  errorBuilder: (_, _, _) => const SizedBox(
                    width: 64,
                    height: 64,
                    child: Icon(Icons.water),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${item.product.priceLabel} ${item.product.unitLabel}',
                    ),
                    Text('Line total: ${item.priceLabel}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                tooltip: 'Decrease quantity of ${item.product.name}',
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: () =>
                    store.setQuantity(item.product.id, item.quantity - 1),
                icon: const Icon(Icons.remove),
              ),
              Semantics(
                liveRegion: true,
                label: 'Quantity of ${item.product.name}: ${item.quantity}',
                child: ExcludeSemantics(child: Text('${item.quantity}')),
              ),
              IconButton(
                tooltip: 'Increase quantity of ${item.product.name}',
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: item.product.inStock
                    ? () =>
                          store.setQuantity(item.product.id, item.quantity + 1)
                    : null,
                icon: const Icon(Icons.add),
              ),
              TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: () => store.remove(item.product.id),
                child: Semantics(
                  label: 'Remove ${item.product.name} from cart',
                  child: const ExcludeSemantics(child: Text('Remove')),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
