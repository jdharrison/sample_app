import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_app/app/app.dart';
import 'package:sample_app/core/config/riptide.dart';
import 'package:sample_app/features/catalog/catalog_page.dart';
import 'package:sample_app/features/home/riptide_home.dart';

Future<void> scrollEntirePage(WidgetTester tester, Finder page) async {
  final scrollable = find
      .descendant(of: page, matching: find.byType(Scrollable))
      .first;
  final position = tester.state<ScrollableState>(scrollable).position;
  var steps = 0;
  // Small overlapping steps exercise lazy children, not just the endpoints.
  while (position.extentAfter > 0) {
    expect(steps++, lessThan(100), reason: 'Page must reach its bottom');
    final previous = position.pixels;
    await tester.drag(scrollable, Offset(0, -position.viewportDimension * .7));
    await tester.pumpAndSettle();
    expect(
      tester.takeException(),
      isNull,
      reason: 'Overflow while scrolling at offset ${position.pixels}',
    );
    expect(position.pixels, greaterThan(previous));
  }
  expect(position.extentAfter, 0);
}

void main() {
  for (final width in [320, 430, 768, 1024, 1440, 1920]) {
    for (final scale in [1.0, 1.5]) {
      for (final route in ['home', 'shop']) {
        testWidgets('$route shell at width $width, text scale $scale', (
          tester,
        ) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width.toDouble(), 900);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

          await tester.pumpWidget(const SampleApp());
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: 'Initial home layout');
          expect(find.byType(AppBar), findsOneWidget);
          expect(find.byTooltip('Cart, 0 items'), findsOneWidget);
          expect(
            find.byType(NavigationBar),
            width < 600 ? findsOneWidget : findsNothing,
          );
          expect(
            MediaQuery.textScalerOf(tester.element(find.byType(RiptideHome)))
                .scale(16),
            16 * scale,
          );

          final compact = width < 1000 * scale;
          expect(
            find.byTooltip('Open navigation'),
            compact ? findsOneWidget : findsNothing,
          );
          if (route == 'shop') {
            if (compact) {
              await tester.tap(find.byTooltip('Open navigation'));
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);
              await tester.tap(
                find.widgetWithText(PopupMenuItem<String>, 'Shop'),
              );
            } else {
              await tester.tap(
                find.descendant(
                  of: find.byType(AppBar),
                  matching: find.widgetWithText(TextButton, 'Shop'),
                ),
              );
            }
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: 'Initial shop layout',
            );
            expect(find.byType(CatalogPage), findsOneWidget);
            expect(find.byType(RiptideHome), findsNothing);
            expect(find.text('6 products'), findsOneWidget);
            await scrollEntirePage(tester, find.byType(CatalogPage));
            // The shell stays available even at the bottom of the catalog.
            await tester.tap(find.bySemanticsLabel('Riptide home'));
            await tester.pumpAndSettle();
            expect(find.byType(RiptideHome), findsOneWidget);
          } else {
            await scrollEntirePage(tester, find.byType(RiptideHome));
            final footer = find.textContaining(
              'Demo storefront · No payments or livestock shipments.',
            );
            expect(footer, findsOneWidget);
            expect(tester.getRect(footer).bottom, lessThanOrEqualTo(900));
            expect(find.text(RiptideConfig.tagline), findsOneWidget);
          }
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        });
      }
    }
  }
}
