import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meety/widgets/meetingDetails.dart';
import 'package:meety/widgets/navbar.dart';
import 'package:meety/widgets/notifications.dart';
import 'package:meety/widgets/sideMenu.dart';
import 'package:table_calendar/table_calendar.dart';

class Meeting {
  final String id;
  final String title;
  final DateTime date;
  final String location;

  Meeting({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
  });

  factory Meeting.fromFirestore(String id, Map<String, dynamic> data) {
    final meetingDate = (data['date'] as Timestamp).toDate();
    return Meeting(
      id: id,
      title: data['title'] ?? 'No Title',
      date: meetingDate,
      location: data['location'] ?? 'No Location',
    );
  }
}

class MeetingsCalendarScreen extends StatefulWidget {
  const MeetingsCalendarScreen({super.key});

  @override
  _MeetingsCalendarScreenState createState() => _MeetingsCalendarScreenState();
}

class _MeetingsCalendarScreenState extends State<MeetingsCalendarScreen> {
  Map<DateTime, List<Meeting>> meetingsByDate = {};
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';
  bool isShowingAllMeetings = true;

  @override
  void initState() {
    super.initState();
    _fetchMeetings();
  }

  Future<void> _fetchMeetings() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('meetings').get();
      List<Meeting> meetings = snapshot.docs.map((doc) {
        return Meeting.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      setState(() {
        meetingsByDate = {};
        for (var meeting in meetings) {
          DateTime meetingDate = DateTime(meeting.date.year, meeting.date.month, meeting.date.day);
          meetingsByDate.putIfAbsent(meetingDate, () => []);
          meetingsByDate[meetingDate]!.add(meeting);
        }
      });
    } catch (e) {
      print('Error fetching meetings: $e');
    }
  }

  List<Meeting> _getMeetingsForSelectedDay() {
    if (isShowingAllMeetings) {
      return meetingsByDate.values.expand((i) => i).toList(); // Return all meetings if "All Meetings" is selected
    }
    final normalizedSelectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    return meetingsByDate[normalizedSelectedDay] ?? []; // Return meetings for selected day
  }

  void _clearSearch() {
    setState(() {
      searchQuery = ''; // Clear search text
    });
  }

  void _clearSelectedDay() {
    setState(() {
      selectedDay = DateTime.now(); // Reset to today to show all meetings
      isShowingAllMeetings = true; // Show all meetings
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: const Color.fromARGB(255, 75, 75, 75),
            iconSize: 28,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const NotificationModal();
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(currentRouteIndex: 2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCompactCalendar(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isShowingAllMeetings = true; // Show all meetings
                    });
                  },
                  child: Text(
                    'כל הפגישות',
                    style: TextStyle(fontSize: isShowingAllMeetings ? 18 : 14),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: isShowingAllMeetings ? const Color.fromARGB(255, 116, 188, 248) : Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isShowingAllMeetings = false; // Show meetings for selected day
                    });
                  },
                  child: Text(
                    'פגישות בתאריך ${_formatDate(selectedDay)}',
                    style: TextStyle(fontSize: !isShowingAllMeetings ? 18 : 14),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: !isShowingAllMeetings ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 10),
            Expanded(child: _buildTimelineMeetingList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCalendar() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 1, offset: const Offset(0, 4)),
        ],
      ),
      child: TableCalendar(
        focusedDay: focusedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
            isShowingAllMeetings = false;
          });
        },
        calendarFormat: CalendarFormat.week,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.black),
          weekendStyle: TextStyle(color: Colors.black),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(50),
          ),
          todayDecoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(50),
          ),
          defaultDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(252, 248, 246, 246),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'חפש...',
                hintStyle: const TextStyle(color: Color.fromARGB(255, 25, 23, 23), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 34, 32, 32), size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none, // Remove the default border
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5), // Adjust padding to make the height less
                filled: true, // Fill the container with color
                fillColor: const Color.fromARGB(0, 170, 164, 164), // Make background color transparent
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: _clearSearch,
        ),
      ],
    );
  }

  Widget _buildTimelineMeetingList() {
    final meetings = _getMeetingsForSelectedDay().where((meeting) {
      return meeting.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (meetings.isEmpty) {
      return const Center(child: Text('לא נמצאו פגישות.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)));
    }

    meetings.sort((a, b) => a.date.compareTo(b.date)); // Sort meetings by date ascending

    return ListView.builder(
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        final meetingTime = intl.DateFormat('HH:mm').format(meeting.date);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return MeetingDetailsContent(meetingId: meeting.id);
                },
              );
            },
            child:Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: 160, // Adjusted height for more space
        decoration: BoxDecoration(
          image: DecorationImage(
                    image: AssetImage('assets/images/fgree.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                const Color.fromARGB(255, 62, 80, 62).withOpacity(0.5), BlendMode.darken),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            textDirection: TextDirection.rtl, // Right-to-left layout
            children: [
              // Meeting Title, Description, and Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Title of the meeting
                    Text(
                      meeting.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 5),
                    // Meeting Description
                    Text(
                      meeting.location,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                      textAlign: TextAlign.right,
                    ),
                    const Spacer(),
                    // Meeting time and avatars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Meeting Time
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              meetingTime,
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        // Avatars of people in the meeting
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage('https://source.unsplash.com/1600x900/?person'),
                            ),
                            const SizedBox(width: 5),
                            CircleAvatar(
                              backgroundImage: NetworkImage('https://source.unsplash.com/1600x900/?people'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

          ),  
        ),  
      ),
    ),
          ),
        );
      },
    );
  }

   
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
