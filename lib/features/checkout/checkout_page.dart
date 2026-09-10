import 'package:flutter/material.dart';

import '../../core/models/service.dart';
import '../../core/services/commerce_services.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/site_chrome.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.service});
  final Service service;
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final notes = TextEditingController();
  int step = 0;
  String? confirmation;

  @override
  void dispose() {
    for (final controller in [name, email, phone, address, notes]) {
      controller.dispose();
    }
    super.dispose();
  }

  void next() {
    if (step == 0 && !(formKey.currentState?.validate() ?? false)) return;
    setState(() => step++);
  }

  Future<void> finish() async {
    final details = CustomerDetails(
      name: name.text,
      email: email.text,
      phone: phone.text,
      address: address.text,
      notes: notes.text,
    );
    final id = await MockBookingService().createRequest(
      widget.service,
      details,
    );
    if (mounted) {
      setState(() {
        confirmation = id;
        step = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (confirmation != null) {
      return _Confirmation(name: name.text, confirmation: confirmation!);
    }
    return Scaffold(
      appBar: const SiteHeader(),
      body: ListView(
        children: [
          PageFrame(
            maxWidth: 920,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 52),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete your request',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step ${step + 1} of 2 · ${step == 0 ? 'Your details' : 'Review and payment'}',
                  ),
                  const SizedBox(height: 30),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final form = step == 0
                          ? Form(
                              key: formKey,
                              child: _Details(
                                name: name,
                                email: email,
                                phone: phone,
                                address: address,
                                notes: notes,
                              ),
                            )
                          : _Review();
                      final summary = _Summary(service: widget.service);
                      return constraints.maxWidth < 700
                          ? Column(
                              children: [
                                form,
                                const SizedBox(height: 22),
                                summary,
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 3, child: form),
                                const SizedBox(width: 28),
                                Expanded(flex: 2, child: summary),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      if (step == 1)
                        TextButton(
                          onPressed: () => setState(() => step = 0),
                          child: const Text('Back'),
                        ),
                      const Spacer(),
                      FilledButton(
                        onPressed: step == 0 ? next : finish,
                        child: Text(
                          step == 0 ? 'Continue to review' : 'Confirm request',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Confirmation extends StatelessWidget {
  const _Confirmation({required this.name, required this.confirmation});
  final String name, confirmation;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: Center(
      child: PageFrame(
        maxWidth: 600,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 70,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 18),
                Text(
                  'You’re all set.',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Text(
                  'Thanks, $name. Your request is confirmed as $confirmation. We’ll be in touch shortly to confirm the details.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                FilledButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (_) => false,
                  ),
                  child: const Text('Back to home'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _Details extends StatelessWidget {
  const _Details({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.notes,
  });
  final TextEditingController name, email, phone, address, notes;
  String? requiredField(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextFormField(
        controller: name,
        decoration: const InputDecoration(labelText: 'Full name'),
        validator: requiredField,
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email address'),
        validator: (value) => value == null || !value.contains('@')
            ? 'Enter a valid email'
            : null,
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: phone,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(labelText: 'Phone number'),
        validator: requiredField,
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: address,
        decoration: const InputDecoration(labelText: 'Service address'),
        validator: requiredField,
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: notes,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Anything we should know? (optional)',
        ),
      ),
    ],
  );
}

class _Summary extends StatelessWidget {
  const _Summary({required this.service});
  final Service service;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order summary',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const Divider(height: 28),
          Text(
            service.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(service.shortDescription),
          const SizedBox(height: 18),
          Text(
            service.priceLabel,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(height: 28),
          const Text(
            'No card details are collected in this demo.',
            style: TextStyle(fontSize: 12, color: Color(0xFF586560)),
          ),
        ],
      ),
    ),
  );
}

class _Review extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment integration placeholder',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Text(
            'This is the boundary where a provider such as Square or Stripe would securely collect payment. This demo only submits a service request.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outline),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Secure payment provider integration coming soon.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
