import 'package:meety/providers/userActionProvider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  final String? userEmail;

  const UserProfileScreen({super.key, this.userEmail});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _userSettings;
  bool _isCurrentUser = false;
  List<dynamic> _photoGallery = [];
  List<dynamic> _interests = [];
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _checkFriendStatus();
    _recordVisit(); // Record the visit when the profile is opened

  }

Future<List<String>> _fetchVisitors() async {
  try {
    QuerySnapshot visitSnapshot = await FirebaseFirestore.instance
        .collection('visits')
        .where('visitedUser', isEqualTo: widget.userEmail)
        .get();

    List<String> visitors = visitSnapshot.docs.map((doc) {
      return doc['visitedBy'] as String;
    }).toList();

    return visitors;
  } catch (e) {
    print('Error fetching visitors: $e');
    return [];
  }
}



Future<void> _recordVisit() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null || widget.userEmail == null) return;

  try {
    await FirebaseFirestore.instance.collection('visits').add({
      'visitedBy': currentUser.email,
      'visitedUser': widget.userEmail,
      'timestamp': Timestamp.now(),
    });
  } catch (e) {
    print('Error recording visit: $e');
  }
}
  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String emailToFetch = widget.userEmail ?? currentUser.email!;

        // Check if the user is viewing their own profile
        _isCurrentUser = (emailToFetch == currentUser.email);

        if (emailToFetch.isEmpty) {
          setState(() {
            _isLoading = false;
          });
          return;
        }

        await _fetchUserDataByEmail(emailToFetch);

        setState(() {
          _photoGallery = [];
          if (_userData?['profileImageUrl'] != null) {
            _photoGallery.add(_userData?['profileImageUrl']);
          }
          if (_userData?['photos'] != null && _userData!['photos'] is List) {
            _photoGallery.addAll(_userData!['photos']);
          }

          _interests = _userSettings?['interests'] ?? [];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

 Future<void> _checkFriendStatus() async {
    final userActionsProvider = Provider.of<UserActionsProvider>(context, listen: false);
    if (widget.userEmail != null) {
      await userActionsProvider.checkFriendStatus(widget.userEmail!);
      setState(() {}); 
    }
  }

  void _handleEditProfile() async {
    final userActionsProvider = Provider.of<UserActionsProvider>(context, listen: false);
    await userActionsProvider.editUserProfile(context, _userData!, _interests);
    _fetchUserData(); 
  }

  Future<void> _fetchUserDataByEmail(String email) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        DocumentSnapshot settingsDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('settings')
            .doc('preferences')
            .get();

        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>?;
          _userSettings = settingsDoc.data() as Map<String, dynamic>?;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _userData = null;
          _userSettings = null;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final userActionsProvider = Provider.of<UserActionsProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
         
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.cyan,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    // Notification Button
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications, color: Colors.cyan, size: 30),
                          onPressed: () {
                            // Notification action
                          },
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '1', // Example notification count
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6 - 30,
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _userData?['name'] ?? 'Unknown',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (_isCurrentUser)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () async {
                              await userActionsProvider.editUserProfile(context, _userData!, _interests);
                              setState(() {
                                // Refresh the user data
                                _fetchUserData();
                              });
                            },
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            _userData?['location'] ?? 'Unknown',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.location_on, color: Colors.grey),
                      ],
                    ),
                    const Divider(color: Color.fromARGB(33, 0, 0, 0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'קצת עליי :',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _userData?['description'] ?? 'No description',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const Divider(color: Color.fromARGB(33, 0, 0, 0)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            _userData?['status'] ?? 'Unknown',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.person, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'גובה: ${_userData?['height'] ?? 'Unknown'}',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.height, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'השכלה: ${_userData?['graduation'] ?? 'Unknown'}',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.school, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Color.fromARGB(33, 0, 0, 0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'תחומי עניין:',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 5.0,
                      alignment: WrapAlignment.end,
                      children: _interests.map<Widget>((interest) {
                        return Chip(
                          label: Text(
                            interest,
                            textDirection: TextDirection.rtl,
                          ),
                          backgroundColor: const Color(0xFF0CC0DF).withOpacity(0.7),
                          labelStyle: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!_isCurrentUser)
            Positioned(
              bottom: 20, // Distance from the bottom of the screen
              left: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!userActionsProvider.isFriend)
                    FloatingActionButton(
                      heroTag: 'likeButton', // Unique tag
                      onPressed: () async {
                        await userActionsProvider.likeUser(context, widget.userEmail!);
                      },
                      backgroundColor: Colors.white,
                      elevation: 10,
                      child: const Icon(Icons.thumb_up, color: Color(0xFF0CC0DF), size: 30),
                    ),
                  if (userActionsProvider.isFriend)
                    FloatingActionButton(
                      heroTag: 'friendButton', // Unique tag
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      elevation: 10,
                      child: const Icon(Icons.person, color: Color(0xFF0CC0DF), size: 30),
                    ),
                  const SizedBox(height: 10), // Spacing between buttons
                  FloatingActionButton(
                    heroTag: 'chatButton', // Unique tag
                    onPressed: () {
                      userActionsProvider.startChat(context, widget.userEmail!, _userData?['name'] ?? 'Unknown');
                    },
                    backgroundColor: Colors.white,
                    elevation: 10,
                    child: const Icon(Icons.chat, color: Color(0xFF0CC0DF), size: 30),
                  ),
                  const SizedBox(height: 10), // Spacing between buttons
                  FloatingActionButton(
                    heroTag: 'rejectButton', // Unique tag
                    onPressed: () async {
                      await userActionsProvider.rejectUser(widget.userEmail!);
                    },
                    backgroundColor: Colors.white,
                    elevation: 10,
                    child: const Icon(Icons.close, color: Color(0xFF0CC0DF), size: 30),
                  ),
                ],
              ),
            ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
