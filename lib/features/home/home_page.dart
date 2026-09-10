import 'package:flutter/material.dart';

import '../../core/config/business_config.dart';
import '../../core/services/catalog_service.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/site_chrome.dart';
import '../services/service_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    const catalog = MockCatalogService();
    return Scaffold(
      appBar: const SiteHeader(),
      body: ListView(
        children: [
          _Hero(),
          _Stats(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 82),
            child: PageFrame(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading(
                    eyebrow: 'Made for your home',
                    title: 'Care that makes a difference.',
                    description: 'Choose a thoughtful service, confirm a time, and enjoy a home that feels effortlessly cared for.',
                  ),
                  const SizedBox(height: 38),
                  LayoutBuilder(
                    builder: (context, c) {
                      final n = c.maxWidth > 850 ? 3 : 1;
                      return GridView.count(
                        crossAxisCount: n,
                        childAspectRatio: n == 1 ? 1.4 : .86,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: catalog.allServices
                            .take(3)
                            .map((s) => ServiceCard(service: s))
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/services'),
                    child: const Text('View all services'),
                  ),
                ],
              ),
            ),
          ),
          _Benefits(),
          _Process(),
          _Testimonials(),
          _Faq(),
          _BottomCta(),
          const SiteFooter(),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFF0F7F2), Color(0xFFFFFCF7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: PageFrame(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 65),
        child: LayoutBuilder(
          builder: (context, c) {
            final stacked = c.maxWidth < 760;
            final art = Container(
              height: 370,
              decoration: BoxDecoration(
                color: const Color(0xFFB6D9C9),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 25,
                    top: 25,
                    child: Icon(
                      Icons.spa_outlined,
                      size: 70,
                      color: Colors.white.withValues(alpha: .7),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.home_rounded,
                      size: 165,
                      color: Color(0xFF176B5B),
                    ),
                  ),
                ],
              ),
            );
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LOCAL HOME CARE, ELEVATED',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your home,\nthoughtfully cared for.',
                  style: Theme.of(context).textTheme.displayMedium
                      ?.copyWith(fontWeight: FontWeight.w900, height: .98),
                ),
                const SizedBox(height: 18),
                Text(
                  '${businessConfig.tagline} From a weekly refresh to a complete reset, our trusted local team makes it simple.',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(height: 1.55, color: const Color(0xFF52615C)),
                ),
                const SizedBox(height: 26),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/services'),
                      child: const Text('Explore services'),
                    ),
                    OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/services'),
                      child: const Text('How it works'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Row(
                  children: [
                    Icon(Icons.star_rounded, color: Color(0xFFE3A52A)),
                    Text(
                      ' 4.9/5 from 280+ neighbors',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            );
            return stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [copy, const SizedBox(height: 38), art],
                  )
                : Row(
                    children: [
                      Expanded(child: copy),
                      const SizedBox(width: 54),
                      Expanded(child: art),
                    ],
                  );
          },
        ),
      ),
    ),
  );
}

class _Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF176B5B),
    child: PageFrame(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 32,
          runSpacing: 20,
          children: const [
            _Stat('4.9 / 5', 'average neighbor rating'),
            _Stat('2,400+', 'homes thoughtfully cared for'),
            _Stat('10 years', 'of trusted local service'),
            _Stat('Fully insured', 'for complete peace of mind'),
          ],
        ),
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value, label;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 190,
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFC5DDD4)),
        ),
      ],
    ),
  );
}

class _Benefits extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFFF0F7F2),
    padding: const EdgeInsets.symmetric(vertical: 80),
    child: PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'The Hearth difference',
            title: 'Good people. Exceptional care.',
            description: 'We bring calm, consistency, and a little more room to breathe to every visit.',
          ),
          const SizedBox(height: 35),
          LayoutBuilder(
            builder: (context, c) => GridView.count(
              crossAxisCount: c.maxWidth > 800 ? 4 : 2,
              childAspectRatio: 1.1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _Benefit(
                  Icons.verified_user_outlined,
                  'Vetted experts',
                  'Kind, capable professionals.',
                ),
                _Benefit(
                  Icons.event_available_outlined,
                  'Easy booking',
                  'Clear times and communication.',
                ),
                _Benefit(
                  Icons.eco_outlined,
                  'Thoughtful products',
                  'Effective, home-friendly care.',
                ),
                _Benefit(
                  Icons.favorite_outline,
                  'Satisfaction promise',
                  'We make it right, every time.',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Benefit extends StatelessWidget {
  const _Benefit(this.icon, this.title, this.copy);
  final IconData icon;
  final String title, copy;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(copy, style: const TextStyle(color: Color(0xFF586560))),
      ],
    ),
  );
}

class _Process extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 82),
    child: PageFrame(
      child: Column(
        children: [
          const SectionHeading(
            eyebrow: 'How it works',
            title: 'Care in three easy steps.',
            description: 'A simpler way to cross home care off your list.',
          ),
          const SizedBox(height: 42),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: const [
              _Step(
                '01',
                'Choose your service',
                'Find the visit that fits your home.',
              ),
              _Step(
                '02',
                'Confirm the details',
                'Share your address and preferred timing.',
              ),
              _Step(
                '03',
                'Enjoy the difference',
                'Our experts arrive ready to help.',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _Step extends StatelessWidget {
  const _Step(this.number, this.title, this.copy);
  final String number, title, copy;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 320,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 32,
            color: Color(0xFF79A895),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(copy, style: const TextStyle(color: Color(0xFF586560))),
      ],
    ),
  );
}

class _Testimonials extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF16322B),
    padding: const EdgeInsets.symmetric(vertical: 75),
    child: PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KIND WORDS FROM OUR NEIGHBORS',
            style: TextStyle(
              color: Color(0xFF9ED4C2),
              letterSpacing: 1.4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              _Quote(
                '“They made our home feel brand new—and made the whole process feel effortless.”',
                'Maya R.',
              ),
              _Quote(
                '“Reliable, warm, and meticulous. Hearth & Home has become part of our routine.”',
                'Jordan T.',
              ),
              _Quote(
                '“The kind of service you tell your friends about.”',
                'Elena P.',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _Quote extends StatelessWidget {
  const _Quote(this.quote, this.name);
  final String quote, name;
  @override
  Widget build(BuildContext context) => Container(
    width: 350,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quote,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFFB6D9C9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

class _Faq extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 78),
    child: PageFrame(
      maxWidth: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Questions, answered',
            title: 'A little more clarity.',
            description:
                'Everything you need to feel comfortable before booking.',
          ),
          const SizedBox(height: 26),
          ...const [
            (
              'What is included in a visit?',
              'Every service includes a detailed checklist. You can review inclusions on each service page.',
            ),
            (
              'Do I need to be home?',
              'Not at all. Many clients share entry instructions securely when they book.',
            ),
            (
              'What if my needs are different?',
              'Choose Custom Project and we will create a plan around your home.',
            ),
          ].map(
            (f) => ExpansionTile(
              title: Text(
                f.$1,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(f.$2),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _BottomCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFFE4F0EA),
    padding: const EdgeInsets.symmetric(vertical: 70),
    child: PageFrame(
      child: Center(
        child: Column(
          children: [
            Text(
              'A more cared-for home is a few clicks away.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/services'),
              child: const Text('Find your service'),
            ),
          ],
        ),
      ),
    ),
  );
}
