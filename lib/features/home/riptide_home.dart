import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/riptide.dart';
import '../../core/models/commerce.dart';
import '../../core/services/store.dart';
import 'home_content.dart';

/// Scrollable body only; the app shell owns the Scaffold and navigation header.
class RiptideHome extends StatelessWidget {
  const RiptideHome({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      const _OceanHero(),
      const _TrustStrip(),
      _Section(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Eyebrow('EXPLORE OUR COLLECTIONS'),
            const SizedBox(height: 12),
            const _Heading(HomeContent.collectionTitle),
            const SizedBox(height: 12),
            const Text(HomeContent.collectionDescription),
            const SizedBox(height: 28),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1000
                    ? 4
                    : constraints.maxWidth >= 540
                    ? 2
                    : 1;
                final width =
                    (constraints.maxWidth - (columns - 1) * 20) / columns;
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    for (final category in store.categories)
                      SizedBox(width: width, child: _CollectionCard(category)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      const _Mission(),
      const _Newsletter(),
      const _Footer(),
    ],
  );
}

class _OceanHero extends StatelessWidget {
  const _OceanHero();

  @override
  Widget build(BuildContext context) => _EngravedPanel(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 850;
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Eyebrow(HomeContent.eyebrow, light: true),
            const SizedBox(height: 20),
            Semantics(
              header: true,
              child: Text(
                RiptideConfig.heroTitle,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: RiptideColors.white,
                  fontSize: wide ? 58 : 40,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                  letterSpacing: -1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              RiptideConfig.heroSubtitle,
              style: TextStyle(
                color: RiptideColors.seaMist,
                fontSize: 17,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: () => context.go('/shop'),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  style: _brassButton,
                  label: const Text(HomeContent.shopAction),
                ),
                OutlinedButton(
                  onPressed: () => context.go('/contact'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RiptideColors.white,
                    backgroundColor: RiptideColors.deepOcean,
                    shape: const RoundedRectangleBorder(),
                    side: const BorderSide(color: RiptideColors.aqua),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                  ),
                  child: const Text(HomeContent.aquariumAction),
                ),
              ],
            ),
          ],
        );
        return Stack(
          children: [
            if (wide)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: .72,
                    child: _HeroImage(wide: true),
                  ),
                ),
              ),
            if (wide)
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        RiptideColors.deepOcean,
                        RiptideColors.deepOcean,
                        Color(0x00000000),
                      ],
                      stops: [0, .45, 1],
                    ),
                  ),
                ),
              ),
            _Section(
              vertical: wide ? 88 : 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: wide ? 590 : null, child: copy),
                  if (!wide) ...[
                    const SizedBox(height: 24),
                    const AspectRatio(
                      aspectRatio: 1.5,
                      child: _HeroImage(wide: false),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(
        RiptideAssets.heroDiscus,
        fit: BoxFit.cover,
        alignment: const Alignment(.55, -.35),
        semanticLabel:
            'Brilliant blue discus swimming in an ocean-blue aquarium',
      ),
      // The source artwork includes captions at its edges; soften those edges
      // while keeping the real discus image and accessible page text separate.
      DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color(0x00000000),
              Color(0x00000000),
              RiptideColors.deepOcean,
            ],
            stops: [0, wide ? .58 : .5, 1],
          ),
        ),
      ),
    ],
  );
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: RiptideColors.seaMist,
    child: _Section(
      vertical: 26,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1000
              ? 4
              : constraints.maxWidth >= 550
              ? 2
              : 1;
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              for (final item in RiptideConfig.trust)
                SizedBox(
                  width: (constraints.maxWidth - (columns - 1) * 24) / columns,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: RiptideColors.white,
                          border: Border.all(color: _brass),
                        ),
                        child: SvgPicture.asset(
                          item.asset,
                          width: 25,
                          height: 25,
                          excludeFromSemantics: true,
                          colorFilter: const ColorFilter.mode(
                            RiptideColors.ocean,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.detail,
                              style: const TextStyle(fontSize: 12, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard(this.category);
  final Category category;

  @override
  Widget build(BuildContext context) => Material(
    color: RiptideColors.white,
    shape: const RoundedRectangleBorder(
      side: BorderSide(color: _brass),
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => context.go(
        Uri(
          path: '/shop',
          queryParameters: {'category': category.id},
        ).toString(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.25,
            child: Image.asset(
              category.imageAsset,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    color: RiptideColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.description,
                  style: const TextStyle(color: RiptideColors.ink, height: 1.5),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Explore collection',
                        style: TextStyle(
                          color: RiptideColors.ocean,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: RiptideColors.ocean,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Mission extends StatelessWidget {
  const _Mission();

  @override
  Widget build(BuildContext context) => _EngravedPanel(
    child: _Section(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final image = Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(color: _brass)),
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: 1.1,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  maxWidth: double.infinity,
                  child: Image.asset(
                    RiptideAssets.missionCoral,
                    height: constraints.maxWidth >= 850
                        ? (constraints.maxWidth - 64) * .44 / 1.1
                        : constraints.maxWidth / 1.1,
                    fit: BoxFit.fitHeight,
                    semanticLabel:
                        'Delicate branching corals in a deep blue reef',
                  ),
                ),
              ),
            ),
          );
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('OUR PASSION. OUR PURPOSE.', light: true),
              const SizedBox(height: 16),
              const _Heading(RiptideConfig.missionTitle, light: true),
              const SizedBox(height: 20),
              const Text(
                RiptideConfig.missionDescription,
                style: TextStyle(
                  color: RiptideColors.seaMist,
                  fontSize: 16,
                  height: 1.75,
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 36,
                runSpacing: 24,
                children: [
                  for (final statistic in RiptideConfig.demoStatistics)
                    _Statistic(statistic.value, statistic.label),
                ],
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => context.go('/about'),
                icon: const Icon(Icons.arrow_forward, size: 18),
                style: _brassButton,
                label: const Text('Discover our story'),
              ),
            ],
          );
          if (constraints.maxWidth < 850) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [image, const SizedBox(height: 32), copy],
            );
          }
          return Row(
            children: [
              Expanded(flex: 44, child: image),
              const SizedBox(width: 64),
              Expanded(flex: 56, child: copy),
            ],
          );
        },
      ),
    ),
  );
}

