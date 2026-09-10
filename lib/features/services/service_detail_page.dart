import 'package:flutter/material.dart';

import '../../core/models/service.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/site_chrome.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({super.key, required this.service});
  final Service service;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: ListView(
      children: [
        PageFrame(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: LayoutBuilder(
              builder: (context, c) {
                final stacked = c.maxWidth < 760;
                final visual = Container(
                  height: 360,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDEEE6),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: Icon(
                      service.icon,
                      size: 130,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.category.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      service.name,
                      style: Theme.of(context).textTheme.displaySmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      service.description,
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      service.priceLabel,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 22),
                    ...service.features.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 19,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(f)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/checkout?service=${service.id}',
                      ),
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        service.priceType == PriceType.quote
                            ? 'Request your quote'
                            : 'Continue to booking',
                      ),
                    ),
                  ],
                );
                return stacked
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [visual, const SizedBox(height: 35), copy],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: visual),
                          const SizedBox(width: 70),
                          Expanded(child: copy),
                        ],
                      );
              },
            ),
          ),
        ),
        const SiteFooter(),
      ],
    ),
  );
}
