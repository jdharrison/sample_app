import 'package:flutter/material.dart';

import '../core/services/catalog_service.dart';
import '../features/checkout/checkout_page.dart';
import '../features/home/home_page.dart';
import '../features/services/service_detail_page.dart';
import '../features/services/services_page.dart';
import 'theme.dart';

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  static const catalog = MockCatalogService();

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Hearth & Home',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(),
    initialRoute: '/',
    onGenerateRoute: (settings) {
      final uri = Uri.parse(settings.name ?? '/');
      if (uri.path == '/') {
        return MaterialPageRoute(builder: (_) => const HomePage());
      }
      if (uri.path == '/services') {
        return MaterialPageRoute(
          builder: (_) => ServicesPage(catalog: catalog),
        );
      }
      if (uri.path.startsWith('/services/')) {
        final service = catalog.byId(uri.pathSegments.last);
        return MaterialPageRoute(
          builder: (_) => service == null
              ? ServicesPage(catalog: catalog)
              : ServiceDetailPage(service: service),
        );
      }
      if (uri.path == '/checkout') {
        final service = catalog.byId(uri.queryParameters['service'] ?? '');
        return MaterialPageRoute(
          builder: (_) => service == null
              ? ServicesPage(catalog: catalog)
              : CheckoutPage(service: service),
        );
      }
      return MaterialPageRoute(builder: (_) => const HomePage());
    },
  );
}
