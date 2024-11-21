import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class VideoCallPage extends StatefulWidget {
  final String channelName;
  final String token;

  VideoCallPage({required this.channelName, required this.token});

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late final AgoraClient client;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "cee353f338c74a6784216b9d08aab1e6",
        channelName: widget.channelName,
        tempToken: widget.token,
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
    );
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // title and logo 
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 40.0,
              child: Image.asset('assets/images/meety.png'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AgoraVideoViewer(client: client),  // Video view for local and remote
            ),
            AgoraVideoButtons(client: client), // Built-in UI for common controls
          ],
        ),
       
      ),
    );
  }
}
