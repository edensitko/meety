import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  late String _userName;
  late String _userEmail;
  late String _userProfilePicture;
  late double _userBalance;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _userName = userData['name'] ?? 'User';
          _userEmail = userData['email'] ?? 'No email';
          _userBalance = userData['balance'] ?? 0.0;
          _userProfilePicture = userData['profilePicture'] ?? ''; // Add default if necessary
        });
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Balance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
        ],
      ),
      body: _userName == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _userProfilePicture.isNotEmpty
                        ? NetworkImage(_userProfilePicture)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hello, $_userName',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: $_userEmail',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Balance: \$${_userBalance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to payment screen
                    },
                    child: const Text('Add Funds'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Open balance details in a bottom sheet
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return _buildBalanceDetails();
                        },
                      );
                    },
                    child: const Text('View Balance Details'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBalanceDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Balance Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Current Balance: \$${_userBalance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Last Payment: \$50.00', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Next Payment Due: \$25.00', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Handle payment
            },
            child: const Text('Make Payment'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: BalanceScreen(),
  ));
}
