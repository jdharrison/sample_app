import 'package:flutter/material.dart';

import '../../core/models/service.dart';

class ServiceCard extends StatefulWidget {
  const ServiceCard({super.key, required this.service});
  final Service service;

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: hovered ? 1.015 : 1,
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () =>
                Navigator.pushNamed(context, '/services/${service.id}'),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (service.featured)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F1E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'MOST POPULAR',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Icon(
                    service.icon,
                    size: 38,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    service.name,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.shortDescription,
                    style: const TextStyle(
                      height: 1.45,
                      color: Color(0xFF586560),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    service.priceLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Explore service →',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
