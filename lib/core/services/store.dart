import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../config/riptide.dart';
import '../models/commerce.dart';

class Store extends ChangeNotifier {
  Store({
    Iterable<Product> products = mockProducts,
    Iterable<Category> categories = mockCategories,
  }) : products = List.unmodifiable(products),
       categories = List.unmodifiable(categories) {
    final categoryIds = this.categories.map((category) => category.id).toSet();
    if (categoryIds.length != this.categories.length) {
      throw ArgumentError('Category IDs must be unique');
    }
    for (final product in this.products) {
      if (_productsById.containsKey(product.id) ||
          !categoryIds.contains(product.categoryId) ||
          product.priceCents < 0) {
        throw ArgumentError('Invalid catalog product: ${product.id}');
      }
      _productsById[product.id] = product;
    }
  }

  final List<Product> products;
  final List<Category> categories;
  final Map<String, Product> _productsById = {};
  final Map<String, CartItem> _cart = {};
  final Set<String> _favoriteIds = {};

  List<CartItem> get cart => List.unmodifiable(_cart.values);
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  List<Product> get favorites => List.unmodifiable(
    products.where((product) => _favoriteIds.contains(product.id)),
  );
  List<Product> get featuredProducts =>
      List.unmodifiable(products.where((product) => product.featured));
  int get cartCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);
  int get subtotalCents =>
      _cart.values.fold(0, (sum, item) => sum + item.totalCents);
  String get subtotalLabel => formatPrice(subtotalCents);

  Product? productById(String id) => _productsById[id];
  List<Product> productsForCategory(String categoryId) => List.unmodifiable(
    products.where((product) => product.categoryId == categoryId),
  );
  bool isFavorite(String productId) => _favoriteIds.contains(productId);
  int quantityFor(String productId) => _cart[productId]?.quantity ?? 0;

  Product _requireProduct(String id) =>
      productById(id) ??
      (throw ArgumentError.value(id, 'productId', 'Unknown product'));

  /// Uses the catalog price, never a price supplied by a caller.
  void add(Product product, {int quantity = 1}) {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Must be positive');
    }
    final catalogProduct = _requireProduct(product.id);
    if (!catalogProduct.inStock) throw StateError('Product is out of stock');
    _cart[product.id] = CartItem(
      product: catalogProduct,
      quantity: quantityFor(product.id) + quantity,
    );
    notifyListeners();
  }

  /// Removes the entire cart line. Use setQuantity to decrement it.
  void remove(String productId) {
    if (_cart.remove(productId) != null) notifyListeners();
  }

  /// Zero removes the line; a positive value also adds an absent product.
  void setQuantity(String productId, int quantity) {
    if (quantity < 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Must not be negative');
    }
    final product = _requireProduct(productId);
    if (quantity == 0) {
      remove(productId);
      return;
    }
    if (!product.inStock) throw StateError('Product is out of stock');
    if (quantityFor(productId) == quantity) return;
    _cart[productId] = CartItem(product: product, quantity: quantity);
    notifyListeners();
  }

  void clearCart() {
    if (_cart.isEmpty) return;
    _cart.clear();
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    _requireProduct(productId);
    if (!_favoriteIds.remove(productId)) _favoriteIds.add(productId);
    notifyListeners();
  }
}

/// Independent of Store and any state-management or payment provider.
abstract interface class OrderService {
  Future<Order> placeOrder({
    required Customer customer,
    required List<CartItem> items,
  });
}

/// In-memory demo only: does not charge, ship, or persist customer information.
class MockOrderService implements OrderService {
  static int _sequence = 0;

  @override
  Future<Order> placeOrder({
    required Customer customer,
    required List<CartItem> items,
  }) async {
    if (customer.name.trim().isEmpty ||
        customer.email.trim().isEmpty ||
        customer.phone.trim().isEmpty ||
        customer.address.trim().isEmpty) {
      throw ArgumentError(
        'Customer name, email, phone, and address are required',
      );
    }
    if (items.any((item) => !item.product.inStock)) {
      throw StateError('An order contains an out-of-stock product');
    }
    final now = DateTime.now().toUtc();
    return Order(
      id: 'RIP-DEMO-${now.microsecondsSinceEpoch}-${++_sequence}',
      customer: customer,
      items: items,
      createdAt: now,
    );
  }
}

