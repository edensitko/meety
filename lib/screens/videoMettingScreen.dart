import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class VideoMeetingScreen extends StatefulWidget {
  final String meetingId;
  final String userName;

  const VideoMeetingScreen({super.key, required this.meetingId, required this.userName});

  @override
  _VideoMeetingScreenState createState() => _VideoMeetingScreenState();
}

class _VideoMeetingScreenState extends State<VideoMeetingScreen> {
  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
      onConferenceWillJoin: _onConferenceWillJoin,
      onConferenceJoined: _onConferenceJoined,
      onConferenceTerminated: _onConferenceTerminated,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners(); // Clean up listeners
  }

  void _onConferenceWillJoin(message) {
    print("Conference will join: $message");
  }

  void _onConferenceJoined(message) {
    print("Conference joined: $message");
  }

  void _onConferenceTerminated(message) {
    print("Conference terminated: $message");
  }

  Future<void> _joinMeeting() async {
    try {
      var options = JitsiMeetingOptions(room: widget.meetingId)
        ..userDisplayName = widget.userName
        ..audioMuted = false
        ..videoMuted = false
        ..featureFlags.addAll({
          FeatureFlagEnum.INVITE_ENABLED: false,
          FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
        });

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join meeting: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Meeting'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _joinMeeting,
          icon: const Icon(Icons.videocam),
          label: const Text('Join Meeting'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
