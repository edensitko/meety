import 'package:flutter/material.dart';

class PaymentBottomSheet extends StatelessWidget {
  const PaymentBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Payment Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Expiration Date',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'CVV',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle payment logic here
              Navigator.pop(context); // Close the bottom sheet
            },
            child: Text('Pay'),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the bottom sheet
            },
            child: Text('Back'),
          ),
        ],
      ),
    );
  }
}