const List<Category> mockCategories = [
  Category(
    id: 'freshwater',
    name: 'Freshwater',
    description: 'Colorful fish and invertebrates for freshwater habitats.',
    imageAsset: RiptideAssets.freshwater,
  ),
  Category(
    id: 'saltwater',
    name: 'Saltwater',
    description:
        'Remarkable marine fish for carefully maintained reef systems.',
    imageAsset: RiptideAssets.saltwater,
  ),
  Category(
    id: 'plants',
    name: 'Aquatic Plants',
    description: 'Living greenery for a flourishing planted aquarium.',
    imageAsset: RiptideAssets.plants,
  ),
  Category(
    id: 'aquarium',
    name: 'Aquarium Essentials',
    description: 'Habitat essentials. Demo collection coming soon.',
    imageAsset: RiptideAssets.aquarium,
  ),
];

// Illustrative USD prices, not a live inventory or supplier quotation.
const List<Product> mockProducts = [
  Product(
    id: 'blue-discus',
    name: 'Blue Turquoise Discus',
    scientificName: 'Symphysodon aequifasciatus',
    categoryId: 'freshwater',
    description:
        'A striking blue discus with intricate turquoise patterning. '
        'Best for experienced keepers with a mature, warm aquarium.',
    priceCents: 8999,
    imageAsset: RiptideAssets.productDiscus,
    featured: true,
    care: FishCare(
      difficulty: 'Advanced',
      waterType: 'Freshwater',
      minimumTankLiters: 250,
      temperatureLabel: '28–30 °C',
      temperament: 'Peaceful',
      notes: 'Keep in a compatible group with excellent water quality and stable parameters.',
    ),
  ),
  Product(
    id: 'ocellaris-clownfish',
    name: 'Ocellaris Clownfish',
    scientificName: 'Amphiprion ocellaris',
    categoryId: 'saltwater',
    description:
        'The classic orange-and-white reef companion. '
        'An anemone is not required for a healthy aquarium home.',
    priceCents: 2999,
    imageAsset: RiptideAssets.productClownfish,
    featured: true,
    care: FishCare(
      difficulty: 'Intermediate',
      waterType: 'Saltwater',
      minimumTankLiters: 75,
      temperatureLabel: '24–27 °C',
      temperament: 'Territorial around its home',
      notes: 'Use a fully cycled marine tank; maintain stable salinity and suitable tank mates.',
    ),
  ),
  Product(
    id: 'neon-tetra',
    name: 'Neon Tetra',
    scientificName: 'Paracheirodon innesi',
    categoryId: 'freshwater',
    description:
        'Electric blue and red schooling fish that shine against a planted backdrop. '
        'Sold individually; plan for a school of at least six.',
    priceCents: 349,
    imageAsset: RiptideAssets.productTetra,
    featured: true,
    care: FishCare(
      difficulty: 'Beginner',
      waterType: 'Freshwater',
      minimumTankLiters: 60,
      temperatureLabel: '22–26 °C',
      temperament: 'Peaceful schooling fish',
      notes: 'Keep six or more in a mature tank with gentle companions and planted cover.',
    ),
  ),
  Product(
    id: 'royal-gramma',
    name: 'Royal Gramma',
    scientificName: 'Gramma loreto',
    categoryId: 'saltwater',
    description:
        'A brilliant purple-and-yellow basslet that prefers rocky caves '
        'and sheltered reef crevices.',
    priceCents: 3499,
    imageAsset: RiptideAssets.productGramma,
    featured: true,
    care: FishCare(
      difficulty: 'Intermediate',
      waterType: 'Saltwater',
      minimumTankLiters: 115,
      temperatureLabel: '24–27 °C',
      temperament: 'Peaceful but cave-territorial',
      notes:
          'Provide rockwork and hiding places. Usually keep one per aquarium.',
    ),
  ),
  Product(
    id: 'cherry-shrimp',
    name: 'Red Cherry Shrimp',
    scientificName: 'Neocaridina davidi',
    categoryId: 'freshwater',
    description:
        'Small scarlet grazers for peaceful planted tanks. '
        'Enjoy watching a colony forage among moss and driftwood.',
    priceCents: 499,
    imageAsset: RiptideAssets.productShrimp,
    care: FishCare(
      difficulty: 'Beginner',
      waterType: 'Freshwater',
      minimumTankLiters: 20,
      temperatureLabel: '20–26 °C',
      temperament: 'Peaceful',
      notes: 'Avoid copper treatments and predatory fish. Acclimate slowly to stable water.',
    ),
  ),
  Product(
    id: 'anubias-nana',
    name: 'Anubias Nana',
    scientificName: 'Anubias barteri var. nana',
    categoryId: 'plants',
    description:
        'A hardy, slow-growing plant with glossy green leaves. '
        'Attach to wood or rock and keep the rhizome above the substrate.',
    priceCents: 1299,
    imageAsset: RiptideAssets.productAnubias,
    unitLabel: 'per plant',
  ),
];
