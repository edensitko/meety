import 'package:flutter/material.dart';

class FriendRequest {
  final String senderName;
  final String requestId;

  FriendRequest({required this.senderName, required this.requestId});
}

class FriendRequestProvider with ChangeNotifier {
  final List<FriendRequest> _unreadRequests = [];

  List<FriendRequest> get unreadRequests => _unreadRequests;

  int get unreadRequestCount => _unreadRequests.length;

  void addRequest(FriendRequest request) {
    _unreadRequests.add(request);
    notifyListeners();
  }

  void clearRequests() {
    _unreadRequests.clear();
    notifyListeners();
  }
}
