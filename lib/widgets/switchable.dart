import 'package:meety/widgets/adduttonsWidget.dart';
import 'package:meety/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meety/widgets/createmeet.dart';
import 'package:meety/widgets/meetingDetails.dart';
import 'package:table_calendar/table_calendar.dart';
// Widget that allows switching between different content widgets


// Widget that allows switching between different content widgets
class SwitchableWidget extends StatefulWidget {
  const SwitchableWidget({super.key});

  @override
  _SwitchableWidgetState createState() => _SwitchableWidgetState();
}

class _SwitchableWidgetState extends State<SwitchableWidget> {
  int _currentIndex = 0; // Index to track which widget to display

// List of widgets to switch between
List<Widget> _widgets(BuildContext context) => [
  const CalendarWidget(), // Display CalendarWidget for Widget 1
  const ScheduledMeetingsWidget(), // Display ScheduledMeetingsWidget for Widget 2
  GradientButtonGrid(onPressed: () {
    // show the bottom sheet with create new meeting form
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CreateMeetingWidget();
      },
    );
  }, text: 'הוסף פגישה'),
];

  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index; // Set the index to the selected button
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
    
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThreeButtonWidget(
          currentIndex: _currentIndex,
          onButton1Pressed: () => _setCurrentIndex(0), // Show Widget 1 (Calendar)
          onButton2Pressed: () => _setCurrentIndex(1), // Show Widget 2 (Scheduled Meetings)
          onButton3Pressed: () => _setCurrentIndex(2), // Show Widget 3 (Projects)
        ),
        SizedBox(
          width: 500,
          height: 235,
          child: _widgets(context)[_currentIndex],
             
              
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Widget for three buttons with circular shapes and active indicators
class ThreeButtonWidget extends StatelessWidget {
  final int currentIndex; // Current active index
  final void Function()? onButton1Pressed;
  final void Function()? onButton2Pressed;
  final void Function()? onButton3Pressed;

  const ThreeButtonWidget({super.key, 
    required this.currentIndex,
    required this.onButton1Pressed,
    required this.onButton2Pressed,
    required this.onButton3Pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // Internal padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), 
        // Rounded corners
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between buttons
        children: [
          // Button 1
          Expanded(
            child: GestureDetector(
              onTap: onButton3Pressed,
              child: _buildCircularButton(
                icon: Icons.add,
                label: ' הוסף',
                isActive: currentIndex == 2,
              ),
            ),
          ),
          const SizedBox(width: 5), // Space between buttons

          // Button 2
          Expanded(
            child: GestureDetector(
              onTap: onButton2Pressed,
              child: _buildCircularButton(
                icon: Icons.meeting_room,
                label: ' פגישות',
                isActive: currentIndex == 1,
              ),
            ),
          ),
          const SizedBox(width: 5), // Space between buttons
 Expanded(
  
            child: GestureDetector(
              onTap: onButton1Pressed,
              child: _buildCircularButton(
                
                icon: Icons.calendar_today,
                label: ' יומן',
                isActive: currentIndex == 0,
              ),
            ),
          ),
          // Button 3
         
        ],
      ),
    );
  }
Widget _buildCircularButton({required IconData icon, required String label, required bool isActive}) {
  return Container(
   
    padding: const EdgeInsets.all(10), // Internal padding
    decoration: BoxDecoration(
      color: Colors.white, // White background
      shape: BoxShape.circle,
      // border: Border.all(color: const Color.fromARGB(255, 188, 244, 212), width: 1 ),
      boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
   //   boxShadow: isActive ? [BoxShadow( color: const Color.fromARGB(255, 104, 156, 96).withOpacity(0.4), blurRadius: 5, offset: const Offset(0, 0))] : [],
    ),
    width: isActive ? 85 : null,
    height: isActive ? 72 : null,
    // border box 
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon with gradient color
        ShaderMask(
          
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Color.fromRGBO(67, 198, 250, 0.718),
                      Color.fromARGB(255, 141, 250, 161),], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          
          child: Icon(
            icon,
            color: Colors.white, // Set to white for the gradient to show
            size: isActive ? 28 : 25,
            
          ),
        ),
        // Text with gradient color
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [ Color.fromARGB(255, 179, 179, 179),
                        Color.fromARGB(255, 179, 179, 179),], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            label,
            style:  TextStyle(color: Colors.white,
         fontSize: isActive ? 14 : 12,
            ),
          ),
        ),
      ],
    ),
  );
}
}

