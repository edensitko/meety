import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:meety/providers/userActionProvider.dart';

class PersonProfileScreen extends StatefulWidget {
  final String userEmail;

  const PersonProfileScreen({super.key, required this.userEmail});

  @override
  _PersonProfileScreenState createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends State<PersonProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  List<dynamic> _interests = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>?;
          _interests = _userData?['interests'] ?? [];
          _isLoading = false;
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
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildProfileContent(userActionsProvider),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
                  icon: const Icon(Icons.arrow_back, color:   Color.fromRGBO(67, 198, 250, 0.845),),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(UserActionsProvider userActionsProvider) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userData?['name'] ?? 'Unknown',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Location: ${_userData?['location'] ?? 'Unknown'}'),
            const SizedBox(height: 10),
            _buildDescriptionSection(),
            _buildInterestsSection(),
            _buildActionButtons(userActionsProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(_userData?['description'] ?? 'No description'),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: _interests.map<Widget>((interest) {
        return Chip(label: Text(interest));
      }).toList(),
    );
  }

  Widget _buildActionButtons(UserActionsProvider userActionsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: () {
            userActionsProvider.startChat(context, widget.userEmail, _userData?['name'] ?? 'Unknown');
          },
          child: const Icon(Icons.chat),
        ),
        FloatingActionButton(
          onPressed: () {
            userActionsProvider.likeUser(context, widget.userEmail);
          },
          child: const Icon(Icons.thumb_up),
        ),
        FloatingActionButton(
          onPressed: () {
            userActionsProvider.rejectUser(widget.userEmail);
          },
          child: const Icon(Icons.close),
        ),
      ],
    );
  }
}
