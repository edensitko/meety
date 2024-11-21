import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _meetingTitleController = TextEditingController();
  final TextEditingController _meetingDescriptionController = TextEditingController();
  
  double? price;

  void _processPayment() {
    if (price != null && price! > 0) {
      // Integrate payment gateway (Stripe/PayPal) here

      // Show payment successful page
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Payment Successful'),
            content: Text('You have successfully paid $price for the meeting.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Redirect to meeting confirmation or main page
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show error if price is not entered correctly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount for payment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Schedule Paid Meeting')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _meetingTitleController,
              decoration: InputDecoration(labelText: 'Meeting Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _meetingDescriptionController,
              decoration: InputDecoration(labelText: 'Meeting Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Payment Amount (USD)'),
              onChanged: (value) {
                setState(() {
                  price = double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _processPayment,
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
