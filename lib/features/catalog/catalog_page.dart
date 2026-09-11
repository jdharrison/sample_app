import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/riptide.dart';
import '../../core/models/commerce.dart';
import '../../core/services/store.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({
    super.key,
    required this.store,
    this.category,
    this.favorites = false,
  });

  final Store store;
  final String? category;
  final bool favorites;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

enum _Sort { featured, priceLow, priceHigh, name }

enum _Availability { all, inStock, outOfStock }

class _CatalogPageState extends State<CatalogPage> {
  final _search = TextEditingController();
  late Set<String> _categories;
  RangeValues? _price;
  _Availability _availability = _Availability.all;
  _Sort _sort = _Sort.featured;

  double get _maximumPrice => math
      .max(
        100,
        widget.store.products.fold<int>(
          0,
          (max, p) => math.max(max, p.priceCents),
        ),
      )
      .toDouble();

  @override
  void initState() {
    super.initState();
    _categories = {if (widget.category != null) widget.category!};
  }

  @override
  void didUpdateWidget(covariant CatalogPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category ||
        oldWidget.favorites != widget.favorites ||
        oldWidget.store != widget.store) {
      _reset();
    }
  }

  void _reset() {
    _categories = {if (widget.category != null) widget.category!};
    _price = null;
    _availability = _Availability.all;
    _sort = _Sort.featured;
    _search.clear();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Product> get _results {
    final query = _search.text.trim().toLowerCase();
    final products = widget.store.products.where((p) {
      return (!widget.favorites || widget.store.isFavorite(p.id)) &&
          (_categories.isEmpty || _categories.contains(p.categoryId)) &&
          (_price == null ||
              (p.priceCents >= _price!.start && p.priceCents <= _price!.end)) &&
          (_availability == _Availability.all ||
              p.inStock == (_availability == _Availability.inStock)) &&
          (query.isEmpty ||
              '${p.name} ${p.scientificName}'.toLowerCase().contains(query));
    }).toList();
    products.sort((a, b) {
      final order = switch (_sort) {
        _Sort.featured => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0),
        _Sort.priceLow => a.priceCents.compareTo(b.priceCents),
        _Sort.priceHigh => b.priceCents.compareTo(a.priceCents),
        _Sort.name => a.name.compareTo(b.name),
      };
      return order == 0 ? a.name.compareTo(b.name) : order;
    });
    return products;
  }

  Widget _filters(void Function(VoidCallback) update) {
    final range = _price ?? RangeValues(0, _maximumPrice);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filters', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        Text('Category', style: Theme.of(context).textTheme.titleMedium),
        for (final category in widget.store.categories)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(category.name),
            value: _categories.contains(category.id),
            onChanged: (selected) => update(() {
              if (selected == true) {
                _categories.add(category.id);
              } else {
                _categories.remove(category.id);
              }
            }),
          ),
        const Divider(height: 32),
        Text('Price range', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          '${formatPrice(range.start.round())} – ${formatPrice(range.end.round())}',
        ),
        RangeSlider(
          values: range,
          max: _maximumPrice,
          labels: RangeLabels(
            formatPrice(range.start.round()),
            formatPrice(range.end.round()),
          ),
          semanticFormatterCallback: (value) => formatPrice(value.round()),
          onChanged: (value) => update(() => _price = value),
        ),
        const Divider(height: 32),
        DropdownButtonFormField<_Availability>(
          key: ValueKey(_availability),
          initialValue: _availability,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Availability'),
          items: const [
            DropdownMenuItem(
              value: _Availability.all,
              child: Text('All products'),
            ),
            DropdownMenuItem(
              value: _Availability.inStock,
              child: Text('In stock'),
            ),
            DropdownMenuItem(
              value: _Availability.outOfStock,
              child: Text('Out of stock'),
            ),
          ],
          onChanged: (value) => update(() => _availability = value!),
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: () => update(_reset),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset filters'),
        ),
      ],
    );
  }

  Future<void> _showFilters() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, sheetSetState) => FractionallySizedBox(
          heightFactor: .85,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _filters((change) {
                  setState(change);
                  sheetSetState(() {});
                }),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: Text('Show ${_results.length} products'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) {
      final products = _results;
      return SingleChildScrollView(
        child: Column(
          children: [
            Semantics(
              header: true,
              label: RiptideConfig.shopTitle,
              image: true,
              child: ExcludeSemantics(
                child: Container(
                  width: double.infinity,
                  color: RiptideColors.deepOcean,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'THE AQUATIC NATURALIST’S COLLECTION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: RiptideColors.aqua,
                            letterSpacing: 2,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Exotic Fish for\nExtraordinary Aquariums',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: RiptideColors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Healthy specimens. Happy homes.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: RiptideColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: RiptideTokens.contentMaxWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final desktop =
                          constraints.maxWidth >= 900 &&
                          MediaQuery.textScalerOf(context).scale(14) <= 22;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (desktop) ...[
                            SizedBox(width: 230, child: _filters(setState)),
                            const SizedBox(width: 32),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.favorites
                                      ? 'Your favorites'
                                      : RiptideConfig.shopTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.favorites
                                      ? 'A little inspiration for your underwater world.'
                                      : RiptideConfig.shopSubtitle,
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: _search,
                                  onChanged: (_) => setState(() {}),
                                  decoration: InputDecoration(
                                    labelText: 'Search products',
                                    hintText: 'Name or scientific name',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: _search.text.isEmpty
                                        ? null
                                        : IconButton(
                                            tooltip: 'Clear search',
                                            onPressed: () =>
                                                setState(_search.clear),
                                            icon: const Icon(Icons.close),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      '${products.length} products',
                                      semanticsLabel:
                                          '${products.length} products found',
                                    ),
                                    if (!desktop)
                                      OutlinedButton.icon(
                                        onPressed: _showFilters,
                                        icon: const Icon(Icons.tune),
                                        label: const Text('Filters'),
                                      ),
                                    SizedBox(
                                      width: math.min(
                                        260,
                                        constraints.maxWidth,
                                      ),
                                      child: DropdownButtonFormField<_Sort>(
                                        key: ValueKey(_sort),
                                        initialValue: _sort,
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Sort by',
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            value: _Sort.featured,
                                            child: Text('Featured'),
                                          ),
                                          DropdownMenuItem(
                                            value: _Sort.priceLow,
                                            child: Text('Price: low to high'),
                                          ),
                                          DropdownMenuItem(
                                            value: _Sort.priceHigh,
                                            child: Text('Price: high to low'),
                                          ),
                                          DropdownMenuItem(
                                            value: _Sort.name,
                                            child: Text('Name: A–Z'),
                                          ),
                                        ],
                                        onChanged: (value) =>
                                            setState(() => _sort = value!),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                if (products.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 40,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.search_off, size: 40),
                                        const SizedBox(height: 12),
                                        Text(
                                          widget.favorites &&
                                                  widget.store.favorites.isEmpty
                                              ? 'No favorites yet. Tap a heart to save a product.'
                                              : 'No products match your filters.',
                                        ),
                                        TextButton(
                                          onPressed: () => setState(_reset),
                                          child: const Text('Reset filters'),
                                        ),
                                        if (widget.favorites)
                                          TextButton(
                                            onPressed: () =>
                                                context.go('/shop'),
                                            child: const Text(
                                              'Explore the shop',
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                else
                                  LayoutBuilder(
                                    builder: (context, grid) {
                                      final minWidth = MediaQuery.textScalerOf(
                                        context,
                                      ).scale(190).clamp(210.0, 400.0);
                                      final columns =
                                          ((grid.maxWidth + 20) /
                                                  (minWidth + 20))
                                              .floor()
                                              .clamp(1, 4);
                                      final width =
                                          (grid.maxWidth - (columns - 1) * 20) /
                                          columns;
                                      return Wrap(
                                        spacing: 20,
                                        runSpacing: 24,
                                        children: [
                                          for (final product in products)
                                            SizedBox(
                                              width: width,
                                              child: _productCard(product),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  Widget _productCard(Product product) => Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () => context.go('/shop/${product.id}'),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Image.asset(
                  product.imageAsset,
                  fit: BoxFit.cover,
                  semanticLabel: product.name,
                  errorBuilder: (_, error, stack) => const ColoredBox(
                    color: RiptideColors.seaMist,
                    child: Center(
                      child: Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: RiptideColors.white,
                  foregroundColor: RiptideColors.deepOcean,
                ),
                tooltip: widget.store.isFavorite(product.id)
                    ? 'Remove ${product.name} from favorites'
                    : 'Favorite ${product.name}',
                isSelected: widget.store.isFavorite(product.id),
                onPressed: () => widget.store.toggleFavorite(product.id),
                icon: const Icon(Icons.favorite_border),
                selectedIcon: const Icon(
                  Icons.favorite,
                  color: RiptideColors.coral,
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => context.go('/shop/${product.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (product.scientificName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    product.scientificName,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  '${product.priceLabel} / ${product.unitLabel}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: RiptideColors.ocean,
                  ),
                ),
                const SizedBox(height: 8),
                Text(product.inStock ? 'In stock' : 'Out of stock'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
