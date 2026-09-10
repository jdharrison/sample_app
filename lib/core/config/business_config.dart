import 'package:flutter/material.dart';

class BusinessConfig {
  const BusinessConfig({
    required this.name,
    required this.tagline,
    required this.description,
    required this.phone,
    required this.email,
    required this.address,
    required this.hours,
    required this.primaryColor,
  });

  final String name;
  final String tagline;
  final String description;
  final String phone;
  final String email;
  final String address;
  final String hours;
  final Color primaryColor;
}

const businessConfig = BusinessConfig(
  name: 'Hearth & Home',
  tagline: 'Care for the place you love.',
  description: 'Thoughtful home services, delivered by local experts who treat every space with care.',
  phone: '(555) 014-2048',
  email: 'hello@hearthandhome.demo',
  address: '214 Juniper Street, Portland, OR',
  hours: 'Mon–Fri 8am–6pm · Sat 9am–3pm',
  primaryColor: Color(0xFF176B5B),
);
