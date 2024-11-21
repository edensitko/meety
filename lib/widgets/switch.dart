import 'package:meety/widgets/linear.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Widget that allows switching between different content widgets
class SwitchableWidget extends StatefulWidget {
  const SwitchableWidget({super.key});

  @override
  _SwitchableWidgetState createState() => _SwitchableWidgetState();
}

class _SwitchableWidgetState extends State<SwitchableWidget> {
  int _currentIndex = 0; // Index to track which widget to display

  // List of widgets to switch between
  final List<Widget> _widgets = [
    const CalendarWidget(), 
    // Display CalendarWidget for Widget 1
    const ScheduledMeetingsWidget(), // Display ScheduledMeetingsWidget for Widget 2
    Container(
      
      child:const CalendarWidget(),
    ),
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
          onButton1Pressed: () => _setCurrentIndex(0), // Show Widget 1 (Calendar)
          onButton2Pressed: () => _setCurrentIndex(1), // Show Widget 2 (Scheduled Meetings)
          onButton3Pressed: () => _setCurrentIndex(2), // Show Widget 3 (Additional Widget)
        ),
        SizedBox(
          width: 500,
          height: 260,
          child: 
                
          _widgets[_currentIndex], 


        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Widget for three buttons with icons
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
      
      padding: const EdgeInsets.all(16), // Internal padding
      decoration: BoxDecoration(
    gradient: globalGradient, // Use the global gradient here
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between buttons
        children: [
          // Button 1
          Expanded(
            child: ElevatedButton(
              onPressed: onButton1Pressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: const RoundedRectangleBorder(), // Rectangular button shape
                padding: const EdgeInsets.all(10), // Internal padding
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, color: Color.fromARGB(255, 255, 255, 255), size: 30), // Calendar icon
                  SizedBox(height: 5),
                  Text('Show Calendar', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5), // Space between buttons

          // Button 2
          Expanded(
            child: ElevatedButton(
              onPressed: onButton2Pressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                shape: const RoundedRectangleBorder(), // Rectangular button shape
                padding: const EdgeInsets.all(10), // Internal padding
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.meeting_room, color: Colors.white, size: 30), // Meeting icon
                  SizedBox(height: 5),
                  Text('Show Meetings', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5), // Space between buttons

          // Button 3
          Expanded(
            child: ElevatedButton(
              onPressed: onButton3Pressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
                shape: const RoundedRectangleBorder(), // Rectangular button shape
                padding: const EdgeInsets.all(10), // Internal padding
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 30), // Add icon
                  SizedBox(height: 5),
                  Text('Add Meeting', style: TextStyle(color: Colors.white)),
                ],
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
      child: const CalendarWidget()
      );
    
  }
}

// Widget to display scheduled meetings
class ScheduledMeetingsWidget extends StatelessWidget {
  const ScheduledMeetingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ScheduleMeetingButton(), // Button to schedule a new meeting
        Expanded(
            child:
           MeetingList(), // Display the list of scheduled meetings
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
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const MeetingEventDialog(), // Open dialog to schedule meeting
        );
      },
      child: const Text(' פגישה חדשה   '),
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

// Widget to display scheduled meetings in card format
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
            return Card(
              elevation: 4, // Shadow effect for card
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Spacing around the card
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'תאריך: ${DateTime.parse(meeting['date']).toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'שעה: ${meeting['time']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}