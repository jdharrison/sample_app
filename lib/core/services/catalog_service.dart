import 'package:flutter/material.dart';

import '../models/service.dart';

abstract interface class CatalogService {
  List<Service> get allServices;
  Service? byId(String id);
}

class MockCatalogService implements CatalogService {
  const MockCatalogService();

  static const _services = <Service>[
    Service(
      id: 'refresh',
      name: 'Home Refresh',
      shortDescription: 'A meticulous reset for your everyday spaces.',
      description: 'Our signature maintenance visit brings your home back to its best—bright, clean, and ready for the week ahead.',
      price: 99,
      priceType: PriceType.fixed,
      category: 'Home care',
      icon: Icons.auto_awesome_outlined,
      features: [
        'Up to 2 hours of expert care',
        'Kitchen and bath refresh',
        'Floors, surfaces and finishing touches',
      ],
    ),
    Service(
      id: 'deep-care',
      name: 'Deep Care',
      shortDescription: 'A detailed top-to-bottom seasonal renewal.',
      description: 'For the spaces that deserve extra attention. We work through the details that transform how your home feels.',
      price: 199,
      priceType: PriceType.fixed,
      category: 'Home care',
      icon: Icons.cleaning_services_outlined,
      featured: true,
      features: [
        'Up to 5 hours of expert care',
        'Detailed kitchen and bath',
        'Interior glass and baseboards',
        'Personalized checklist',
      ],
    ),
    Service(
      id: 'whole-home',
      name: 'Whole Home',
      shortDescription: 'The complete care plan for a beautifully kept home.',
      description: 'Our most comprehensive visit pairs a deep clean with thoughtful care across every room in your home.',
      price: 349,
      priceType: PriceType.startingAt,
      category: 'Home care',
      icon: Icons.home_work_outlined,
      features: [
        'Full-home deep care',
        'Inside cabinets on request',
        'Detailed finishing pass',
        'Priority scheduling',
      ],
    ),
    Service(
      id: 'custom',
      name: 'Custom Project',
      shortDescription: 'A tailored plan for your one-of-a-kind project.',
      description: 'Moving, preparing for guests, or taking on a special project? Tell us what you need and we will build the right plan.',
      price: null,
      priceType: PriceType.quote,
      category: 'Special projects',
      icon: Icons.design_services_outlined,
      features: [
        'Personal walkthrough',
        'Tailored scope of work',
        'Transparent written quote',
        'Dedicated project lead',
      ],
    ),
  ];

  @override
  List<Service> get allServices => _services;

  @override
  Service? byId(String id) =>
      _services.where((service) => service.id == id).firstOrNull;
}
