import 'package:flutter/material.dart';

class StatisticsWidget extends StatelessWidget {
  final int meetings;
  final int posts;
  final int followers;
  final int completedMeetings;

  const StatisticsWidget({super.key, 
    required this.meetings,
    required this.posts,
    required this.followers,
    required this.completedMeetings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // ריווח פנימי
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // רדיוס הפינות
      boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatButton(context, Icons.event, 'פגישות עתידיות', meetings),
          _buildStatButton(context, Icons.post_add, 'פוסטים', posts),
          _buildStatButton(context, Icons.group, 'עוקבים', followers),
          _buildStatButton(context, Icons.check_circle, 'פגישות שבוצעו', completedMeetings),
        ],
      ),
    );
  }

  Widget _buildStatButton(BuildContext context, IconData icon, String label, int value) {
  return InkWell(
    onTap: () {
      _showPopup(context, label, value); // Action when the button is tapped
    },
    borderRadius: BorderRadius.circular(15), // Rounded corners for the button
    child: Container(
      padding: const EdgeInsets.all(4), // Internal padding for the button
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Rounded corners
       
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [ Color.fromRGBO(67, 198, 250, 0.899),
                      Color.fromARGB(247, 122, 213, 139),], // Gradient colors
              ).createShader(bounds);
            },
            child: Icon(icon, size: 26, color: Colors.white),
          ),
          const SizedBox(height: 8), // Space between the icon and text
          Text(
            value.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, foreground: Paint()..shader = const LinearGradient( // Gradient text color
              colors: [   Color.fromRGBO(10, 10, 10, 0.898),
                       Color.fromRGBO(2, 2, 2, 0.898),], // Gradient colors
            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
          ),
          // padding for the label
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey), // Label text color
          ),
        ],
      ),
    ),
  );
}

  // פונקציה להצגת פופאפ
  void _showPopup(BuildContext context, String label, int value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('פרטים על $label'),
          content: Text('הערך הנוכחי של $label הוא $value.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('סגור'),
            ),
          ],
        );
      },
    );
  }
}
