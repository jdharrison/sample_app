import '../models/service.dart';

class CustomerDetails {
  const CustomerDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.notes,
  });
  final String name;
  final String email;
  final String phone;
  final String address;
  final String notes;
}

abstract interface class PaymentService {
  Future<String> createPaymentIntent(Service service, CustomerDetails customer);
}

abstract interface class BookingService {
  Future<String> createRequest(Service service, CustomerDetails customer);
}

class MockPaymentService implements PaymentService {
  @override
  Future<String> createPaymentIntent(
    Service service,
    CustomerDetails customer,
  ) async => 'demo-payment-intent';
}

class MockBookingService implements BookingService {
  @override
  Future<String> createRequest(
    Service service,
    CustomerDetails customer,
  ) async =>
      'HH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
}
