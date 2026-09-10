import 'package:flutter/material.dart';

import '../config/business_config.dart';
import 'layout.dart';

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  const SiteHeader({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(76);
  void _go(BuildContext context, String route) =>
      Navigator.of(context).pushNamed(route);
  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: const Color(0xFFFFFCF7),
    surfaceTintColor: Colors.transparent,
    titleSpacing: 0,
    title: PageFrame(
      child: Row(
        children: [
          Icon(
            Icons.home_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 9),
          Text(
            businessConfig.name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
          ),
        ],
      ),
    ),
    actions: [
      LayoutBuilder(
        builder: (context, constraints) {
          final compact = MediaQuery.sizeOf(context).width < 980;
          if (compact) {
            return IconButton(
              tooltip: 'Browse services',
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => _go(context, '/services'),
            );
          }
          return PageFrame(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in const [
                  ('Home', '/'),
                  ('Services', '/services'),
                  ('About', '/#about'),
                  ('Reviews', '/#reviews'),
                  ('Contact', '/#contact'),
                ])
                  TextButton(
                    onPressed: () => _go(context, item.$2),
                    child: Text(item.$1),
                  ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => _go(context, '/services'),
                  child: const Text('Book a service'),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF16322B),
    padding: const EdgeInsets.symmetric(vertical: 52),
    child: PageFrame(
      child: DefaultTextStyle(
        style: const TextStyle(color: Color(0xFFDDE8E2)),
        child: Wrap(
          spacing: 72,
          runSpacing: 32,
          children: [
            SizedBox(
              width: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessConfig.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(businessConfig.description),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GET IN TOUCH',
                  style: TextStyle(
                    color: Color(0xFF9ED4C2),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(businessConfig.phone),
                Text(businessConfig.email),
                Text(businessConfig.address),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HOURS',
                  style: TextStyle(
                    color: Color(0xFF9ED4C2),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(businessConfig.hours),
                const SizedBox(height: 18),
                const Text('© 2026 Hearth & Home · Privacy · Terms'),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
