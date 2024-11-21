import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UserData {
  final String name;
  final int age;
  final String imageUrl;
  final String email;
  final String gender;
  final String lookingFor;
  final String phone;
  final String location;
  final List<String> photos;
  final List<String> friends;
  final bool isOnline;
  final String profession;
  final String status;
  final String description;
  final String profileImage;
  final int balance;

  UserData({
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.email,
    required this.gender,
    required this.lookingFor,
    required this.phone,
    required this.location,
    required this.photos,
    required this.friends,
    required this.isOnline,
    required this.profession,
    required this.status,
    required this.description,
    required this.profileImage,
    required this.balance,
  });

  // Create UserData object from Firestore document
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      name: data['name'] ?? '',
      age: int.tryParse(data['age'].toString()) ?? 0,
      imageUrl: data['profileImageUrl'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'] ?? '',
      lookingFor: data['lookingFor'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      photos: data['photos'] != null ? List<String>.from(data['photos']) : [],
      friends: data['friends'] != null ? List<String>.from(data['friends']) : [],
      isOnline: data['isOnline'] ?? false,
      profession: data['profession'] ?? '',
      status: data['status'] ?? '',
      description: data['description'] ?? '',
      profileImage: data['profileImage'] ?? '',
      balance: data['balance'] ?? 0,
    );
  }
}

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isLoading = true;
  UserData? _currentUserData;


 AuthProvider() {

    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      _isLoading = false;
      if (_user != null) {
        
        await fetchCurrentUser(); // Ensure this method is defined
        print('User is signed in: ${_user!.email}');
      } else {
        print('User is signed out');
      }
      notifyListeners();
    });
  }

   User? get user => _user;
  bool get isLoading => _isLoading;
  UserData? get currentUserData => _currentUserData;

  Future<void> fetchCurrentUser() async {
    if (_user != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(_user!.uid).get();
        if (doc.exists) {
          _currentUserData = UserData.fromFirestore(doc);
          print('Fetched current user data: ${_currentUserData!.email}');
          printCurrentUserData();
          await _saveEmailToPreferences(_currentUserData!.email);
        } else {
          print('User document does not exist in Firestore.');
          _currentUserData = null;
        }
      } catch (e) {
        print('Error fetching current user data: $e');
      }
      notifyListeners();
    }
  }

  Future<void> _fetchUserDataByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        _currentUserData = UserData.fromFirestore(snapshot.docs[0]);
        print('Fetched current user data: ${_currentUserData!.email}');
      } else {
        print('No user found with the email: $email');
        _currentUserData = null; // Reset if no user found
      }
    } catch (e) {
      print('Error fetching user data for email $email: $e');
    }
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name, int age, String gender, String lookingFor, String phone, File image) async {
    _setLoading(true);
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Check if the image is valid
      String imageUrl = await _uploadImage(image);

      await _firestore.collection('users').doc(_user!.uid).set({
        'name': name,
        'age': age,
        'profileImage': imageUrl, // Save the URL to Firestore
        'email': email,
        'gender': gender,
        'lookingFor': lookingFor,
        'phone': phone,
        'location': '',
        'photos': [],
        'friends': [],
        'isOnline': true,
        'profession': '',
        'status': '',
        'description': '',
        'balance': 0.0, // Initialize balance
      });
    
      await fetchCurrentUser(); // Call _initializeUserData after sign up
      notifyListeners();
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('user_images').child('${_user!.uid}.jpg');
      UploadTask uploadTask = ref.putFile(image);
      
      // Monitor the upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL after upload
      String downloadUrl = await ref.getDownloadURL();
      print('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow; // Re-throw the error for further handling if needed
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Fetch current user data
      await fetchCurrentUser(); // Fetch current user data after login

      // Print user's email after login
      print('User signed in: ${_currentUserData!.email}');
      
      // Save email to shared preferences
      await _saveEmailToPreferences(_currentUserData!.email);

      // Optionally, perform any actions based on user's email
      await performActionBasedOnEmail(_currentUserData!.email);
      
      notifyListeners();
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  // Method to perform actions based on user's email
  Future<void> performActionBasedOnEmail(String email) async {
    // Example request or action based on the email
    // This could be an API request or database query
    print('Performing action based on email: $email');
    
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(email).get();
      if (userDoc.exists) {
        // Process the user document data
        print('User data for $email: ${userDoc.data()}');
      } else {
        print('No user found for the email: $email');
      }
    } catch (e) {
      print('Error fetching data for email $email: $e');
    }
  }

  Future<void> _saveEmailToPreferences(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _currentUserData = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
 void printCurrentUserData() {
    if (_currentUserData != null) {
      print('Current User Data:');
      print('Name: ${_currentUserData!.name}');
      print('Age: ${_currentUserData!.age}');
      print('Email: ${_currentUserData!.email}');
      print('Gender: ${_currentUserData!.gender}');
      print('Looking For: ${_currentUserData!.lookingFor}');
      print('Phone: ${_currentUserData!.phone}');
      print('Location: ${_currentUserData!.location}');
      print('Photos: ${_currentUserData!.photos}');
      print('Friends: ${_currentUserData!.friends}');
      print('Is Online: ${_currentUserData!.isOnline}');
      print('Profession: ${_currentUserData!.profession}');
      print('Status: ${_currentUserData!.status}');
      print('Description: ${_currentUserData!.description}');
      print('Profile Image: ${_currentUserData!.profileImage}');
      print('Balance: ${_currentUserData!.balance}');
    } else {
      print('No current user data available.');
    }
  }

  Future<bool> isUserLoggedIn() async {
    _user = _auth.currentUser;
    return _user != null;
  }
} 