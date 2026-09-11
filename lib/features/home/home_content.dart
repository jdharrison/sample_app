import '../../core/config/riptide.dart';

/// Informational copy complements the canonical brand and home copy in config.
abstract final class HomeContent {
  static const eyebrow = 'A WORLD WORTH DISCOVERING';
  static const storefrontName = 'RipTide Aquatics';
  static const shopAction = 'Shop Exotic Fish';
  static const aquariumAction = 'Build Your Aquarium';

  static const collectionTitle = 'Find your underwater world';
  static const collectionDescription =
      'From your first freshwater aquarium to your next reef adventure.';

  static const newsletterNotice =
      'Demo newsletter: your email stays in this page’s memory. Nothing is sent or saved to a server.';

  static const Map<String, InfoContent> information = {
    'account': InfoContent(
      'YOUR RIPTIDE · COMING SOON',
      'Your underwater world, all in one place.',
      'A more personal Riptide experience is on the horizon. '
          'Accounts are coming soon—not available in this demo.',
      [
        (
          'A home for your aquarium journey',
          'We’re imagining a space for your favorite discoveries, aquarium profiles, '
              'and care inspiration tailored to the habitats you love. These account features '
              'are a preview, not services available today.',
        ),
        (
          'Keep exploring in the meantime',
          'Browse the collections and use the heart on a product to keep a local list '
              'of favorites during this app session. No sign-in is needed. Favorites and '
              'your demo cart are not synced to an account or saved after an app restart.',
        ),
        (
          'No password. No personal details.',
          'There is no registration, login, or account storage connected to this demo. '
              'You don’t need to share credentials to explore. We’ll only ask for account '
              'details when a real, secure account service is available.',
        ),
      ],
    ),
    'about': InfoContent(
      'OUR STORY',
      RiptideConfig.missionTitle,
      'A thriving underwater world starts with respect for the life inside it.',
      [
        (
          'Wonder, with responsibility',
          'Riptide is a demonstration aquarium storefront built around discovery and thoughtful care. Explore freshwater fish, marine companions, plants, and habitat essentials without placing a real livestock order.',
        ),
        (
          'The habitat comes first',
          'Choose animals for the aquarium you can maintain, not just their colors. Research adult size, social needs, temperature, water chemistry, and compatibility before adding any species.',
        ),
        (
          'A lifelong learning experience',
          'Start slowly, observe your aquarium daily, and make changes thoughtfully. Our catalog includes species-specific care details to help you ask the right questions before your next addition.',
        ),
      ],
    ),
    'resources': InfoContent(
      'LEARN & GROW',
      'Good care makes all the difference.',
      'Practical starting points for a healthier, more rewarding aquarium.',
      [
        (
          '01 — Cycle before you stock',
          'Establish biological filtration before introducing animals. Test ammonia, nitrite, and nitrate with an appropriate kit; a new tank should consistently process ammonia and nitrite before stocking. Cycling time varies—measure, rather than guessing from a calendar.',
        ),
        (
          '02 — Match the habitat to the species',
          'Check the product’s care details for minimum tank size, temperature, and temperament. Marine tanks also need stable salinity. Minimum volumes are starting points, not a guarantee that a mixed community will work.',
        ),
        (
          '03 — Introduce new arrivals carefully',
          'Research species-specific acclimation and quarantine before purchase. Avoid transferring transport water into the display aquarium, and monitor feeding, breathing, and behavior after introduction.',
        ),
        (
          '04 — Build a maintenance routine',
          'Test water regularly, perform appropriate partial water changes, and maintain filtration without destroying beneficial bacteria. Use conditioned freshwater when required and avoid sudden temperature or chemistry changes.',
        ),
        (
          'When something seems wrong',
          'Check water quality first and seek advice from a qualified aquatic veterinarian or experienced aquarium professional. These general guides do not replace species-specific or veterinary advice.',
        ),
      ],
    ),
    'contact': InfoContent(
      'LET’S TALK AQUARIUMS',
      'Start with the right questions.',
      'A little preparation goes a long way toward a thriving habitat.',
      [
        (
          'Before asking for stocking advice',
          'Have your tank volume, age, filtration, temperature, water-test results, and existing livestock list ready. For marine systems, include salinity. These details are more useful than a photo alone.',
        ),
        (
          'About orders and support',
          'This is a demo storefront, not an operating livestock retailer. There is no monitored support inbox, live chat, or shipping service attached to this experience. Please do not enter sensitive information expecting a real order or response.',
        ),
        (
          'Need help with animal health?',
          'Contact a qualified aquatic veterinarian or a trusted local aquarium specialist. If an animal is in distress, seek timely local assistance rather than waiting for support from this demo.',
        ),
      ],
    ),
    'privacy': InfoContent(
      'YOUR INFORMATION',
      'Privacy, in plain language.',
      'Understand what this demonstration does with information you enter.',
      [
        (
          'Newsletter information',
          'The home-page newsletter validates an email address and holds it only in the current widget’s memory. It does not send email, contact a mailing provider, or persist a subscription. Leaving or reloading the page clears that state.',
        ),
        (
          'Shopping and checkout',
          'The demo Store keeps cart and favorite selections in memory. Demo checkout is not a payment service and does not ship products. Do not enter real payment details or other sensitive personal information.',
        ),
        (
          'Hosting and external services',
          'This page describes the demo’s local behavior, not a production privacy commitment. Hosting infrastructure may process standard connection information under its own policies. A real deployment needs an operator-specific privacy notice before collecting customer data.',
        ),
      ],
    ),
    'terms': InfoContent(
      'THE IMPORTANT DETAILS',
      'Terms of this demo.',
      'Explore freely, with a clear understanding of the experience.',
      [
        (
          'Demonstration only',
          'Products, prices, and availability are illustrative. Adding items to a cart or completing demo checkout does not form a purchase agreement, collect payment, reserve inventory, or arrange shipment.',
        ),
        (
          'Care information',
          'Care guidance is educational and may not cover every aquarium or animal. Verify species requirements, local regulations, and responsible sourcing independently before acquiring livestock.',
        ),
        (
          'No commercial promises',
          'Imagery may contain illustrative marketing claims. No live-arrival guarantee, support availability, customer count, or shipping promise is offered by this demo. Production terms must be established by an actual retailer.',
        ),
      ],
    ),
    'shipping': InfoContent(
      'PLAN AHEAD',
      'A safe arrival starts before delivery.',
      'This storefront does not ship livestock. Here is what to consider with a real supplier.',
      [
        (
          'Confirm the supplier’s policy',
          'Check delivery coverage, weather restrictions, dispatch schedules, and arrival guarantees directly with the retailer. Arrange to receive live animals promptly rather than leaving packages unattended.',
        ),
        (
          'Prepare a suitable habitat',
          'Have a mature aquarium or appropriate quarantine system ready. Confirm species-specific water requirements and acclimation instructions before the animals arrive.',
        ),
        (
          'If there is an arrival problem',
          'Follow the actual seller’s reporting time limits and documentation requirements. Riptide’s demo cannot process delivery claims, refunds, or replacements.',
        ),
      ],
    ),
    'faq': InfoContent(
      'COMMON QUESTIONS',
      'A little clarity before you dive in.',
      'Answers for exploring the Riptide demo and planning an aquarium.',
      [
        (
          'Can I buy or reserve a fish here?',
          'No. The catalog and checkout are demonstrations. No payment is taken and no livestock is shipped or reserved.',
        ),
        (
          'How do I choose a collection?',
          'Freshwater and saltwater livestock require different habitats. Aquatic plants in this catalog are for freshwater setups. Open a product to review its care requirements before planning a community.',
        ),
        (
          'Why is a collection empty?',
          'The demo catalog is intentionally small. Aquarium essentials is a preview collection and may not contain products yet.',
        ),
        (
          'Does the newsletter send real emails?',
          'No. Signup is validated locally and acknowledged on the page. There is no mailing-list integration or persistent subscription.',
        ),
      ],
    ),
  };

  static InfoContent infoFor(String section) {
    final key = section.trim().toLowerCase().replaceAll(RegExp(r'^/+|/+$'), '');
    final canonical = switch (key) {
      'our-story' => 'about',
      'care' || 'care-guides' => 'resources',
      'support' => 'contact',
      'privacy-policy' => 'privacy',
      'terms-of-service' => 'terms',
      'returns' || 'shipping-returns' => 'shipping',
      _ => key,
    };
    return information[canonical] ??
        const InfoContent(
          'KEEP EXPLORING',
          'There’s more beneath the surface.',
          'That guide is not available in this demo yet.',
          [
            (
              'Find your next step',
              'Explore our collections, read the care resources, or visit our story to learn about thoughtful aquarium keeping.',
            ),
          ],
        );
  }
}

class InfoContent {
  const InfoContent(this.eyebrow, this.title, this.intro, this.sections);
  final String eyebrow;
  final String title;
  final String intro;
  final List<(String, String)> sections;
}
