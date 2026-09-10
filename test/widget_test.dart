import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sample_app/features/checkout/checkout_page.dart';
import 'package:sample_app/core/config/business_config.dart';
import 'package:sample_app/core/models/service.dart';
import 'package:sample_app/core/services/catalog_service.dart';

void main() {
  test('business configuration supplies usable contact identity', () {
    expect(businessConfig.name, isNotEmpty);
    expect(businessConfig.email, contains('@'));
    expect(businessConfig.phone, isNotEmpty);
  });

  test('catalog contains multiple service price strategies', () {
    const catalog = MockCatalogService();
    expect(catalog.allServices, hasLength(4));
    expect(
      catalog.allServices.map((service) => service.priceType),
      containsAll(<PriceType>[
        PriceType.fixed,
        PriceType.startingAt,
        PriceType.quote,
      ]),
    );
    expect(catalog.byId('deep-care')?.priceLabel, r'$199');
    expect(catalog.byId('custom')?.priceLabel, 'Request a quote');
  });

  testWidgets('checkout presents labeled customer detail fields', (
    tester,
  ) async {
    const catalog = MockCatalogService();
    await tester.pumpWidget(
      MaterialApp(home: CheckoutPage(service: catalog.allServices.first)),
    );
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Service address'), findsOneWidget);
  });
}
