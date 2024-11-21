import 'package:flutter/material.dart';

class CareerAdviceWidget extends StatelessWidget {
  const CareerAdviceWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(64, 97, 95, 95), // צבע רקע אפור עם רדיוס
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl, // מיושם מימין לשמאל
        children: [
          Text(
            'המלצות לקריירה',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl, // כותרת מימין לשמאל
          ),
          SizedBox(height: 8),
          Text(
            'בהתבסס על הפרופיל שלך, הנה כמה דברים להתמקד בהם:',
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 8),
          Text(
            '- לשפר את המיומנויות שלך בתחום הניהול',
            style: TextStyle(fontSize: 16),
            textDirection: TextDirection.rtl,
          ),
          Text(
            '- להתחבר עם יותר אנשי מקצוע בתחום הטכנולוגיה',
            style: TextStyle(fontSize: 16),
            textDirection: TextDirection.rtl,
          ),
          Text(
            '- לשקול לקחת קורס בהובלת צוותים',
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
