import 'package:flutter/material.dart';

class ProjectsWidget extends StatelessWidget {
  const ProjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // נתוני פרויקטים דמו
    List<Map<String, String>> projects = [
      {
        'title': 'פיתוח אפליקציית מובייל',
        'description': 'פיתוח אפליקציה לניהול פגישות',
        'status': 'הושלם',
      },
      {
        'title': 'עיצוב ממשק משתמש',
        'description': 'עיצוב אפליקציה מותאמת אישית למשתמשים',
        'status': 'בתהליך',
      },
      {
        'title': 'שיפור ביצועים',
        'description': 'אופטימיזציה של מערכת מבוססת ענן',
        'status': 'הושלם',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // רדיוס לפינות
          boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl, // מימין לשמאל
        children: [
          const Text(
            'הפרויקטים שלי',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl, // מיושם גם על הכותרת
          ),
          const SizedBox(height: 10),
          // רשימת פרויקטים
          Column(
            children: projects.map((project) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10), // רווח בין הפרויקטים
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245), // רקע לבן לפרויקט
                  borderRadius: BorderRadius.circular(15), // רדיוס לפינות הפרויקט
                  boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl, // כל פרויקט מימין לשמאל
                  children: [
                    Text(
                      project['title']!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl, // כותרת מימין לשמאל
                    ),
                    const SizedBox(height: 5),
                    Text(
                      project['description']!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      textDirection: TextDirection.rtl, // תיאור מימין לשמאל
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl, // השורה כולה מימין לשמאל
                      children: [
                        Text(
                          'סטטוס: ${project['status']!}',
                          style: TextStyle(
                              fontSize: 14,
                              color: project['status'] == 'הושלם'
                                  ? Colors.green
                                  : Colors.orange),
                        ),
                        const Icon(Icons.work,     
                        color: Color.fromRGBO(164,125,241,1),),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
