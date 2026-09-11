# Sample App · RipTide Aquatics

A reusable Flutter SMB application foundation demonstrated through **Riptide**, a fictional premium aquatic retailer. This is a working frontend demonstration, not a live business: orders, newsletter signups, stock, statistics, and contact details are illustrative. No payments, emails, reservations, or shipments occur.

## Run

```sh
flutter pub get
flutter run -d chrome
```

Brave on this Linux machine:

```sh
CHROME_EXECUTABLE=/usr/bin/brave-browser flutter run -d chrome
```

The existing project includes web, Android, iOS, macOS, Windows, and Linux runners. Native builds require the corresponding host/toolchain; web is the validated primary target.

## Validate

```sh
dart format lib test
flutter analyze
flutter test
flutter build web --release
```

`dart format` is the Dart/Flutter formatter (there is no `flutter format` command). Tests cover catalog filters, care/detail interactions, integer-cent prices, cart quantities/totals, invalid input, checkout success/failure/retry, duplicate submission prevention, and responsive navigation/layout. Home and shop are traversed at 320, 430, 768, 1024, 1440, and 1920 logical pixels at text scales 1.0 and 1.5.

## Experience

- `/`: image-led homepage, collections, mission, demo statistics, local newsletter, footer.
- `/shop`: search, sorting, category/price/availability filters; mobile filter sheet.
- `/shop/:id`: product imagery, care sections, favorites, quantities, add to cart.
- `/favorites`: local favorite products.
- `/cart`: live quantities, removal and subtotal.
- `/checkout`: customer details → delivery/pickup → mock payment → review → confirmation and order snapshot.
- `/about`, `/resources`, `/contact`, `/shipping`, `/faq`, `/privacy`, `/terms`: supporting content.
- `/account`: account expansion preview.

Browser history uses `go_router` with Flutter's default hash URLs (for example `/#/shop`). This works on static hosts without rewrite rules. A future switch to path URLs requires hosting rewrites and a matching URL strategy. Cart/favorites live only for the application session. Reloading resets them. Confirmation is an in-memory snapshot, not durable order history.

## Architecture

- `lib/app/app.dart`: app-owned Store, router, responsive shell, mobile bottom navigation.
- `lib/app/riptide_theme.dart`: Material 3 overrides for Riptide.
- `lib/core/config/riptide.dart`: brand, contact/hours, social/navigation content, statistics, palette, spacing/breakpoints, and asset paths.
- `lib/core/models/commerce.dart`: provider-independent Product, optional FishCare, Category, CartItem, Customer, Order; prices are integer USD cents.
- `lib/core/services/store.dart`: immutable catalog snapshots, observable local cart/favorites, and injectable `OrderService`/`MockOrderService`.
- `lib/features/home`: storefront, informational pages, configurable editorial copy.
- `lib/features/catalog`, `product`, `cart`, `checkout`: independent feature bodies sharing models and state.

The previous home-services sample remains in the repository, un-routed, to preserve existing work. Its `Service` and payment/booking interfaces are separate from the active product storefront. The active checkout depends on `OrderService`; no payment SDK objects reach widgets or models. A real integration should compose payment authorization, inventory, taxes, and shipping behind that boundary, rather than reuse the service-specific legacy payment interface directly.

Dependencies added: `go_router` for browser-aware routing and `flutter_svg` for supplied vector logos/icons. No external state-management package, code generation, or backend is necessary.

## Antique nautical design

The current skin uses the supplied antique-nautical palette: warm parchment, sepia ink, oxidized teal, bronze, and antique gold. Serif editorial headings, enamel-style buttons, and fine engraved borders replace the original bright-blue treatment.

`lib/core/widgets/parchment.dart` draws a deterministic, cached paper-grain tile with faint chart arcs and corner rules. The decorative overlay ignores input and semantics and has no animation. `lib/core/widgets/riptide_brand.dart` draws an original compass–trident mark; the reference emblem/artwork is not copied. Existing individual fish photographs remain prototype imagery pending original painted or licensed replacements. Display fonts use local serif fallbacks rather than downloading fonts at runtime.

## Rebranding

1. Set brand/theme/contact values in `lib/core/config/riptide.dart`.
2. Edit collections and products in `lib/core/services/store.dart` or replace the local source with an API implementation.
3. Change page copy, informational pages, and footer links in `lib/features/home/home_content.dart`.
4. Replace images using `RiptideAssets` paths. Assets are registered in `pubspec.yaml` from `assets/riptide_flutter_assets/assets/riptide/`.
5. Adjust theme styles in `lib/app/riptide_theme.dart` and route destinations in `lib/app/app.dart`.

The supplied raster crops are **prototype assets**, not final licensed commercial photography. Replace them with appropriately licensed, high-resolution originals before a public deployment. The app renders individual assets inside actual Flutter widgets; it does not embed the full reference board.

## Responsive strategy

Constraint-based layouts, natural-height product cards, a bounded content width, a mobile filter sheet, and a text-scale-aware header breakpoint let the same feature bodies work across desktop and phone. The mobile shell supplies Home, Shop, Search, Favorites, and Account destinations. Search opens the catalog's search field; Favorites is functional, while Account is a preview.

## Future integrations

- Square, Stripe, or another payment provider behind application services; never collect raw cards in Flutter application state.
- Backend inventory, durable orders, authoritative prices/taxes and shipping calculations.
- Authentication, customer accounts and order history.
- Real delivery availability and livestock policies.
- Newsletter consent, notifications, and operator-specific legal notices.
- Native mobile/desktop packaging and platform QA.

Production launch also needs licensed images, verified care/stock information, real shipping and refund policies, privacy/security review, and backend validation. No claim in this demo constitutes an actual livestock guarantee.
