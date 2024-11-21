import 'package:meety/providers/notificationProvider.dart';
import 'package:meety/screens/userprofile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ChangeNotifierProvider(
              create: (_) => NotificationProvider(),
              child: const NotificationModal(),
            );
          },
        );
      },
    );
  }
}

class NotificationModal extends StatelessWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    print('Building NotificationModal with ${provider.notifications.length} notifications');

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl, // Set text direction to RTL
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'התראות',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.notifications.isEmpty)
              const Center(child: Text('אין התראות חדשות'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = provider.notifications[index];
                    final visitorEmail = notification['visitorEmail'] as String?;
                    final visitorName = notification['visitorName'] as String?;
                    final visitorImage = notification['visitorImage'] as String?;
                    final timestamp = notification['timestamp'] as Timestamp?;
                    final DateTime now = DateTime.now();
                    final DateTime visitDate = timestamp != null ? timestamp.toDate() : DateTime.now();
                    final int differenceInDays = now.difference(visitDate).inDays;

                    // Format the timestamp
                    String formattedDate;
                    if (differenceInDays == 0) {
                      formattedDate = 'היום, ${intl.DateFormat('HH:mm').format(visitDate)}';
                    } else if (differenceInDays == 1) {
                      formattedDate = 'אתמול, ${intl.DateFormat('HH:mm').format(visitDate)}';
                    } else if (differenceInDays > 1 && differenceInDays <= 7) {
                      formattedDate = ' לפני $differenceInDays ימים, ${intl.DateFormat('HH:mm').format(visitDate)}';
                    } else {
                      formattedDate = intl.DateFormat('dd/MM/yyyy, HH:mm').format(visitDate);
                    }

                    print('Notification item: Visited by $visitorName, Timestamp: ${timestamp?.toDate()}');
                    print('Visitor image URL: $visitorImage');

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: visitorImage != null && visitorImage.isNotEmpty
                            ? NetworkImage(visitorImage)
                            : const AssetImage('assets/images/meety.png') as ImageProvider,
                      ),
                      title: Text('${visitorName ?? 'Unknown'} - צפה לך בפרופיל  '),
                      subtitle: Text(formattedDate),
                      trailing: const Icon(Icons.remove_red_eye_sharp, color: Colors.cyan),
                      onTap: () {
                        if (visitorEmail != null && visitorEmail.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfileScreen(userEmail: visitorEmail),
                            ),
                          );
                        } else {
                          print('Visitor email is null or empty');
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
