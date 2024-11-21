// profile_card.dart
import 'package:meety/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final UserData user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // תמונת פרופיל מעוגלת
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.profileImage),
            ),
            const SizedBox(width: 20),
            // פרטי המשתמש
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('גיל: ${user.age}', style: const TextStyle(fontSize: 16)),
                  Text('מיקום: ${user.location}', style: const TextStyle(fontSize: 16)),
                  Text('סטטוס: ${user.status}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(user.description, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
