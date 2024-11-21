import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meety/providers/notificationProvider.dart';
import 'package:meety/widgets/navbar.dart';
import 'package:meety/widgets/notifications.dart';
import 'package:meety/widgets/sideMenu.dart';
import 'package:provider/provider.dart';

class Post {
  final String title;
  final String content;
  final String imageUrl;

  Post({required this.title, required this.content, required this.imageUrl});
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Post> posts = [];
  List<Map<String, dynamic>> events = [];
  bool isLoading = true;
  String errorMessage = '';
  int _currentScreenIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _fetchEvents();
  }

  Future<void> _fetchPosts() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('posts').get();
      setState(() {
        posts = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Post(
            title: data['title'] ?? 'No Title',
            content: data['content'] ?? 'No Content',
            imageUrl: data['profileImage'] ?? '',
          );
        }).toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load posts: $error';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchEvents() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('events').get();
      setState(() {
        events = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (error) {
      print('Failed to load events: $error');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildPostsScreen(),
      _buildRecommendationsScreen(),
      _buildEventsScreen(),
      _buildInfoScreen(),
    ];

    return Directionality(
      textDirection: TextDirection.ltr, // Apply RTL layout
      child: Scaffold(
                drawer: SideMenu(), // Add your SideMenu widget here

        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),

          actions: [
            IconButton(
              
              icon: const Icon(Icons.notifications),
              color: const Color.fromARGB(255, 75, 75, 75),
              iconSize: 28,
              onPressed: () {
                // open NotificationWidget 
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider(
                      create: (_) => NotificationProvider(),
                      child: const NotificationModal(),
                    );
                  },
                );
              },
            ),
           
           
          ],
        ),

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : // do all builds 
            Column(
              children: [
                _buildGradientButtons(),
                Expanded(child: screens[_currentScreenIndex]),
              ],
            ),
            

            
                  bottomNavigationBar: const Navbar(currentRouteIndex: 3),

      ),
    );
  }

  Widget _buildGradientButtons() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMenuButton('פוסטים', 0),
          _buildMenuButton('המלצות קריירה', 1),
          _buildMenuButton('אירועים', 2),
          _buildMenuButton('מידע', 3),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentScreenIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _currentScreenIndex == index ? Colors.blue : Colors.black,
            ),
          ),
          if (_currentScreenIndex == index)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 30,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }

  Widget _buildPostsScreen() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    } else if (posts.isEmpty) {
      return const Center(child: Text('אין פוסטים זמינים.'));
    } else {
      return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post);
        },
      );
    }
  }

 Widget _buildPostCard(Post post) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white ,
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for user profile picture and title
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(post.imageUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(Icons.more_horiz), // Menu or options icon
            ],
          ),
          const SizedBox(height: 8),

          // Post content
          Text(
            post.content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),

          // Optional post image (if needed)
          if (post.imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // Divider between post content and actions
          const Divider(),

          // Action buttons: Like, Comment, Share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPostAction(Icons.thumb_up_alt_outlined, 'אהבתי'),
              _buildPostAction(Icons.comment_outlined, 'תגובה'),
              _buildPostAction(Icons.share_outlined, 'שיתוף'),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildPostAction(IconData icon, String label) {
  return TextButton.icon(
    onPressed: () {}, // Add action logic here
    icon: Icon(icon, color: Colors.grey),
    label: Text(label, style: const TextStyle(color: Colors.grey)),
  );
}

  Widget _buildRecommendationsScreen() {
    final recommendations = [
      'תמיד הישאר עקבי עם המטרות שלך.',
      'תתחבר עם מקצוענים בתחום שלך.',
      'תמשיך ללמוד ולשפר את הכישורים שלך.',
    ];

    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(recommendations[index], style: const TextStyle(fontSize: 18)),
            leading: const Icon(Icons.star, color: Colors.blue),
          ),
        );
      },
    );
  }

  Widget _buildEventsScreen() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(event['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditEventDialog(event),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvent(event['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('הוסף אירוע'),
            onPressed: _showAddEventDialog,
          ),
        ),
      ],
    );
  }

  Future<void> _deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
    _fetchEvents();
  }

  void _showEditEventDialog(Map<String, dynamic> event) {
    TextEditingController titleController = TextEditingController(text: event['title']);
    TextEditingController descriptionController = TextEditingController(text: event['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ערוך אירוע'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'כותרת')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'תיאור')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _firestore.collection('events').doc(event['id']).update({
                  'title': titleController.text,
                  'description': descriptionController.text,
                });
                Navigator.of(context).pop();
                _fetchEvents();
              },
              child: const Text('שמור'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ביטול'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('הוסף אירוע'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'כותרת')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'תיאור')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _firestore.collection('events').add({
                  'title': titleController.text,
                  'description': descriptionController.text,
                });
                Navigator.of(context).pop();
                _fetchEvents();
              },
              child: const Text('הוסף'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ביטול'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoScreen() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('זהו מסך המידע.', textAlign: TextAlign.center),
      ),
    );
  }
}
