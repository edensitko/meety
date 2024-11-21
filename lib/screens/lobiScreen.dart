// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// class VideoLobbyScreen extends StatefulWidget {
//   final String meetingId;
//   final List<String> participants;

//   VideoLobbyScreen({required this.meetingId, required this.participants});

//   @override
//   _VideoLobbyScreenState createState() => _VideoLobbyScreenState();
// }

// class _VideoLobbyScreenState extends State<VideoLobbyScreen> {
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   MediaStream? _localStream;
//   bool _isCameraInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeRenderer();
//   }

//   Future<void> _initializeRenderer() async {
//     try {
//       await _localRenderer.initialize();

//       // Request user media
//       final mediaConstraints = {
//         'video': {'facingMode': 'user'}, // Use front camera
//         'audio': true,
//       };

//       _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       _localRenderer.srcObject = _localStream;

//       setState(() {
//         _isCameraInitialized = true;
//       });
//     } catch (e) {
//       print('Error initializing camera: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to initialize camera')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _localStream?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lobby - ${widget.meetingId}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _isCameraInitialized
//                 ? GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 1.0,
//                     ),
//                     itemCount: widget.participants.length + 1, // Local + others
//                     itemBuilder: (context, index) {
//                       if (index == 0) {
//                         return _buildVideoTile('Me', _localRenderer);
//                       }
//                       return _buildParticipantTile(widget.participants[index - 1]);
//                     },
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _joinMeeting,
//             child: Text('Join Meeting'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blueAccent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoTile(String name, RTCVideoRenderer renderer) {
//     return Container(
//       margin: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: RTCVideoView(renderer, mirror: true),
//           ),
//           SizedBox(height: 10),
//           Text(name, style: TextStyle(color: Colors.white)),
//         ],
//       ),
//     );
//   }

//   Widget _buildParticipantTile(String participantName) {
//     return Container(
//       margin: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(
//         child: Text(participantName, style: TextStyle(color: Colors.white, fontSize: 18)),
//       ),
//     );
//   }

//   void _joinMeeting() {
//     print("Joining the meeting...");
//     // Add your Jitsi meeting logic here
//   }
// }
