import 'package:stripe_payment/stripe_payment.dart';

class PaymentGatewayService {
  static void initializeStripe() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: "your_publishable_key_here",
      merchantId: "Test",
      androidPayMode: 'test',
    ));
  }

  // static Future<void> makePayment(double amount) async {
  //   // Call your backend to create a payment intent and get client secret
  //   String clientSecret = await createPaymentIntent(amount);

  //   // Show the payment sheet to the user
  //   await StripePayment.paymentRequestWithCardForm().then((paymentMethod) async {
  //     // Confirm the payment
  //     await StripePayment.confirmPaymentIntent(
  //       PaymentIntent(clientSecret: clientSecret, paymentMethodId: paymentMethod.id),
  //     );
  //   });
  // }

  static Future<String> createPaymentIntent(double amount) async {
    // Call your backend to create payment intent
    // This should return the clientSecret
    return 'your_client_secret_here';
  }
}
