/// Formats integer USD cents without floating-point rounding.
String formatPrice(int cents) {
  final amount = cents.abs();
  return '${cents < 0 ? '-' : ''}\$${amount ~/ 100}.${(amount % 100).toString().padLeft(2, '0')}';
}

class FishCare {
  const FishCare({
    required this.difficulty,
    required this.waterType,
    required this.minimumTankLiters,
    required this.temperatureLabel,
    required this.temperament,
    required this.notes,
  });

  final String difficulty;
  final String waterType;
  final int minimumTankLiters;
  final String temperatureLabel;
  final String temperament;
  final String notes;
}

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
  });

  final String id;
  final String name;
  final String description;
  final String imageAsset;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.categoryId,
    required this.description,
    required this.priceCents,
    required this.imageAsset,
    this.unitLabel = 'each',
    this.featured = false,
    this.inStock = true,
    this.care,
  }) : assert(priceCents >= 0);

  final String id;
  final String name;
  final String scientificName;
  final String categoryId;
  final String description;
  final int priceCents;
  final String imageAsset;
  final String unitLabel;
  final bool featured;
  final bool inStock;
  final FishCare? care;

  String get priceLabel => formatPrice(priceCents);
}

class CartItem {
  CartItem({required this.product, this.quantity = 1}) {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Must be positive');
    }
    if (product.priceCents < 0) {
      throw ArgumentError.value(product.priceCents, 'priceCents');
    }
  }

  final Product product;
  final int quantity;

  int get totalCents => product.priceCents * quantity;
  String get priceLabel => formatPrice(totalCents);

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}

class Customer {
  const Customer({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.notes = '',
  });

  final String name;
  final String email;
  final String phone;
  final String address;
  final String notes;
}

/// An immutable order snapshot. Subtotal excludes shipping and tax.
class Order {
  Order({
    required this.id,
    required this.customer,
    required Iterable<CartItem> items,
    required this.createdAt,
  }) : items = List.unmodifiable(items) {
    if (this.items.isEmpty) {
      throw ArgumentError.value(items, 'items', 'Must not be empty');
    }
  }

  final String id;
  final Customer customer;
  final List<CartItem> items;
  final DateTime createdAt;

  int get subtotalCents => items.fold(0, (sum, item) => sum + item.totalCents);
  String get priceLabel => formatPrice(subtotalCents);
}
