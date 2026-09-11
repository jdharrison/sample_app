import 'package:flutter_test/flutter_test.dart';
import 'package:sample_app/core/config/riptide.dart';
import 'package:sample_app/core/models/commerce.dart';
import 'package:sample_app/core/services/store.dart';

Product product({
  String id = 'test-fish',
  String category = 'freshwater',
  int price = 105,
  bool inStock = true,
}) => Product(
  id: id,
  name: 'Test fish',
  scientificName: 'Test species',
  categoryId: category,
  description: 'Test product',
  priceCents: price,
  imageAsset: RiptideAssets.productTetra,
  inStock: inStock,
);

void main() {
  group('Store cart', () {
    late Store store;
    setUp(() => store = Store());
    tearDown(() => store.dispose());

    test('starts empty with zero totals and quantities', () {
      expect(store.cart, isEmpty);
      expect(store.cartCount, 0);
      expect(store.subtotalCents, 0);
      expect(store.subtotalLabel, r'$0.00');
      expect(store.quantityFor('neon-tetra'), 0);
    });

    test('repeated additions merge quantities and total integer cents', () {
      final tetra = store.productById('neon-tetra')!;
      store.add(tetra);
      store.add(tetra, quantity: 5);
      store.add(store.productById('ocellaris-clownfish')!, quantity: 2);
      expect(store.cart, hasLength(2));
      expect(store.quantityFor(tetra.id), 6);
      expect(store.cartCount, 8);
      expect(store.cart.first.totalCents, 2094);
      expect(store.cart.first.priceLabel, r'$20.94');
      expect(store.subtotalCents, 8092);
      expect(store.subtotalLabel, r'$80.92');
    });

    test(
      'setQuantity adds absent lines, replaces quantities and removes zero',
      () {
        store.setQuantity('neon-tetra', 6);
        store.setQuantity('neon-tetra', 2);
        expect(store.quantityFor('neon-tetra'), 2);
        expect(store.cartCount, 2);
        expect(store.subtotalCents, 698);
        store.setQuantity('neon-tetra', 0);
        expect(store.cart, isEmpty);
        expect(store.quantityFor('neon-tetra'), 0);
        expect(store.subtotalCents, 0);
      },
    );

    test('remove deletes the whole line and clear resets all totals', () {
      store.setQuantity('neon-tetra', 6);
      store.setQuantity('blue-discus', 2);
      store.remove('neon-tetra');
      expect(store.cart.single.product.id, 'blue-discus');
      expect(store.quantityFor('neon-tetra'), 0);
      expect(store.cartCount, 2);
      expect(store.subtotalCents, 17998);
      store.remove('missing');
      expect(store.cartCount, 2);
      store.clearCart();
      expect(store.cart, isEmpty);
      expect(store.cartCount, 0);
      expect(store.subtotalLabel, r'$0.00');
    });

    test(
      'rejects invalid quantities and unknown products without mutation',
      () {
        store.setQuantity('neon-tetra', 2);
        final tetra = store.productById('neon-tetra')!;
        for (final quantity in [0, -1]) {
          expect(
            () => store.add(tetra, quantity: quantity),
            throwsArgumentError,
          );
        }
        expect(() => store.setQuantity(tetra.id, -1), throwsArgumentError);
        expect(() => store.add(product()), throwsArgumentError);
        expect(() => store.setQuantity('missing', 1), throwsArgumentError);
        expect(() => store.setQuantity('missing', 0), throwsArgumentError);
        expect(store.cartCount, 2);
        expect(store.subtotalCents, 698);
      },
    );

    test(
      'uses catalog identity and price rather than caller supplied values',
      () {
        final forged = product(id: 'blue-discus', price: 1);
        store.add(forged, quantity: 2);
        expect(
          store.cart.single.product,
          same(store.productById('blue-discus')),
        );
        expect(store.subtotalCents, 17998);
        expect(store.subtotalLabel, r'$179.98');
      },
    );

    test('notifies once per change and not for no-op operations', () {
      var notifications = 0;
      store.addListener(() => notifications++);
      store.clearCart();
      store.remove('missing');
      store.setQuantity('neon-tetra', 0);
      expect(notifications, 0);
      store.setQuantity('neon-tetra', 2);
      store.setQuantity('neon-tetra', 2);
      expect(notifications, 1);
      store.add(store.productById('neon-tetra')!);
      expect(notifications, 2);
      store.remove('neon-tetra');
      expect(notifications, 3);
      store.setQuantity('blue-discus', 1);
      store.clearCart();
      store.clearCart();
      expect(notifications, 5);
    });

    test('cart snapshots and catalog collections cannot be mutated', () {
      store.setQuantity('neon-tetra', 1);
      final snapshot = store.cart;
      expect(() => snapshot.clear(), throwsUnsupportedError);
      expect(() => store.products.clear(), throwsUnsupportedError);
      expect(() => store.categories.clear(), throwsUnsupportedError);
      store.setQuantity('neon-tetra', 3);
      expect(snapshot.single.quantity, 1);
      expect(store.cart.single.quantity, 3);
    });
  });

  group('Catalog configuration', () {
    test('rejects duplicate IDs and missing category references', () {
      expect(
        () => Store(products: [product(), product()]),
        throwsArgumentError,
      );
      expect(
        () => Store(categories: [mockCategories.first, mockCategories.first]),
        throwsArgumentError,
      );
      expect(
        () => Store(products: [product(category: 'missing')]),
        throwsArgumentError,
      );
    });

    test('custom catalog is copied and supports free products', () {
      final products = [product(price: 0)];
      final categories = [mockCategories.first];
      final store = Store(products: products, categories: categories);
      addTearDown(store.dispose);
      products.clear();
      categories.clear();
      expect(store.products, hasLength(1));
      expect(store.categories, hasLength(1));
      store.add(store.products.single, quantity: 3);
      expect(store.cartCount, 3);
      expect(store.subtotalLabel, r'$0.00');
      expect(store.productById('missing'), isNull);
    });

    test(
      'out-of-stock catalog products cannot be added or assigned quantities',
      () {
        final unavailable = product(inStock: false);
        final store = Store(products: [unavailable]);
        addTearDown(store.dispose);
        expect(() => store.add(unavailable), throwsStateError);
        expect(() => store.add(product()), throwsStateError);
        expect(() => store.setQuantity(unavailable.id, 1), throwsStateError);
        store.setQuantity(unavailable.id, 0);
        expect(store.cart, isEmpty);
        expect(store.subtotalCents, 0);
      },
    );

    test('demo identity and catalog are consistent with USD pricing', () {
      expect(RiptideConfig.name, 'RipTide Aquatics');
      expect(RiptideConfig.currencyCode, 'USD');
      expect(RiptideConfig.isDemo, isTrue);
      expect(RiptideConfig.checkoutNotice, contains('No payment is collected'));
      expect(RiptideConfig.checkoutNotice, contains('no livestock is shipped'));
      final store = Store();
      addTearDown(store.dispose);
      expect(store.products, isNotEmpty);
      expect(store.categories, isNotEmpty);
      for (final item in store.products) {
        expect(item.name, isNotEmpty);
        expect(item.priceCents, greaterThanOrEqualTo(0));
        expect(item.imageAsset, startsWith('${RiptideAssets.basePath}/'));
        expect(
          store.categories.map((category) => category.id),
          contains(item.categoryId),
        );
        expect(store.productsForCategory(item.categoryId), contains(item));
      }
    });
  });

  test('price formatting preserves cents, signs and two decimal places', () {
    for (final entry in <int, String>{
      0: r'$0.00',
      1: r'$0.01',
      10: r'$0.10',
      99: r'$0.99',
      100: r'$1.00',
      105: r'$1.05',
      8999: r'$89.99',
      123456789: r'$1234567.89',
      -1: r'-$0.01',
      -105: r'-$1.05',
    }.entries) {
      expect(formatPrice(entry.key), entry.value);
    }
    expect(product().priceLabel, r'$1.05');
    expect(CartItem(product: product(), quantity: 3).priceLabel, r'$3.15');
  });
}
