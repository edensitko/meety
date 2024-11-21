import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;

  NotificationProvider() {
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final user = _auth.currentUser;
    if (user == null) return;

    print('Fetching notifications for user: ${user.email}');
    
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('visits')
          .where('visitedUser', isEqualTo: user.email)
          .orderBy('timestamp', descending: true)
          .get();

      print('Fetched ${snapshot.docs.length} notifications');

      // Fetch additional details from the users collection
      _notifications = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final visitedByEmail = data['visitedBy'] as String?;

        if (visitedByEmail != null) {
          // Fetch user details from users collection
          DocumentSnapshot userDoc = await _firestore
              .collection('users')
              .where('email', isEqualTo: visitedByEmail)
              .limit(1)
              .get()
              .then((snapshot) => snapshot.docs.first);

          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;
            data['visitorName'] = userData['name'] ?? 'Unknown';
            data['visitorImage'] = userData['profileImageUrl']?? '';
            data['visitorEmail'] = userData['email'] ?? '';
           print('Fetched visitor image URL: ${data['visitorImage']}');

          } else {
            data['visitorName'] = 'Unknown';
            data['visitorImage'] = '';
          }
        }

        print('Notification data with user details: $data');
        return data;
      }).toList());

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching notifications: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    _isLoading = true;
    notifyListeners();
    await _fetchNotifications();
  }
}
