import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;

class EditMeetingScreen extends StatefulWidget {
  final String meetingId;

  const EditMeetingScreen({super.key, required this.meetingId});

  @override
  _EditMeetingScreenState createState() => _EditMeetingScreenState();
}

class _EditMeetingScreenState extends State<EditMeetingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _notifyBeforeController = TextEditingController();
  final TextEditingController _platformController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<String> _guests = [];

  @override
  void initState() {
    super.initState();
    _fetchMeetingDetails();
  }

  Future<void> _fetchMeetingDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('meetings')
          .doc(widget.meetingId)
          .get();

      if (snapshot.exists) {
        final meetingData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _titleController.text = meetingData['title'] ?? '';
          _selectedDate = (meetingData['date'] as Timestamp?)?.toDate();
          _selectedTime = _selectedDate != null
              ? TimeOfDay.fromDateTime(_selectedDate!)
              : null;
          _hostController.text = meetingData['host'] ?? '';
          _notifyBeforeController.text = meetingData['notifyBefore'] ?? '';
          _platformController.text = meetingData['platform'] ?? '';
          _guests = List<String>.from(meetingData['guests'] ?? []);
        });
      }
    } catch (e) {
      print("Error fetching meeting details: $e");
    }
  }

  Future<void> _saveMeeting() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }
    DateTime fullDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    await FirebaseFirestore.instance
        .collection('meetings')
        .doc(widget.meetingId)
        .update({
      'title': _titleController.text,
      'date': Timestamp.fromDate(fullDateTime),
      'host': _hostController.text,
      'notifyBefore': _notifyBeforeController.text,
      'platform': _platformController.text,
      'guests': _guests,
    });

    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'ערוך פגישה',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'כותרת הפגישה'),
              controller: _titleController,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'מנחה'),
              controller: _hostController,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'הודעה לפני'),
              controller: _notifyBeforeController,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'פלטפורמת פגישה'),
              controller: _platformController,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text(_selectedDate == null
                      ? 'בחר תאריך'
                      : intl.DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                ),
                ElevatedButton(
                  onPressed: _pickTime,
                  child: Text(_selectedTime == null
                      ? 'בחר שעה'
                      : _selectedTime!.format(context)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveMeeting,
              child: const Text('שמור שינויים'),
            ),
          ],
        ),
      ),
    );
  }
}

void showEditMeetingBottomSheet(BuildContext context, String meetingId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.75,
        child: EditMeetingScreen(meetingId: meetingId),
      );
    },
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );
}
