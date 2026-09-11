import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/riptide.dart';
import '../../core/models/commerce.dart';
import '../../core/services/store.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.store, required this.productId});

  final Store store;
  final String productId;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

enum _CareTab { overview, care, compatibility, shipping }

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;
  bool _detail = false;
  _CareTab _tab = _CareTab.overview;

  @override
  void didUpdateWidget(covariant ProductPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId ||
        oldWidget.store != widget.store) {
      _quantity = 1;
      _detail = false;
      _tab = _CareTab.overview;
    }
  }

  void _add(Product product) {
    widget.store.add(product, quantity: _quantity);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Added $_quantity × ${product.name} to your cart.'),
        action: SnackBarAction(
          label: 'View cart',
          onPressed: () {
            if (mounted) context.go('/cart');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) {
      final product = widget.store.productById(widget.productId);
      return SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: RiptideTokens.contentMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => context.go('/shop'),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back to shop'),
                  ),
                  const SizedBox(height: 24),
                  if (product == null) ...[
                    Text(
                      'Product not found',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This product is not in our catalog. Explore the shop to find your next aquarium companion.',
                    ),
                  ] else ...[
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide =
                            constraints.maxWidth >= 800 &&
                            MediaQuery.textScalerOf(context).scale(14) <= 24;
                        if (!wide) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _gallery(product),
                              const SizedBox(height: 32),
                              _information(product),
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _gallery(product)),
                            const SizedBox(width: 48),
                            Expanded(child: _information(product)),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    const Divider(),
                    const SizedBox(height: 20),
                    _careInformation(product),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget _image(Product product, {required bool detail}) => ClipRect(
    child: Transform.scale(
      scale: detail ? 1.5 : 1,
      child: Image.asset(
        product.imageAsset,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        semanticLabel: '${product.name}${detail ? ', zoomed detail' : ''}',
        errorBuilder: (_, error, stack) => const ColoredBox(
          color: RiptideColors.seaMist,
          child: Center(
            child: Icon(Icons.image_not_supported_outlined, size: 40),
          ),
        ),
      ),
    ),
  );

  Widget _gallery(Product product) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(RiptideTokens.cardRadius),
        child: AspectRatio(
          aspectRatio: 1.1,
          child: _image(product, detail: _detail),
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final detail in [false, true])
            Semantics(
              button: true,
              selected: detail == _detail,
              label: detail ? 'Show zoomed detail' : 'Show full image',
              child: Tooltip(
                message: detail ? 'Zoomed detail' : 'Full image',
                child: SizedBox(
                  width: 88,
                  height: 80,
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: detail == _detail
                            ? RiptideColors.ocean
                            : RiptideColors.seaMist,
                        width: 3,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => setState(() => _detail = detail),
                      child: ExcludeSemantics(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: _image(product, detail: detail),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        _detail
            ? 'Zoomed detail · supplied product image'
            : 'Full image · supplied product image',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );

  Widget _information(Product product) {
    final favorite = widget.store.isFavorite(product.id);
    final categories = widget.store.categories.where(
      (c) => c.id == product.categoryId,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (categories.isNotEmpty)
          Text(
            categories.first.name.toUpperCase(),
            style: const TextStyle(
              color: RiptideColors.ocean,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        const SizedBox(height: 12),
        Text(product.name, style: Theme.of(context).textTheme.headlineLarge),
        if (product.scientificName.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            product.scientificName,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              product.priceLabel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('/ ${product.unitLabel}'),
            Chip(
              avatar: Icon(
                product.inStock
                    ? Icons.check_circle_outline
                    : Icons.remove_circle_outline,
                size: 18,
              ),
              label: Text(product.inStock ? 'In stock' : 'Out of stock'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        Text('Quantity', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: RiptideColors.ocean),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Decrease quantity',
                    onPressed: product.inStock && _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Semantics(
                    liveRegion: true,
                    label: 'Quantity: $_quantity',
                    child: ExcludeSemantics(child: Text('$_quantity')),
                  ),
                  IconButton(
                    tooltip: 'Increase quantity',
                    onPressed: product.inStock
                        ? () => setState(() => _quantity++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: product.inStock ? () => _add(product) : null,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: Text(product.inStock ? 'Add to cart' : 'Out of stock'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Item total: ${formatPrice(product.priceCents * _quantity)}'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () => widget.store.toggleFavorite(product.id),
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? RiptideColors.coral : null,
              ),
              label: Text(
                favorite ? 'Remove from favorites' : 'Save to favorites',
              ),
            ),
            TextButton.icon(
              onPressed: () => context.go('/cart'),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: Text('View cart (${widget.store.cartCount})'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          RiptideConfig.checkoutNotice,
          style: TextStyle(color: RiptideColors.ocean),
        ),
      ],
    );
  }

  Widget _careInformation(Product product) {
    final care = product.care;
    final String heading;
    final String body;
    switch (_tab) {
      case _CareTab.overview:
        heading = 'Meet your next aquarium companion';
        body = product.description;
      case _CareTab.care:
        heading = 'A healthy habitat comes first';
        body = care == null
            ? '${product.description}\n\nDetailed care specifications are not supplied for this product. Confirm its requirements before adding it to your aquarium.'
            : '${care.waterType} · ${care.difficulty}\n'
                  'Minimum tank: ${care.minimumTankLiters} L\n'
                  'Temperature: ${care.temperatureLabel}\n\n${care.notes}';
      case _CareTab.compatibility:
        heading = 'Choose tank mates thoughtfully';
        body = care == null
            ? 'Compatibility details are not supplied for this product. Check the needs of your existing livestock and plants before introducing anything new.'
            : 'Temperament: ${care.temperament}\n\n${care.notes}\n\n'
                  'Match water requirements and adult size, and assess your existing tank mates before introducing new livestock.';
      case _CareTab.shipping:
        heading = 'Shipping & collection';
        body =
            '${RiptideConfig.checkoutNotice}\n\nShipping rates, delivery dates, and live-arrival terms are not available in this demo.';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final tab in _CareTab.values)
              ChoiceChip(
                label: Text(switch (tab) {
                  _CareTab.overview => 'Overview',
                  _CareTab.care => 'Care',
                  _CareTab.compatibility => 'Compatibility',
                  _CareTab.shipping => 'Shipping',
                }),
                selected: _tab == tab,
                onSelected: (_) => setState(() => _tab = tab),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: RiptideColors.seaMist,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(body, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
