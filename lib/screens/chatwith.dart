import 'package:meety/screens/userprofile_screen.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart'; // For Hebrew locale
import 'package:meety/providers/UnreadMessagesProvider.dart';
import 'package:meety/providers/messageProvider.dart';
import 'package:meety/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWithScreen extends StatefulWidget {
  final String userEmail;
  final String userName;
  final bool isGroupChat;
  final String groupId;

  const ChatWithScreen({super.key, 
    required this.userEmail,
    required this.userName,
    this.isGroupChat = false,
    this.groupId = '',
  });

  @override
  _ChatWithScreenState createState() => _ChatWithScreenState();
}

class _ChatWithScreenState extends State<ChatWithScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  String? conversationId;
  String? userImageUrl;
  String? currentUserImageUrl;
  String? currentUserName;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('he', null); // Initialize Hebrew locale
    _currentUser = _auth.currentUser;
    if (widget.isGroupChat) {
      conversationId = widget.groupId;
      _fetchCurrentUserImage();
    } else {
      _initConversation();
    }
  }

Future<void> recordProfileView(String visitedUserEmail) async {
  if (_currentUser != null) {
    try {
      // Fetch the ID of the user being visited using their email
      QuerySnapshot visitedUserSnapshot = await _firestore.collection('users')
          .where('email', isEqualTo: visitedUserEmail)
          .limit(1)
          .get();

      if (visitedUserSnapshot.docs.isNotEmpty) {
        DocumentSnapshot visitedUserDoc = visitedUserSnapshot.docs.first;
        String visitedUserId = visitedUserDoc.id;

        // Record the profile view in the 'profileViews' collection
        await _firestore.collection('profileViews').add({
          'viewerId': _currentUser!.uid,
          'visitedUserId': visitedUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Create a notification for the visited user
        await _firestore.collection('notifications').add({
          'userId': visitedUserId,
          'message': 'Your profile was viewed by ${_currentUser!.displayName ?? _currentUser!.email}',
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'profileView',
        });

        print('Profile view recorded and notification sent.');
      } else {
        print('User with email $visitedUserEmail not found.');
      }
    } catch (e) {
      print('Error recording profile view: $e');
    }
  }
}




void navigateToUserProfile(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(userEmail: user['email']),
      ),
    );
  }

  
  Future<void> _initConversation() async {
    await _fetchUserImages();

    QuerySnapshot conversationQuery = await _firestore
        .collection('chats')
        .where('participants', arrayContains: _currentUser!.email)
        .get();

    for (var doc in conversationQuery.docs) {
      if (doc['participants'].contains(widget.userEmail)) {
        setState(() {
          conversationId = doc.id;
        });
        return;
      }
    }

    DocumentReference newConversation = await _firestore.collection('chats').add({
      'participants': [_currentUser!.email, widget.userEmail],
      'participantNames': {
        _currentUser!.email!: _currentUser!.displayName ?? _currentUser!.email!,
        widget.userEmail: widget.userName,
      },
      'participantImages': {
        _currentUser!.email!: currentUserImageUrl ?? '',
        widget.userEmail: userImageUrl ?? '',
      },
      'lastMessage': '',
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      conversationId = newConversation.id;
    });
  }

  Future<void> _fetchUserImages() async {
    if (!widget.isGroupChat) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(widget.userEmail).get();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      currentUserImageUrl = prefs.getString('userImageUrl');
      currentUserName = prefs.getString('userName');

      setState(() {
        if (userDoc.exists) {
          userImageUrl = userDoc['imageUrl'];
        }
      });
    }
  }

  Future<void> _fetchCurrentUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserImageUrl = prefs.getString('userImageUrl');
    currentUserName = prefs.getString('userName');
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || conversationId == null) return;

    String message = _controller.text.trim();
    _controller.clear();

    try {
      if (widget.isGroupChat) {
        await _firestore.collection('groups').doc(conversationId).collection('messages').add({
          'text': message,
          'from': _currentUser!.email,
          'groupId': conversationId,
          'timestamp': FieldValue.serverTimestamp(),
          'profileImageUrl': currentUserImageUrl ?? '',
          'read': false,
        });
      } else {
        await _firestore.collection('chats').doc(conversationId).collection('messages').add({
          'text': message,
          'from': _currentUser!.email,
          'to': widget.userEmail,
          'timestamp': FieldValue.serverTimestamp(),
          'profileImageUrl': currentUserImageUrl ?? '',
          'read': false,
        });

        await _firestore.collection('chats').doc(conversationId).update({
          'lastMessage': message,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
        });
      }

      context.read<UnreadMessagesProvider>().refreshUnreadCount();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _markMessagesAsRead() async {
    try {
      QuerySnapshot<Map<String, dynamic>> messagesSnapshot;
      if (widget.isGroupChat) {
        messagesSnapshot = await _firestore.collection('groups').doc(conversationId).collection('messages')
            .where('to', isEqualTo: _currentUser!.email)
            .where('read', isEqualTo: false)
            .get();
      } else {
        messagesSnapshot = await _firestore.collection('chats').doc(conversationId).collection('messages')
            .where('to', isEqualTo: _currentUser!.email)
            .where('read', isEqualTo: false)
            .get();
      }

      for (var doc in messagesSnapshot.docs) {
        await doc.reference.update({'read': true});
      }

      context.read<MessageProvider>().unreadMessages.clear();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Stream<QuerySnapshot> _getMessages() {
    if (widget.isGroupChat) {
      return _firestore
          .collection('groups')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return _firestore
          .collection('chats')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BFFF),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                  icon: const Icon(Icons.arrow_back, color:   Color.fromRGBO(67, 198, 250, 0.513),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Handle notification click
                  },
                ),
                const Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 60, right: 0),
                  height: MediaQuery.of(context).size.height * 0.15,
                  color: const Color(0xFF00BFFF),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Align content to the right
                    children: [
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white, size: 30),
                        onPressed: () {
                          showMenu(
                            context: context,
                            position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                            items: [
                              const PopupMenuItem<String>(
                                value: 'profile',
                                child: Text('פתח פרופיל'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'block',
                                child: Text('חסום'),
                              ),
                            ],
                            elevation: 8.0,
                          ).then((value) {
                            if (value == 'profile') {
                             navigateToUserProfile({
                              'email': widget.userEmail,
                              'name': widget.userName,
                              'imageUrl': userImageUrl,
                            });
                            } else if (value == 'block') {
                              // Handle "Block"
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 2),
                      CircleAvatar(
                        backgroundImage: userImageUrl != null
                            ? NetworkImage(userImageUrl!)
                            : const AssetImage('assets/images/meety.png') as ImageProvider,
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Align messages to start from top
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _getMessages(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          var messages = snapshot.data!.docs;

                          _markMessagesAsRead();

                          return ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              var message = messages[index];
                              var isMe = message['from'] == _currentUser!.email;

                              DateTime? messageDate;
                              if (message['timestamp'] != null) {
                                messageDate = (message['timestamp'] as Timestamp).toDate();
                              }

                              String dateLabel = '';
                              if (messageDate != null) {
                                if (index == messages.length - 1 || 
                                    DateTime(messageDate.year, messageDate.month, messageDate.day) !=
                                        DateTime((messages[index + 1]['timestamp'] as Timestamp?)?.toDate().year ?? 0,
                                                (messages[index + 1]['timestamp'] as Timestamp?)?.toDate().month ?? 0,
                                                (messages[index + 1]['timestamp'] as Timestamp?)?.toDate().day ?? 0)) {
                                  if (DateTime.now().difference(messageDate).inDays == 0) {
                                    dateLabel = 'היום'; // "Today" in Hebrew
                                  } else if (DateTime.now().difference(messageDate).inDays == 1) {
                                    dateLabel = 'אתמול'; // "Yesterday" in Hebrew
                                  } else {
                                    dateLabel = intl.DateFormat('dd MMMM yyyy', 'he').format(messageDate);
                                  }
                                }
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (dateLabel.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Center(
                                        child: Text(
                                          dateLabel,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0), // Increase the vertical padding
                                    child: Align(
                                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isMe ? Colors.blue.shade100 : const Color.fromARGB(255, 211, 210, 210),
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(15),
                                            topRight: const Radius.circular(15),
                                            bottomLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
                                            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,

                                          children: [
                                            Text(
                                              message['text'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),  textAlign: TextAlign.right, // Align text to the right

                                            ),
                                            Text(
                                              
                                              messageDate != null
                                                  ? intl.DateFormat('hh:mm a', 'he').format(messageDate)
                                                  : '',
                                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'שלח הודעה',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.blue),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(currentRouteIndex: 3),
    );
  }
}
