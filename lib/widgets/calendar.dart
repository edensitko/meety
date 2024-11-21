import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Meeting {
  final String title;
  final DateTime date;
  final String location;

  Meeting({required this.title, required this.date, required this.location});
}

class MeetingsCalendarWidget extends StatefulWidget {
  final List<Meeting> meetings; // רשימת הפגישות

  const MeetingsCalendarWidget({super.key, required this.meetings});

  @override
  _MeetingsCalendarWidgetState createState() => _MeetingsCalendarWidgetState();
}

class _MeetingsCalendarWidgetState extends State<MeetingsCalendarWidget> {
  Map<DateTime, List<Meeting>> meetingsByDate = {}; // הפגישות מחולקות לפי תאריכים
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // סידור הפגישות לפי תאריכים
    for (var meeting in widget.meetings) {
      DateTime meetingDate = DateTime(meeting.date.year, meeting.date.month, meeting.date.day);
      if (meetingsByDate[meetingDate] == null) {
        meetingsByDate[meetingDate] = [];
      }
      meetingsByDate[meetingDate]!.add(meeting);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('לוח השנה שלך', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 10),
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              eventLoader: (day) => meetingsByDate[day] ?? [],
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });

                // הצגת הפגישות של היום הנבחר בפופאפ
                _showMeetingsForDay(selectedDay);
              },
              calendarStyle: const CalendarStyle(
                markerDecoration: BoxDecoration(       
                           color: Color.fromRGBO(119, 119, 121, 1),
shape: BoxShape.circle),
              ),
              availableCalendarFormats: const {
                CalendarFormat.twoWeeks: 'שבועיים',
              },
              calendarFormat: CalendarFormat.twoWeeks, // הצגת שבועיים בלבד
            ),
          ],
        ),
      ),
    );
  }

  // פונקציה להצגת הפגישות של יום מסוים בפופאפ
  void _showMeetingsForDay(DateTime day) {
    final meetingsForDay = meetingsByDate[DateTime(day.year, day.month, day.day)] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('פגישות ל-${formatDate(day)}'),
        content: meetingsForDay.isEmpty
            ? const Text('אין פגישות ביום זה.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: meetingsForDay.map((meeting) {
                  return ListTile(
                    title: Text(meeting.title),
                    subtitle: Text(
                      '${meeting.location} \nשעה: ${formatTime(meeting.date)}',
                    ),
                  );
                }).toList(),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('סגור'),
          ),
        ],
      ),
    );
  }

  // פונקציה לעיצוב התאריך
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // פונקציה לעיצוב השעה
  String formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
