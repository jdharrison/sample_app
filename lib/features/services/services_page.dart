import 'package:flutter/material.dart';

import '../../core/services/catalog_service.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/site_chrome.dart';
import 'service_card.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key, required this.catalog});
  final CatalogService catalog;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70, bottom: 88),
          child: PageFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  eyebrow: 'Our services',
                  title: 'Simple care, exceptionally done.',
                  description: 'Choose the level of care that fits your home today. Every visit is backed by our local, fully insured team.',
                ),
                const SizedBox(height: 42),
                LayoutBuilder(
                  builder: (context, c) {
                    final count = c.maxWidth > 900
                        ? 3
                        : c.maxWidth > 560
                        ? 2
                        : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: count,
                        childAspectRatio: count == 1 ? 1.28 : .83,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: catalog.allServices.length,
                      itemBuilder: (_, i) =>
                          ServiceCard(service: catalog.allServices[i]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SiteFooter(),
      ],
    ),
  );
}