class _Statistic extends StatelessWidget {
  const _Statistic(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 135,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Georgia',
            color: RiptideColors.aqua,
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: RiptideColors.white,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

class _Newsletter extends StatefulWidget {
  const _Newsletter();

  @override
  State<_Newsletter> createState() => _NewsletterState();
}

class _NewsletterState extends State<_Newsletter> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  String? _subscribedEmail;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _subscribe() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _subscribedEmail = _email.text.trim());
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: RiptideColors.seaMist,
    child: _Section(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 660),
          child: Column(
            children: [
              const Icon(Icons.waves, color: RiptideColors.ocean, size: 36),
              const SizedBox(height: 16),
              const _Heading(
                RiptideConfig.newsletterTitle,
                align: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                RiptideConfig.newsletterDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (_subscribedEmail != null)
                Semantics(
                  liveRegion: true,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: RiptideColors.ocean,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You’re on the local demo list!\n$_subscribedEmail',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          _subscribedEmail = null;
                          _email.clear();
                        }),
                        child: const Text('Remove local signup'),
                      ),
                    ],
                  ),
                )
              else
                Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final field = TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.email],
                        autocorrect: false,
                        onFieldSubmitted: (_) => _subscribe(),
                        style: const TextStyle(color: RiptideColors.ink),
                        cursorColor: RiptideColors.ocean,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          hintText: 'you@example.com',
                          labelStyle: TextStyle(color: RiptideColors.ink),
                          hintStyle: TextStyle(color: RiptideColors.ocean),
                          filled: true,
                          fillColor: RiptideColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: _brass),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: RiptideColors.ocean,
                              width: 2,
                            ),
                          ),
                          errorMaxLines: 3,
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) return 'Enter your email address.';
                          if (email.length > 254 ||
                              !RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$')
                                  .hasMatch(email)) {
                            return 'Enter a valid email address, such as you@example.com.';
                          }
                          return null;
                        },
                      );
                      final button = FilledButton(
                        style: _brassButton,
                        onPressed: _subscribe,
                        child: const Text('Count me in'),
                      );
                      if (constraints.maxWidth < 520 ||
                          MediaQuery.textScalerOf(context).scale(16) > 24) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [field, const SizedBox(height: 12), button],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: field),
                          const SizedBox(width: 12),
                          button,
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                HomeContent.newsletterNotice,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, height: 1.5),
              ),
              TextButton(
                onPressed: () => context.go('/privacy'),
                child: const Text('Read our privacy policy'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Informational route body, deliberately independent of the global shell.
class RiptideInfoPage extends StatelessWidget {
  const RiptideInfoPage({super.key, required this.section});
  final String section;

  @override
  Widget build(BuildContext context) {
    final content = HomeContent.infoFor(section);
    return ListView(
      key: ValueKey(section),
      children: [
        ColoredBox(
          color: RiptideColors.deepOcean,
          child: _Section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _Eyebrow(content.eyebrow, light: true),
                const SizedBox(height: 16),
                _Heading(content.title, light: true),
                const SizedBox(height: 20),
                Text(
                  content.intro,
                  style: const TextStyle(
                    color: RiptideColors.seaMist,
                    fontSize: 18,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        _Section(
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (title, body) in content.sections) ...[
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontFamily: 'Georgia'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      body,
                      style: const TextStyle(fontSize: 16, height: 1.8),
                    ),
                    const SizedBox(height: 32),
                  ],
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton(
                        onPressed: () => context.go('/shop'),
                        child: const Text('Explore the collections'),
                      ),
                      OutlinedButton(
                        onPressed: () => context.go('/'),
                        child: const Text('Back to home'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const _Footer(),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: RiptideColors.ink,
    child: _Section(
      vertical: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Wrap(
              spacing: 40,
              runSpacing: 32,
              children: [
                SizedBox(
                  width: constraints.maxWidth < 280
                      ? constraints.maxWidth
                      : 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        HomeContent.storefrontName,
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          color: RiptideColors.white,
                          fontSize: 30,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        RiptideConfig.tagline,
                        style: TextStyle(
                          color: RiptideColors.seaMist,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _FooterContact(),
                    ],
                  ),
                ),
                for (final group in RiptideConfig.footerNavigation.entries)
                  SizedBox(
                    width: constraints.maxWidth < 200
                        ? constraints.maxWidth
                        : 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.key,
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            color: RiptideColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (final link in group.value.entries)
                          TextButton(
                            onPressed: () => context.go(link.value),
                            style: TextButton.styleFrom(
                              foregroundColor: RiptideColors.seaMist,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.centerLeft,
                            ),
                            child: Text(link.key),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Divider(color: _brass),
          const SizedBox(height: 16),
          Text(
            '© ${DateTime.now().year} ${RiptideConfig.name}. A world of wonder.\n${RiptideConfig.demoNotice}',
            style: const TextStyle(
              color: RiptideColors.seaMist,
              fontSize: 12,
              height: 1.8,
            ),
          ),
        ],
      ),
    ),
  );
}

class _FooterContact extends StatelessWidget {
  const _FooterContact();

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: RiptideColors.seaMist,
      fontSize: 13,
      height: 1.6,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get in touch',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: RiptideColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        SelectableText(RiptideConfig.contact.email),
        SelectableText(RiptideConfig.contact.phone),
        Text(RiptideConfig.contact.location),
        const SizedBox(height: 16),
        const Text(
          'Hours · Demo schedule',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: RiptideColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        for (final hours in RiptideConfig.hours.entries)
          Text('${hours.key}: ${hours.value}'),
        const SizedBox(height: 16),
        const Text(
          'Stay connected',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: RiptideColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        for (final profile in RiptideConfig.social.entries)
          if (profile.value == null)
            Text('${profile.key} · Coming soon')
          else
            SelectableText('${profile.key}: ${profile.value}'),
      ],
    ),
  );
}

// A darker brass is reserved for fine rules on parchment; aqua is the gold accent.
const _brass = Color(0xFF8B693D);

final _brassButton = FilledButton.styleFrom(
  backgroundColor: RiptideColors.aqua,
  foregroundColor: RiptideColors.deepOcean,
  shape: const RoundedRectangleBorder(side: BorderSide(color: _brass)),
);

class _EngravedPanel extends StatelessWidget {
  const _EngravedPanel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: RiptideColors.deepOcean,
      border: Border.symmetric(horizontal: BorderSide(color: _brass, width: 2)),
    ),
    padding: const EdgeInsets.all(6),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: _brass)),
      child: child,
    ),
  );
}

// Text sections determine their own height within the shared content-width token.
class _Section extends StatelessWidget {
  const _Section({required this.child, this.vertical = 64});
  final Widget child;
  final double vertical;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.sizeOf(context).width < 600 ? 20 : 40,
      vertical: vertical,
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: RiptideTokens.contentMaxWidth,
        ),
        child: SizedBox(width: double.infinity, child: child),
      ),
    ),
  );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.light = false});
  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: light ? RiptideColors.aqua : RiptideColors.ocean,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 2,
      height: 1.6,
    ),
  );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {this.light = false, this.align = TextAlign.start});
  final String text;
  final bool light;
  final TextAlign align;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontFamily: 'Georgia',
        color: light ? RiptideColors.white : RiptideColors.ink,
        fontSize: MediaQuery.sizeOf(context).width < 600 ? 30 : 38,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -.8,
      ),
    ),
  );
}
