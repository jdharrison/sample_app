import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../core/config/riptide.dart';
import '../core/services/store.dart';
import '../core/widgets/parchment.dart';
import '../core/widgets/riptide_brand.dart';
import '../features/home/riptide_home.dart';
import '../features/catalog/catalog_page.dart';
import '../features/product/product_page.dart';
import '../features/cart/cart_page.dart';
import '../features/checkout/riptide_checkout.dart';
import 'riptide_theme.dart';

class SampleApp extends StatefulWidget {
  const SampleApp({super.key});
  @override
  State<SampleApp> createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp> {
  final store = Store();
  late final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            _Shell(store: store, path: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (_, state) => RiptideHome(store: store),
          ),
          GoRoute(
            path: '/shop',
            builder: (_, state) => CatalogPage(
              key: ValueKey(state.uri.toString()),
              store: store,
              category: state.uri.queryParameters['category'],
            ),
          ),
          GoRoute(
            path: '/shop/:id',
            builder: (_, state) => ProductPage(
              store: store,
              productId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/cart',
            builder: (_, state) => CartPage(store: store),
          ),
          GoRoute(
            path: '/checkout',
            builder: (_, state) => RiptideCheckout(store: store),
          ),
          GoRoute(
            path: '/favorites',
            builder: (_, state) => CatalogPage(store: store, favorites: true),
          ),
          for (final section in [
            'about',
            'resources',
            'contact',
            'privacy',
            'terms',
            'shipping',
            'faq',
            'account',
          ])
            GoRoute(
              path: '/$section',
              builder: (_, state) => RiptideInfoPage(section: section),
            ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () => context.go('/'),
          child: const Text('Page not found · Back home'),
        ),
      ),
    ),
  );
  @override
  void dispose() {
    router.dispose();
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: '${RiptideConfig.name} · Exotic Fish',
    debugShowCheckedModeBanner: false,
    theme: buildRiptideTheme(),
    routerConfig: router,
  );
}

class _Shell extends StatelessWidget {
  const _Shell({required this.store, required this.path, required this.child});
  final Store store;
  final String path;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    // Enlarged navigation labels need the compact menu before they crowd out
    // the logo and action buttons. Never reduce the normal-width breakpoint.
    final navigationScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final compact = width < 1000 * (navigationScale < 1 ? 1 : navigationScale);
    final mobile = width < 600;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: ParchmentSurface.brass, width: 1),
        ),
        flexibleSpace: const ParchmentSurface(
          frame: false,
          child: SizedBox.expand(),
        ),
        toolbarHeight:
            78 + (navigationScale > 1 ? (navigationScale - 1) * 28 : 0),
        titleSpacing: 16,
        title: Semantics(
          label: 'Riptide home',
          button: true,
          child: InkWell(
            onTap: () => context.go('/'),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: const RiptideBrand(),
            ),
          ),
        ),
        actions: [
          if (!compact) ...[
            for (final link in const [
              ('Shop', '/shop'),
              ('About', '/about'),
              ('Contact', '/contact'),
            ])
              TextButton(
                onPressed: () => context.go(link.$2),
                child: Text(
                  link.$1,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    decoration: path == link.$2
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: ParchmentSurface.brass,
                  ),
                ),
              ),
          ],
          IconButton(
            tooltip: 'Search products',
            onPressed: () => context.go('/shop'),
            icon: const Icon(Icons.search),
          ),
          ListenableBuilder(
            listenable: store,
            builder: (_, _) => IconButton(
              tooltip: 'Cart, ${store.cartCount} items',
              onPressed: () => context.go('/cart'),
              icon: Badge(
                isLabelVisible: store.cartCount > 0,
                label: Text('${store.cartCount}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),

          if (compact)
            PopupMenuButton<String>(
              tooltip: 'Open navigation',
              icon: const Icon(Icons.menu),
              onSelected: (route) => context.go(route),
              itemBuilder: (_) => [
                for (final item in const [
                  ('Shop', '/shop'),
                  ('About', '/about'),
                  ('Contact', '/contact'),
                ])
                  PopupMenuItem(value: item.$2, child: Text(item.$1)),
              ],
            ),
        ],
      ),
      body: ParchmentSurface(child: child),
      bottomNavigationBar: mobile
          ? ParchmentSurface(
              frame: false,
              child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: ParchmentSurface.brass),
                  ),
                ),
                child: NavigationBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  surfaceTintColor: Colors.transparent,
                  indicatorColor: ParchmentSurface.brass.withValues(alpha: .16),
                  selectedIndex: path == '/'
                      ? 0
                      : path == '/favorites'
                      ? 3
                      : path == '/account'
                      ? 4
                      : 1,
                  onDestinationSelected: (i) => context.go(
                    ['/', '/shop', '/shop', '/favorites', '/account'][i],
                  ),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.storefront_outlined),
                      label: 'Shop',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.search),
                      label: 'Search',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_border),
                      label: 'Favorites',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      label: 'Account',
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
