import 'package:flutter/material.dart';

enum PriceType { fixed, startingAt, quote }

class Service {
  const Service({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.price,
    required this.priceType,
    required this.features,
    required this.icon,
    required this.category,
    this.featured = false,
  });

  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final int? price;
  final PriceType priceType;
  final List<String> features;
  final IconData icon;
  final String category;
  final bool featured;

  String get priceLabel {
    if (priceType == PriceType.quote) return 'Request a quote';
    final amount = '\$${price ?? 0}';
    return priceType == PriceType.startingAt ? 'From $amount' : amount;
  }
}
