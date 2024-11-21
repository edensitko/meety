import 'package:meety/providers/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UnreadMessagesProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _unreadCount = 0;
  List<Message> _unreadMessages = [];

  int get unreadCount => _unreadCount;
  List<Message> get unreadMessages => _unreadMessages;

  UnreadMessagesProvider() {
    _fetchUnreadMessages();
  }

  Future<void> _fetchUnreadMessages() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot snapshot = await _firestore.collection('chats')
            .where('participants', arrayContains: user.email)
            .get();

        int count = 0;
        List<Message> messages = [];

        for (var doc in snapshot.docs) {
          QuerySnapshot unreadSnapshot = await _firestore.collection('chats')
              .doc(doc.id)
              .collection('messages')
              .where('to', isEqualTo: user.email)
              .where('read', isEqualTo: false)
              .get();

          count += unreadSnapshot.size;

          for (var messageDoc in unreadSnapshot.docs) {
            messages.add(
              Message(
                senderName: messageDoc['from'] ?? 'Unknown',
                content: messageDoc['text'] ?? '',
                messageId: messageDoc.id,
              ),
            );
          }
        }

        _unreadCount = count;
        _unreadMessages = messages;
        notifyListeners();
      } catch (e) {
        print('Error fetching unread messages: $e');
      }
    }
  }

  void refreshUnreadCount() {
    _fetchUnreadMessages();
  }
}
