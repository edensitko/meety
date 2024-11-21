import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsProvider extends ChangeNotifier {
  Map<String, dynamic> _settings = {};
  bool _isLoading = true;

  Map<String, dynamic> get settings => _settings;
  bool get isLoading => _isLoading;

  SettingsProvider() {
    _fetchUserSettings();
  }

  Future<void> _fetchUserSettings() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot settingsDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('preferences')
            .get();

        if (settingsDoc.exists) {
          _settings = settingsDoc.data() as Map<String, dynamic>;
        } else {
          _settings = {
            'friendship': true,
            'date': false,
            'lookingFor': 'אישה',
            'minAge': 19,
            'maxAge': 40,
            'distance': 20,
            'interests': [],
            'sameInterests': false,
          };
        }
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user settings: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveSettings() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('preferences')
          .set(_settings);
      notifyListeners();
    }
  }

  // Update methods
  Future<void> setFriendship(bool value) async {
    _settings['friendship'] = value;
    await _saveSettings();
  }

  Future<void> setDate(bool value) async {
    _settings['date'] = value;
    await _saveSettings();
  }

  Future<void> setLookingFor(String value) async {
    _settings['lookingFor'] = value;
    await _saveSettings();
  }

  Future<void> setMinAge(int value) async {
    _settings['minAge'] = value;
    await _saveSettings();
  }

  Future<void> setMaxAge(int value) async {
    _settings['maxAge'] = value;
    await _saveSettings();
  }

  Future<void> setDistance(int value) async {
    _settings['distance'] = value;
    await _saveSettings();
  }

  Future<void> setSameInterests(bool value) async {
    _settings['sameInterests'] = value;
    await _saveSettings();
  }

  Future<void> setInterests(List<String> interests) async {
    _settings['interests'] = interests;
    await _saveSettings();
  }

  Future<void> addInterest(String interest) async {
    _settings['interests'] = _settings['interests'] ?? [];
    if (!_settings['interests'].contains(interest)) {
      _settings['interests'].add(interest);
      await _saveSettings();
    }
  }

  Future<void> removeInterest(String interest) async {
    _settings['interests'] = _settings['interests'] ?? [];
    if (_settings['interests'].contains(interest)) {
      _settings['interests'].remove(interest);
      await _saveSettings();
    }
  }

  void refreshSettings() {
    _fetchUserSettings();
  }
}
