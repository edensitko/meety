import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCard extends StatefulWidget {
  final String name;
  final String age;
  final String email;
  final String profession;
  final String imageUrl;

  const ProfileCard({
    super.key, 
    required this.name,
    required this.email,
    required this.age,
    required this.profession,
    required this.imageUrl,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> posts = [];
  bool showBackButton = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _checkIfShowBackButton();
  }

  Future<void> _checkIfShowBackButton() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserEmail = prefs.getString('userEmail');

    setState(() {
      showBackButton = widget.email != currentUserEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 590), 
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(widget.imageUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.age,
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.qr_code, size: 30, color: Colors.black),
                    IconButton(
                      icon: const Icon(Icons.share, size: 30, color: Colors.black),
                      onPressed: () {
                        _showShareOptions(context); 
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'היי אני ${widget.name}, מומחה ל${widget.profession}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                _buildTagsSection(),
                _buildPostSection(context),
                const SizedBox(height: 20), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchPosts() async {
    final QuerySnapshot snapshot = await _firestore.collection('posts').get();
    setState(() {
      posts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; 
        return data;
      }).toList();
    });
  }

  Widget _buildTagsSection() {
    List<String> tags = ['תכנות', 'פודקאסטים', 'שפת פייתון', 'אנגלית'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Text(
              tag,
              style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to Calendar page or perform calendar action
          },
          icon: const Icon(Icons.calendar_today),
          label: const Text('יומן'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 223, 224, 226),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text('הפוסטים שלי', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            _showNewPostDialog(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('הוסף פוסט חדש'),
          style: ElevatedButton.styleFrom(
            shadowColor: const Color.fromARGB(0, 0, 0, 0),
            backgroundColor: const Color.fromARGB(0, 165, 165, 165),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(seconds: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, color: Colors.grey, size: 12),
              SizedBox(width: 5),
              Text('החלק לעריכה/מחיקה', style: TextStyle(color: Colors.grey, fontSize: 10)),
              SizedBox(width: 5),
              Icon(Icons.arrow_forward, size: 12, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: posts.map((post) {
            return Dismissible(
              key: Key(post['id']),
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.orange,
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  bool confirm = await _confirmDelete(context);
                  if (confirm) {
                    _deletePost(post['id']);
                    return true;
                  }
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  _showEditPostDialog(post);
                  return false;
                }
                return false;
              },
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(widget.imageUrl),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'פורסם ב- ${DateTime.now().toString().substring(0, 10)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.more_horiz),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post['content'] ?? 'No Content',
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        if (post.containsKey('profileImage')) ...[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              post['profileImage'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          ),
                        ],
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPostAction(Icons.thumb_up_alt_outlined, "לייק"),
                            _buildPostAction(Icons.comment_outlined, "תגובה"),
                            _buildPostAction(Icons.share_outlined, "שיתוף"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPostAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }

  void _showNewPostDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('הוסף פוסט חדש'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'כותרת הפוסט'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(hintText: 'תוכן הפוסט'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _firestore.collection('posts').add({
                  'title': titleController.text,
                  'content': contentController.text,
                });
                Navigator.of(context).pop();
                _fetchPosts();
              },
              child: const Text('שמור'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ביטול'),
            ),
          ],
        );
      },
    );
  }

  void _showShareOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('שיתוף פרופיל'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('שיתוף קישור'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('שלח הודעה'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('העתק קישור'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('סגור'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
    _fetchPosts();
  }

  Future<void> _showEditPostDialog(Map<String, dynamic> post) {
    TextEditingController titleController = TextEditingController(text: post['title']);
    TextEditingController contentController = TextEditingController(text: post['content']);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ערוך פוסט'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'כותרת הפוסט'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(hintText: 'תוכן הפוסט'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _firestore.collection('posts').doc(post['id']).update({
                  'title': titleController.text,
                  'content': contentController.text,
                });
                Navigator.of(context).pop();
                _fetchPosts();
              },
              child: const Text('שמור'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ביטול'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('אישור מחיקה'),
          content: const Text('האם אתה בטוח שברצונך למחוק את הפוסט הזה?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('ביטול'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('מחק'),
            ),
          ],
        );
      },
    ) ?? false;
  }
}
