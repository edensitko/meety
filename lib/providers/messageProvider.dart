import 'package:flutter/material.dart';

class Message {
  final String senderName;
  final String content;
  final String messageId;

  Message({required this.senderName, required this.content, required this.messageId});
}

class MessageProvider with ChangeNotifier {
  final List<Message> _unreadMessages = [];

  List<Message> get unreadMessages => _unreadMessages;

  bool get hasUnreadMessages => _unreadMessages.isNotEmpty;

  void addMessage(Message message) {
    _unreadMessages.add(message);
    notifyListeners();
  }

  void clearMessages() {
    _unreadMessages.clear();
    notifyListeners();
  }
}
