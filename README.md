# Sample App

A reusable Flutter foundation for modern service businesses. The included fictional brand, **Hearth & Home**, demonstrates a polished web-first landing page, service catalog, and mock request/checkout flow.

## Platforms

Flutter supports web now and native iOS, Android, macOS, Windows, and Linux as the product grows.

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Validate

```bash
flutter analyze
flutter test
```

## Architecture

- `lib/app`: Material 3 theme and URL-aware route setup.
- `lib/core/config/business_config.dart`: centralized identity, contact details, hours, and primary brand color.
- `lib/core/models` and `lib/core/services`: provider-independent service domain and mock catalog, booking, and payment seams.
- `lib/features`: focused home, services, and checkout UI features.

The UI depends on `CatalogService`, `BookingService`, and `PaymentService` abstractions, not a payment SDK. `MockPaymentService` and `MockBookingService` are phase-one implementations; Square, Stripe, or an API-backed service can replace them later.

## Customize a business

1. Update the `BusinessConfig` constant for branding, contact information, hours, and theme color.
2. Change catalog records in `MockCatalogService` for services, pricing, and content.
3. Replace the intentional icon-based visual treatments with client assets when available.

## Future integrations

Clear seams exist for secure Square/Stripe payment, real scheduling, customer accounts, API repositories, invoices, notifications, and internal business tools. No card details are collected by the demo.
