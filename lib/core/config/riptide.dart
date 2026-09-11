import 'package:flutter/material.dart';

abstract final class RiptideConfig {
  static const name = 'RipTide Aquatics';
  static const tagline = 'A thriving underwater world starts here.';
  static const description =
      'Discover extraordinary fish, vibrant plants, and thoughtful care for your aquarium.';
  static const heroTitle = 'Extraordinary Life Beneath the Surface.';
  static const heroSubtitle =
      'Bring the wonder of the underwater world home. Discover remarkable fish, '
      'lush aquatic plants, and a deeper connection to nature.';
  static const shopTitle = 'Shop Exotics';
  static const shopSubtitle = 'Find your next aquarium companion.';
  static const missionTitle = 'Healthier Fish. Happier People.';
  static const missionDescription =
      'An aquarium is a living ecosystem, not just a beautiful view. '
      'We believe every extraordinary underwater world starts with thoughtful care: '
      'the right habitat, compatible companions, and a little curiosity.';
  static const newsletterTitle = 'Join the RipTide Aquatics Community';
  static const newsletterDescription =
      'Aquarium inspiration, care tips, and new discoveries. Dive in with us.';

  // Illustrative design values, not live business metrics or service promises.
  static const demoStatistics = [
    (value: '10000+', label: 'Happy Customers'),
    (value: '500+', label: 'Species Available'),
    (value: '24/7', label: 'Expert Support'),
    (value: '100%', label: 'Live Arrival Guarantee'),
  ];
  static const trust = [
    (
      asset: RiptideAssets.iconFish,
      title: 'Healthy Quarantined Livestock',
      detail: 'Care from the very beginning',
    ),
    (
      asset: RiptideAssets.iconUsers,
      title: 'Trusted by 10,000+ Hobbyists',
      detail: 'A shared passion for aquatic life',
    ),
    (
      asset: RiptideAssets.iconBookOpen,
      title: 'Expert Support',
      detail: 'Guidance for your aquarium journey',
    ),
    (
      asset: RiptideAssets.iconShieldCheck,
      title: 'Live Arrival Guarantee',
      detail: 'Peace of mind for every arrival',
    ),
  ];

  // Reserved example contact details; replace before a commercial launch.
  static const contact = (
    email: 'hello@riptide.example',
    phone: '+1 (202) 555-0100',
    location: 'Online aquarium boutique · Demo only',
  );
  static const hours = {
    'Monday–Friday': '9 am–6 pm',
    'Saturday': '10 am–4 pm',
    'Sunday': 'Closed',
  };
  // No real profiles have been supplied. Null URLs display as coming soon.
  static const Map<String, String?> social = {
    'Instagram': null,
    'Facebook': null,
    'YouTube': null,
  };
  static const navigation = {
    'Home': '/',
    'Shop': '/shop',
    'Our story': '/about',
    'Contact': '/contact',
    'Account': '/account',
  };
  static const footerNavigation = {
    'Explore': {
      'All collections': '/shop',
      'Freshwater': '/shop?category=freshwater',
      'Saltwater': '/shop?category=saltwater',
      'Aquatic plants': '/shop?category=plants',
      'Aquarium essentials': '/shop?category=aquarium',
    },
    'Discover': {
      'Our story': '/about',
      'Contact': '/contact',
      'Shipping & arrival': '/shipping',
      'Account': '/account',
    },
    'Good to know': {
      'Frequently asked questions': '/faq',
      'Privacy policy': '/privacy',
      'Terms of use': '/terms',
    },
  };
  static const demoNotice =
      'Demo storefront · No payments or livestock shipments. '
      'All statistics and trust claims—including customer and species counts, '
      '24/7 support, quarantine, and the 100% live-arrival guarantee—are '
      'illustrative demo values, not verified metrics or service promises. '
      'Contact details and hours are examples only; no inbox or phone is monitored.';
  static const currencyCode = 'USD';
  static const isDemo = true;
  static const checkoutNotice =
      'Demo checkout only. No payment is collected and no livestock is shipped.';
}

