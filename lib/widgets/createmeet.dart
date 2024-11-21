import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:toggle_switch/toggle_switch.dart';

class CreateMeetingWidget extends StatefulWidget {
  const CreateMeetingWidget({super.key});

  @override
  _CreateMeetingWidgetState createState() => _CreateMeetingWidgetState();
}

class _CreateMeetingWidgetState extends State<CreateMeetingWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isPaidMeeting = false; // Toggle for paid meetings
  double _paymentAmount = 0.0; // Amount for paid meetings

  // Gradient colors
  final Color buttonTextColor = Colors.white;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _createMeeting() async {
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

    // Save meeting data to Firestore
    try {
      await FirebaseFirestore.instance.collection('meetings').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': Timestamp.fromDate(fullDateTime),
        'isPaid': _isPaidMeeting,
        'paymentAmount': _paymentAmount,
      });

      // Clear fields after saving
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });

      Navigator.of(context).pop(); // Close the bottom sheet after creation
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating meeting: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'צור פגישה חדשה',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Handle settings action here
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'שם החדר',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'הוסף תיאור',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(95, 138, 248, 158),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'בחר תאריך'
                          : intl.DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: TextStyle(color: buttonTextColor, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickTime,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(95, 138, 248, 158),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _selectedTime == null
                          ? 'בחר שעה'
                          : _selectedTime!.format(context),
                      style: TextStyle(color: buttonTextColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Payment Settings Section (First Container)
              GestureDetector(
                onTap: () => _showPaymentDialog(),
                child: Container(
                  height: 150,
                  width: 150,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(height: 8),
                      Text('הגדרת תשלום', style: TextStyle(fontSize: 14)),
                      Text(
                        _isPaidMeeting ? 'תשלום: $_paymentAmount' : 'פגישה ללא תשלום',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                onPressed: _createMeeting, // Trigger createMeeting function
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(67, 198, 250, 0.808),
                        Color.fromARGB(222, 138, 248, 158),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'המשך',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          size: 24,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Users Section: Add User Avatars in Horizontal Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    GestureDetector(
                      onTap: () => _showSettingDialog('Add User'),
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                    // User avatars (Example)
                    for (int i = 0; i < 5; i++)
                      GestureDetector(
                        onTap: () => _showSettingDialog('User $i'),
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            child: const Icon(Icons.person),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the payment settings dialog
  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('הגדרת תשלום לפגישה'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleSwitch(
              customWidths: [90.0, 50.0],
              cornerRadius: 20.0,
              activeBgColors: [[Colors.cyan], [Colors.redAccent]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: ['YES', ''],
              icons: [Icons.lock, Icons.lock_open],
              onToggle: (index) {
                setState(() {
                  _isPaidMeeting = index == 0;
                  _paymentAmount = index == 0 ? 100.0 : 0.0; // Example amount
                });
              },
            ),
            const SizedBox(height: 10),
            if (_isPaidMeeting)
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'הכנס סכום',
                ),
                onChanged: (value) {
                  setState(() {
                    _paymentAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("סגור"),
          ),
        ],
      ),
    );
  }

  // Function for showing setting dialog (e.g., Add user or other settings)
  void _showSettingDialog(String settingName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(settingName),
        content: Text("Details about $settingName will be displayed here."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
