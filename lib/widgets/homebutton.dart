import 'package:meety/widgets/linear.dart';
import 'package:flutter/material.dart';

class ThreeButtonWidget extends StatelessWidget {
  final void Function()? onButton1Pressed;
  final void Function()? onButton2Pressed;
  final void Function()? onButton3Pressed;

  const ThreeButtonWidget({super.key, 
    required this.onButton1Pressed,
    required this.onButton2Pressed,
    required this.onButton3Pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // ריווח פנימי
      decoration: BoxDecoration(
            gradient: globalGradient, // Use the global gradient here

        borderRadius: BorderRadius.circular(20), // רדיוס פינות
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // ריווח אחיד בין הכפתורים
        children: [
          // כפתור 1 עם אייקון וטקסט ממורכזים
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showPopup(context, 'וידאו', 'כאן יוצג פופאפ עבור כפתור הוידאו.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // צבע כפתור
                shape: const CircleBorder(), // צורת כפתור עגולה
                padding: const EdgeInsets.all(5), // ריווח פנימי גדול
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam, color: Colors.white, size: 30), // אייקון מצלמה
                  SizedBox(height: 5),
                  Text('וידאו', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5), // רווח בין הכפתורים

          // כפתור 2 עם אייקון וטקסט ממורכזים
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showPopup(context, 'הוסף', 'כאן יוצג פופאפ עבור כפתור ההוספה.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // צבע כפתור
                shape: const CircleBorder(), // צורת כפתור עגולה
                padding: const EdgeInsets.all(5), // ריווח פנימי גדול
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 30), // אייקון הוספה
                  SizedBox(height: 5),
                  Text('הוסף', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5), // רווח בין הכפתורים

          // כפתור 3 עם אייקון וטקסט ממורכזים
          Expanded(
            child: ElevatedButton(
              
              onPressed: () {
                _showPopup(context, 'יומן', 'כאן יוצג פופאפ עבור כפתור היומן.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // צבע כפתור
                shape: const CircleBorder(), // צורת כפתור עגולה
                padding: const EdgeInsets.all(5), // ריווח פנימי גדול
              ),
              child: const Column(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white, size: 30), // אייקון יומן
                  SizedBox(height: 5),
                  Text('יומן', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPopup(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // סגירת הפופאפ
              },
              child: const Text('סגור'),
            ),
          ],
        );
      },
    );
  }
}
