import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meety/providers/auth_provider.dart';
import 'profilecard.dart';

class RecommendationsWidget extends StatefulWidget {
  const RecommendationsWidget({super.key});

  @override
  _RecommendationsWidgetState createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<UserData>> _fetchAllUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => UserData.fromFirestore(doc)).toList();
  }

  void _showUserProfile(BuildContext context, UserData user) {
    _animationController.reset();
    _animationController.forward();

    showDialog(
      context: context,
      builder: (BuildContext context) {

        return ScaleTransition(
                    scale: _scaleAnimation,
            child: ProfileCard(
              
              name: user.name,
              age: user.location,
              email: user.email,
              profession: user.profession,
              imageUrl: user.imageUrl,
            ),
          
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserData>>(
      future: _fetchAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final allUsers = snapshot.data!;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color.fromRGBO(28, 170, 227, 1), width: 1),
                 boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.help),
                        onPressed: () {
                          _showHelpDialog(context);
                        },
                      ),
                      const Center(
                        child: Text(
                          'המלצות חכמות',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: allUsers.map((user) {
                      return GestureDetector(
                        onTap: () => _showUserProfile(context, user),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        ),
                                        Text(
                                          user.location,
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(user.imageUrl),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
           
          ],
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('המלצות חכמות'),
          content: const Text('המלצות חכמות הן המלצות שמתבססות על AI והפרופיל שלך ומטרתן לעזור לך להתמקד בנושאים שיכולים להיות רלוונטיים עבורך.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('סגור'),
            ),
          ],
        );
      },
    );
  }
}
