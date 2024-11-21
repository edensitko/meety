import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // ריווח פנימי
      decoration: BoxDecoration(
        color: const Color.fromARGB(64, 205, 205, 205), // צבע רקע אפור
        borderRadius: BorderRadius.circular(20), // רדיוס פינות
         border: Border.all(
      
          color:
           const Color.fromARGB(255, 171, 171, 171), width: 1),
        
      
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
          });
        },
        calendarFormat: CalendarFormat.twoWeeks, // הגדרת תצוגת שבועיים
        headerStyle: const HeaderStyle(
          formatButtonVisible: false, // הסתרת כפתור שינוי התצוגה
          titleCentered: true,
        ),
        calendarStyle: const CalendarStyle(
          markerDecoration: BoxDecoration(
                color: Color.fromRGBO(164,125,241,1),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
