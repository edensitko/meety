import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
        _interests = _userData?['interests'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBlurredBackground(),
          _isLoading ? _buildLoading() : _buildProfileContent(),
        ],
      ),
    );
  }

  Widget _buildBlurredBackground() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(color: Colors.black.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildProfileContent() {
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
            _buildEditProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About Me:', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildEditProfileButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: () {
          // Navigate to edit profile page
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