// Calendar widget implementation
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
      color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Rounded corners
           boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 1, offset: const Offset(0, 4)),
      ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        onDaySelected: (selectedDay, focusedDay) {
          // Handle day selection
        },
        calendarFormat: CalendarFormat.twoWeeks,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
          daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Color.fromARGB(255, 11, 12, 11)),
        weekendStyle: TextStyle(color: Color.fromARGB(255, 9, 9, 9)),
          ),
        calendarStyle: CalendarStyle(
        defaultTextStyle:  TextStyle(color: Colors.black), 
        todayTextStyle: TextStyle(color: Colors.black),
        selectedDecoration: BoxDecoration(
          color: Colors.black,
          // gradient for selected date
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(113, 67, 198, 250),
              Color.fromARGB(123, 138, 248, 158),
            ],
            
          ),
      
          borderRadius: BorderRadius.circular(50), // Keep borderRadius for selected date
        ),
        todayDecoration: BoxDecoration(
       gradient: const LinearGradient(
            colors: [
              Color.fromARGB(46, 67, 198, 250),
              Color.fromARGB(51, 138, 248, 158),
            ],
            
          ),
          borderRadius: BorderRadius.circular(50), // Use borderRadius for rounded corners
          
        ),
        defaultDecoration: BoxDecoration(
          color: Colors.white, // Ensure this is a rectangle
          borderRadius: BorderRadius.circular(50), // Use borderRadius for rounded corners
        ),
      ),
      ),
    );  
  }
}

// Widget to display scheduled meetings
class ScheduledMeetingsWidget extends StatelessWidget {
  const ScheduledMeetingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
     //centered title

        Center(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [ Color.fromARGB(255, 138, 248, 158),
                          Color.fromARGB(253, 164, 125, 241),], // Gradient colors
              ).createShader(bounds);
            },
            child: Text(
              'פגישות מתוזמנות',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                foreground: Paint()..shader = const LinearGradient(
                  colors: [ Color.fromARGB(255, 138, 248, 158),
                          Color.fromARGB(253, 164, 125, 241),],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
              ),
            ),
          ),
        ),
        const Expanded(
          child: MeetingList(), // Display the list of scheduled meetings
        ),
      ],
    );
  }
}

// Button for scheduling new meetings
class ScheduleMeetingButton extends StatelessWidget {
  const ScheduleMeetingButton({super.key});

  @override

  
  Widget build(BuildContext context) {
    return  GradientOutlineButton(
          label: ' הוסף פגישה',
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // this must be true to change height dynamically
              builder: (BuildContext context) {
                return const FractionallySizedBox(
                  heightFactor: 0.75, // Adjust this value to change the height of the bottom sheet
                  child: MeetingEventDialog(),
                );
              },
              
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)
                
                
                ),
                
              ),
            );
          },
        );
  }
}





// Meeting event dialog for scheduling meetings
class MeetingEventDialog extends StatefulWidget {
  const MeetingEventDialog({super.key});

  @override
  _MeetingEventDialogState createState() => _MeetingEventDialogState();
}

class _MeetingEventDialogState extends State<MeetingEventDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _saveMeeting() async {
    if (_formKey.currentState!.validate()) {
      // Creating a new meeting document in Firestore
      await FirebaseFirestore.instance.collection('meetings').add({
        'title': _title,
        'date': _selectedDate.toIso8601String(),
        'time': _selectedTime.format(context),
        'createdAt': FieldValue.serverTimestamp(), // Optional: timestamp of creation
      });

      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Schedule a Meeting'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Meeting Title'),
              validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              onChanged: (value) => _title = value,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                setState(() {
                  _selectedDate = pickedDate!;
                });
                            },
              child: Text('Select Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              child: Text('Select Time: ${_selectedTime.format(context)}'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveMeeting,
          child: const Text('Save Meeting'),
        ),
      ],
    );
  }
}
class MeetingList extends StatelessWidget {
  const MeetingList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('meetings').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final meetings = snapshot.data!.docs;

        return ListView.builder(
          itemCount: meetings.length,
          itemBuilder: (context, index) {
            final meeting = meetings[index];

            // Safely access fields with null checks
            final meetingTitle = meeting['title'] ?? 'No Title';
            final meetingDate = (meeting['date'] as Timestamp).toDate();
            final meetingTime = meeting['date'] ?? 'Time not available'; // Check if 'time' field exists

            return GestureDetector(
             // open the meeting details bottom sheet
              onTap: () {
            showModalBottomSheet(
  context: context,
  isScrollControlled: true, // this must be true to change height dynamically
  builder: (BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9, // Adjust this value to change the height of the bottom sheet
      child: MeetingDetailsContent(meetingId: meeting.id),
    );
  },
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
);

              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildGradientText(meetingTitle, fontSize: 18),
                      const SizedBox(height: 8),
                      _buildGradientText(
                        'תאריך: ${meetingDate.toLocal().toString().split(' ')[0]}',
                        fontSize: 16,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'שעה: $meetingTime',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper function to build gradient text
  Widget _buildGradientText(String text, {double fontSize = 16}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [ Color.fromARGB(255, 138, 248, 158),
                          Color.fromARGB(253, 164, 125, 241),],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [ Color.fromARGB(255, 138, 248, 158),
                          Color.fromARGB(253, 164, 125, 241),],
            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
        ),
      ),
    );
  }
}