/// Paths reference the supplied pack in place; register its folders in pubspec.
abstract final class RiptideAssets {
  static const basePath = 'assets/riptide_flutter_assets/assets/riptide';
  static const logoMark = '$basePath/brand/logo_mark.svg';
  static const logoLight = '$basePath/brand/logo_full_light.svg';
  static const logoDark = '$basePath/brand/logo_full_dark.svg';
  static const heroDiscus = '$basePath/images/hero_discus.jpg';
  static const freshwater = '$basePath/images/collection_freshwater.jpg';
  static const saltwater = '$basePath/images/collection_saltwater.jpg';
  static const plants = '$basePath/images/collection_plants.jpg';
  static const aquarium = '$basePath/images/collection_aquarium.jpg';
  static const missionCoral = '$basePath/images/mission_coral.jpg';
  static const shopBanner = '$basePath/images/shop_banner.jpg';
  static const productDiscus = '$basePath/images/product_discus.jpg';
  static const productClownfish = '$basePath/images/product_clownfish.jpg';
  static const productTetra = '$basePath/images/product_tetra.jpg';
  static const productGramma = '$basePath/images/product_gramma.jpg';
  static const productShrimp = '$basePath/images/product_shrimp.jpg';
  static const productAnubias = '$basePath/images/product_anubias.jpg';
  static const iconBookOpen = '$basePath/icons/book_open.svg';
  static const iconFish = '$basePath/icons/fish.svg';
  static const iconHeart = '$basePath/icons/heart.svg';
  static const iconLeaf = '$basePath/icons/leaf.svg';
  static const iconPackage = '$basePath/icons/package.svg';
  static const iconSearch = '$basePath/icons/search.svg';
  static const iconShieldCheck = '$basePath/icons/shield_check.svg';
  static const iconShoppingCart = '$basePath/icons/shopping_cart.svg';
  static const iconUsers = '$basePath/icons/users.svg';
  static const iconWaves = '$basePath/icons/waves.svg';
  static const wave = '$basePath/patterns/wave.svg';
  static const bubbles = '$basePath/patterns/bubbles.svg';
}

abstract final class RiptideColors {
  static const parchment = Color(0xFFE4C994);
  static const parchmentLight = Color(0xFFF2E2B9);
  static const parchmentDark = Color(0xFFB98E55);
  static const ink = Color(0xFF20180F);
  static const oceanDeep = Color(0xFF0E3436);
  static const ocean = Color(0xFF185052);
  static const verdigris = Color(0xFF42746C);
  static const bronze = Color(0xFF8A5A2E);
  static const gold = Color(0xFFC09551);
  static const coral = Color(0xFFA85F4D);
  static const success = Color(0xFF44745A);
  static const danger = Color(0xFF8B4337);

  // Compatibility aliases keep existing screens on the antique palette.
  static const deepOcean = oceanDeep;
  static const aqua = gold;
  static const reefTeal = verdigris;
  static const seaMist = parchment;
  static const foam = parchment;
  static const white = parchmentLight;
}

abstract final class RiptideTokens {
  static const spaceXs = 4.0;
  static const spaceSm = 8.0;
  static const spaceMd = 16.0;
  static const spaceLg = 24.0;
  static const spaceXl = 32.0;
  static const sectionSpacing = 64.0;
  static const controlRadius = 14.0;
  static const cardRadius = 18.0;
  static const contentMaxWidth = 1200.0;
  static const compactBreakpoint = 600.0;
  static const wideBreakpoint = 1024.0;

  // Local fallbacks only: no font download or new asset registration required.
  static const headingFontFamily = 'Georgia';
  static const headingFontFallback = ['Times New Roman', 'Noto Serif', 'serif'];
  static const strokeWidth = 1.0;
  static const focusStrokeWidth = 2.0;
  static const shadowColor = Color(0x4020180F);
  static const cardElevation = 2.0;
  static const raisedElevation = 6.0;
  static const cardShadow = [
    BoxShadow(color: shadowColor, offset: Offset(0, 3), blurRadius: 10),
  ];
  static const raisedShadow = [
    BoxShadow(color: shadowColor, offset: Offset(0, 8), blurRadius: 24),
  ];
  static const animationFast = Duration(milliseconds: 150);
  static const animationNormal = Duration(milliseconds: 250);
  static const animationSlow = Duration(milliseconds: 400);
  static const animationCurve = Curves.easeOutCubic;
}
