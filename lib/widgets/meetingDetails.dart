import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meety/screens/videoCallScreen.dart';

class MeetingDetailsContent extends StatefulWidget {
  final String meetingId;

  const MeetingDetailsContent({super.key, required this.meetingId});

  @override
  _MeetingDetailsContentState createState() => _MeetingDetailsContentState();
}

class _MeetingDetailsContentState extends State<MeetingDetailsContent> {
  late Future<Map<String, dynamic>?> meetingDetails;

  @override
  void initState() {
    super.initState();
    meetingDetails = _fetchMeetingDetails();
  }

  Future<Map<String, dynamic>?> _fetchMeetingDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('meetings')
          .doc(widget.meetingId)
          .get();
      return snapshot.exists ? snapshot.data() as Map<String, dynamic>? : null;
    } catch (e) {
      print("Error fetching meeting details: $e");
      return null;
    }
  }

  Future<void> _joinMeeting() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference meetingRef = firestore.collection('meetings').doc(widget.meetingId);

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return firestore.runTransaction((transaction) async {
      DocumentSnapshot meetingSnapshot = await transaction.get(meetingRef);

      if (!meetingSnapshot.exists) {
        throw Exception("Meeting does not exist!");
      }

      List<dynamic> participants = meetingSnapshot['participants'] ?? [];
      if (!participants.contains(currentUserId)) {
        participants.add(currentUserId);
        transaction.update(meetingRef, {'participants': participants});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have joined the meeting successfully!'))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are already part of this meeting.'))
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join the meeting: $error'))
      );
    });
  }

  void _openMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('שתף פגישה'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('העתק קישור לפגישה'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('הוסף ליומן'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('הוסף למועדפים'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('דווח על פגישה'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('עזוב פגישה'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: meetingDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('שגיאה: ${snapshot.error}'));
        }
        var meetingData = snapshot.data ?? {};
        return Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60), // Spacer for the top fixed buttons
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          meetingData['title'] ?? 'לא צוין כותרת',
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(meetingData['description'] ?? 'לא צוין תיאור', textAlign: TextAlign.right),
                      ],
                    ),
                    const Divider(),
                    _infoSection(meetingData),
                    const SizedBox(height: 20),

                    ElevatedButton(
                       style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(96,237,194,1.000
),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoCallPage(
              channelName: "test_channel",  // Example channel name
              token: "cee353f338c74a6784216b9d08aab1e6",     // Replace with your actual token
            ),
          ),
        );
      },
child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.live_tv_outlined, color: Color.fromARGB(255, 18, 12, 12)),
                          SizedBox(width: 10),
                          Text(' כנס לפגישה', style: TextStyle(color: Color.fromARGB(255, 8, 5, 5), fontSize: 20)),
                        ],
                      ),    ),
SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _joinMeeting,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 108, 188, 254),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.video_call, color: Colors.white),
                          SizedBox(width: 10),
                          Text('הצטרף לפגישה', style: TextStyle(color: Colors.white, fontSize: 20)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _participantsTile(meetingData: meetingData),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 223, 223, 223)),
                      shape: WidgetStateProperty.all(const CircleBorder()),
                    ),
                  ),
                 
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: _openMenu,
                     style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 223, 223, 223)),
                      shape: WidgetStateProperty.all(const CircleBorder()),
                      iconSize: WidgetStateProperty.all(30),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom left floating action button
            Positioned(
              bottom: 16,
              left: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/editmeeting/${widget.meetingId}');
                },
                
                backgroundColor: const Color.fromRGBO(96,237,194,1.000
),
                child: const Icon(Icons.edit, color: Colors.white),
                
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _infoSection(Map<String, dynamic> meetingData) {
    return Container(
      child: Column(
        children: [
          Row(
            
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoTile(Icons.calendar_today, 'תאריך', _formatTimestamp(meetingData['date'] as Timestamp?)),
              _infoTile(Icons.access_time, 'שעה', _formatTime(meetingData['date'] as Timestamp?)),
            ],
          ),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoTile(Icons.person, 'מארח', meetingData['host'] ?? 'לא צוין מארח'),
              _infoTile(Icons.notifications, 'התראה לפני', meetingData['notifyBefore'] ?? 'לא צוין'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      width: 170,
      height: 120,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14, color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(value, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }

  Widget _participantsTile({required Map<String, dynamic> meetingData}) {
    List participants = (meetingData['participants'] ?? []) as List;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Icon(Icons.people, size: 30),
              const SizedBox(width: 8),
              Text('משתתפים', style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14, color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 5),
          ListView.builder(
            shrinkWrap: true,
            itemCount: participants.length,
            itemBuilder: (context, index) {
              String participantName = participants[index] is Map
                  ? (participants[index]['name'] ?? 'לא צוין שם') as String
                  : participants[index].toString();
              return Card(
                child: ListTile(
                  title: Text(participantName),
                  leading: const Icon(Icons.person),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'לא הוגדר';
    return intl.DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return 'לא הוגדר';
    return intl.DateFormat('HH:mm').format(timestamp.toDate());
  }
}
