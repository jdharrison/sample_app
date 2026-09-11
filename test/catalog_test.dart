import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/core/models/commerce.dart';
import 'package:sample_app/core/services/store.dart';
import 'package:sample_app/features/catalog/catalog_page.dart';
import 'package:sample_app/features/product/product_page.dart';

Future<void> mount(
  WidgetTester tester,
  Store store, {
  String location = '/shop',
  bool favorites = false,
  String? category,
  double scale = 1,
}) async {
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(
        path: '/shop',
        builder: (_, _) => Scaffold(
          body: CatalogPage(
            store: store,
            favorites: favorites,
            category: category,
          ),
        ),
      ),
      GoRoute(
        path: '/shop/:id',
        builder: (_, state) => Scaffold(
          body: ProductPage(
            store: store,
            productId: state.pathParameters['id']!,
          ),
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (_, _) => const Scaffold(body: Text('Cart destination')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('category and scientific-name search combine', (tester) async {
    final store = Store();
    addTearDown(store.dispose);
    await mount(tester, store, category: 'freshwater');
    expect(find.text('3 products'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Paracheirodon');
    await tester.pumpAndSettle();
    expect(find.text('1 products'), findsOneWidget);
    expect(find.text('Neon Tetra'), findsOneWidget);
    expect(find.text('Ocellaris Clownfish'), findsNothing);
    await tester.enterText(find.byType(TextField), 'not a fish');
    await tester.pumpAndSettle();
    expect(find.text('No products match your filters.'), findsOneWidget);
  });

  testWidgets('favorites react to store changes', (tester) async {
    final store = Store()..toggleFavorite('neon-tetra');
    addTearDown(store.dispose);
    await mount(tester, store, favorites: true);
    expect(find.text('Neon Tetra'), findsOneWidget);
    store.toggleFavorite('neon-tetra');
    await tester.pumpAndSettle();
    expect(
      find.text('No favorites yet. Tap a heart to save a product.'),
      findsOneWidget,
    );
  });

  testWidgets('mobile filters work with enlarged text', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = Store();
    addTearDown(store.dispose);
    await mount(tester, store, scale: 2);
    final filters = find.widgetWithText(OutlinedButton, 'Filters');
    await tester.ensureVisible(filters);
    await tester.tap(filters);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Freshwater'));
    await tester.pumpAndSettle();
    final show = find.text('Show 3 products');
    await tester.ensureVisible(show);
    await tester.tap(show);
    await tester.pumpAndSettle();
    expect(find.text('3 products'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quantity, favorite, care and cart navigation work', (
    tester,
  ) async {
    final store = Store();
    addTearDown(store.dispose);
    await mount(tester, store, location: '/shop/neon-tetra');
    final increase = find.byTooltip('Increase quantity');
    await tester.ensureVisible(increase);
    await tester.tap(increase);
    await tester.pump();
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    expect(store.quantityFor('neon-tetra'), 2);
    expect(find.text('Added 2 × Neon Tetra to your cart.'), findsOneWidget);
    final favorite = find.text('Save to favorites');
    await tester.ensureVisible(favorite);
    await tester.tap(favorite);
    await tester.pumpAndSettle();
    expect(store.isFavorite('neon-tetra'), isTrue);
    final care = find.widgetWithText(ChoiceChip, 'Care');
    await tester.ensureVisible(care);
    await tester.tap(care);
    await tester.pumpAndSettle();
    expect(find.textContaining('Minimum tank: 60 L'), findsOneWidget);
    final cart = find.text('View cart (2)');
    await tester.ensureVisible(cart);
    await tester.tap(cart);
    await tester.pumpAndSettle();
    expect(find.text('Cart destination'), findsOneWidget);
  });

  testWidgets('unknown products and out-of-stock products are safe', (
    tester,
  ) async {
    final store = Store(
      products: [
        Product(
          id: 'unavailable',
          name: 'Unavailable fish',
          scientificName: '',
          categoryId: 'freshwater',
          description: 'Unavailable product',
          priceCents: 100,
          imageAsset: mockProducts.first.imageAsset,
          inStock: false,
        ),
      ],
    );
    addTearDown(store.dispose);
    await mount(tester, store, location: '/shop/missing');
    expect(find.text('Product not found'), findsOneWidget);
    await mount(tester, store, location: '/shop/unavailable', scale: 2);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
    expect(store.cartCount, 0);
    expect(tester.takeException(), isNull);
  });
}
