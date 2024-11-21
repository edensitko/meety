import 'package:meety/screens/chatwith.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserActionsProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _currentUser;
  bool _isFriend = false;

  UserActionsProvider() {
    _currentUser = _auth.currentUser;
  }

  bool get isFriend => _isFriend;

  Future<void> checkFriendStatus(String userEmail) async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot currentUserDoc = await _firestore.collection('users').doc(_currentUser!.uid).get();
        List<dynamic> friends = currentUserDoc['friends'] ?? [];

        _isFriend = friends.contains(userEmail);
        notifyListeners();
      } catch (e) {
        print('Error checking friend status: $e');
      }
    }
  }

  Future<void> likeUser(BuildContext context, String likedUserEmail) async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot currentUserDoc = await _firestore.collection('users').doc(_currentUser!.uid).get();

        // Update the current user's liked accounts
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'likedAccounts': FieldValue.arrayUnion([likedUserEmail]),
          'dislikedAccounts': FieldValue.arrayRemove([likedUserEmail]),
        });

        // Update the liked user's likes received
        DocumentSnapshot likedUserDoc = await _firestore.collection('users')
            .where('email', isEqualTo: likedUserEmail)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.first);
        await _firestore.collection('users').doc(likedUserDoc.id).update({
          'likesReceived': FieldValue.arrayUnion([_currentUser!.email]),
        });

        // Check for mutual like
        List<dynamic> likedUserLikedAccounts = likedUserDoc['likedAccounts'] ?? [];
        if (likedUserLikedAccounts.contains(_currentUser!.email)) {
          // If mutual like, add to friends
          await _firestore.collection('users').doc(_currentUser!.uid).update({
            'friends': FieldValue.arrayUnion([likedUserEmail]),
          });
          await _firestore.collection('users').doc(likedUserDoc.id).update({
            'friends': FieldValue.arrayUnion([_currentUser!.email]),
          });

          // Update friend status
          _isFriend = true;
          notifyListeners();

          // Optionally, show a success popup
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("It's a Match!"),
                content: Text("You and $likedUserEmail have liked each other."),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Error liking user: $e');
      }
    }
  }

  Future<void> rejectUser(String dislikedUserEmail) async {
    if (_currentUser != null) {
      try {
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'dislikedAccounts': FieldValue.arrayUnion([dislikedUserEmail]),
          'likedAccounts': FieldValue.arrayRemove([dislikedUserEmail]),
        });

        // Optionally, remove from friends if they were already friends
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'friends': FieldValue.arrayRemove([dislikedUserEmail]),
        });

        // Update friend status
        _isFriend = false;
        notifyListeners();
      } catch (e) {
        print('Error rejecting user: $e');
      }
    }
  }

  void startChat(BuildContext context, String userEmail, String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatWithScreen(
          userEmail: userEmail,
          userName: userName,
        ),
      ),
    );
  }

  Future<void> editPhotos(BuildContext context, List<dynamic> currentPhotos, Function(List<dynamic>) onPhotosUpdated) async {
    final picker = ImagePicker();

    List<dynamic> newPhotos = List.from(currentPhotos);

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final photoUrl = await uploadImage(file);

      newPhotos.add(photoUrl);

      // Update Firestore with new photo list
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'photos': newPhotos,
      });

      onPhotosUpdated(newPhotos);

      notifyListeners();
    }
  }

  Future<String> uploadImage(File file, {bool isProfileImage = false}) async {
    final ref = _storage.ref().child('user_photos').child('${_currentUser!.uid}/${DateTime.now().toIso8601String()}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> updateProfileImage(String imageUrl) async {
    if (_currentUser != null) {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'profileImageUrl': imageUrl,
      });
      notifyListeners();
    }
  }

  Future<void> updatePhotoGallery(List<dynamic> photos) async {
    if (_currentUser != null) {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'photos': photos,
      });
      notifyListeners();
    }
  }

  Future<void> editUserProfile(BuildContext context, Map<String, dynamic> userData, List<dynamic> interests) async {
    if (_currentUser == null) return;

    // Function to save updated data to Firestore
    void onSave(Map<String, dynamic> updatedUserData, List<dynamic> updatedInterests) async {
      try {
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'name': updatedUserData['name'],
          'location': updatedUserData['location'],
          'description': updatedUserData['description'],
          'status': updatedUserData['status'],
          'height': updatedUserData['height'],
          'graduation': updatedUserData['graduation'],
          'interests': updatedInterests,
        });
        // Notify listeners about the change
        notifyListeners();
      } catch (e) {
        print('Error updating user data: $e');
      }
    }

    // Call the popup function with the current data
    await showEditUserDataPopup(context, userData, interests, onSave);
  }
}

// Function to show the edit user data popup
Future<void> showEditUserDataPopup(BuildContext context, Map<String, dynamic> userData, List<dynamic> interests, Function(Map<String, dynamic>, List<dynamic>) onSave) async {
  final interestController = TextEditingController();
  Map<String, dynamic> tempUserData = Map.from(userData);
  List<dynamic> tempInterests = List.from(interests);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ערוך פרופיל',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: TextEditingController(
                    text: tempUserData['name'] ?? '',
                  ),
                  decoration: const InputDecoration(labelText: 'שם'),
                  onChanged: (value) {
                    tempUserData['name'] = value;
                  },
                ),
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: TextEditingController(
                    text: tempUserData['location'] ?? '',
                  ),
                  decoration: const InputDecoration(labelText: 'מיקום'),
                  onChanged: (value) {
                    tempUserData['location'] = value;
                  },
                ),
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: TextEditingController(
                    text: tempUserData['description'] ?? '',
                  ),
                  decoration: const InputDecoration(labelText: 'תיאור'),
                  onChanged: (value) {
                    tempUserData['description'] = value;
                  },
                ),
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: TextEditingController(
                    text: tempUserData['status'] ?? '',
                  ),
                  decoration: const InputDecoration(labelText: 'סטטוס'),
                  onChanged: (value) {
                    tempUserData['status'] = value;
                  },
                ),
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: TextEditingController(
                    text: tempUserData['height'] ?? '',
                  ),
                  decoration: const InputDecoration(labelText: 'גובה'),
                  onChanged: (value) {
                    tempUserData['height'] = value;
                  },
                ),
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: TextEditingController(
                    text: tempUserData['graduation'] ?? '',
                  ),
                  decoration: const InputDecoration(labelText: 'השכלה'),
                  onChanged: (value) {
                    tempUserData['graduation'] = value;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'תחומי עניין',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 5.0,
                  alignment: WrapAlignment.end,
                  children: tempInterests.map<Widget>((interest) {
                    return Chip(
                      label: Text(
                        interest,
                        textDirection: TextDirection.rtl,
                      ),
                      backgroundColor: const Color(0xFF0CC0DF).withOpacity(0.7),
                      labelStyle: const TextStyle(color: Colors.white),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          tempInterests.remove(interest);
                        });
                      },
                    );
                  }).toList(),
                ),
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: interestController,
                  decoration: InputDecoration(
                    labelText: 'הוסף עניין',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          if (interestController.text.isNotEmpty) {
                            tempInterests.add(interestController.text);
                            interestController.clear();
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSave(tempUserData, tempInterests);
                  },
                  child: const Text('שמור שינויים'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
