import 'package:meety/providers/notificationProvider.dart';
import 'package:meety/widgets/SearchWidget.dart';
import 'package:meety/widgets/profilecard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meety/widgets/navbar.dart';
import 'package:meety/widgets/notifications.dart';
import 'package:meety/widgets/sideMenu.dart';
import 'package:provider/provider.dart';

class UserData {
  final String name;
  final String location;
  final String profession;
  final String email;
  final String imageUrl;
  final bool isOnline;
  final bool isAvailableForMeeting;

  UserData({
    required this.name,
    required this.location,
    required this.profession,
    required this.imageUrl,
    required this.email,
    required this.isOnline,
    required this.isAvailableForMeeting,
  });

  factory UserData.fromFirestore(Map<String, dynamic> data) {
    return UserData(
      name: data['name'] ?? 'No Name',
      location: data['location'] ?? 'No Location',
      profession: data['profession'] ?? 'No Profession',
      imageUrl: data['profileImage'] ?? '',
      email: data['email'] ?? 'No Email',
      isOnline: data['isOnline'] ?? false,
      isAvailableForMeeting: data['isAvailableForMeeting'] ?? false,
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserData> users = [];
  String selectedFilter = 'הכל';
  bool isLoading = true;
  bool showChats = true; // Toggle between chats and video chats
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    ); _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    fetchUsers();
  }
@override
void dispose() {
  super.dispose();
}

  Future<void> fetchUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      setState(() {
        users = snapshot.docs
            .map((doc) => UserData.fromFirestore(doc.data()))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<UserData> filteredUsers = applyFilter();

    return Directionality(
      textDirection: TextDirection.ltr, // Apply RTL layout
      child: Scaffold(
                drawer: SideMenu(), // Add your SideMenu widget here

        appBar: AppBar(
          backgroundColor:  const Color.fromARGB(255, 238, 238, 238),

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
            : buildContent(filteredUsers),

            
                  bottomNavigationBar: const Navbar(currentRouteIndex: 4),

      ),
    );
  }

  List<UserData> applyFilter() {
    if (selectedFilter == 'מחוברים') {
      return users.where((user) => user.isOnline).toList();
    } else if (selectedFilter == 'זמינים לפגישה') {
      return users.where((user) => user.isAvailableForMeeting).toList();
    } else {
      return users;
    }
  }

  Widget buildContent(List<UserData> filteredUsers) {
    return SingleChildScrollView(

      child: Container(
color: const Color.fromARGB(255, 238, 238, 238),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildToggleButtons(), // Toggle between chats and video chats
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                        buildFilterChips(),

                         widgetsearch()
                        

              ],


            ),

            showChats ? buildChatList(filteredUsers) : buildVideoChatList(filteredUsers),
      
          ],
        ),
      ),
    );
  }

  Widget buildToggleButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  showChats = true;
                });
              },
              style: TextButton.styleFrom(),
              child: Text(
                'צ\'אטים',
                style: TextStyle(
                  color: showChats ? Colors.blue : const Color.fromARGB(255, 12, 1, 1),
                ),
              ),
            ),
// conatiner 1 width bkack 
            Container(
              width: 1,
              height: 50,
              color: const Color.fromARGB(22, 0, 0, 0),
            ),
            
            TextButton(
              onPressed: () {
                setState(() {
                  showChats = false;
                });
              },
              style: TextButton.styleFrom(),
              child: Text(
                'וידאו צ\'אט',
                style: TextStyle(
                  color: showChats ? const Color.fromARGB(255, 7, 4, 4) : Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const Divider(
          color: Color.fromARGB(17, 0, 0, 0),
          thickness: 1,
        ),
      ],
    );

  }

// widgetsearch 
  Widget widgetsearch() {
    return Column(
      children: [
        buildSearchBar(),
      ],
    );
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

  Widget buildChatList(List<UserData> filteredUsers) {
    return buildUserList(filteredUsers, "Chat with");
    
  }

  Widget buildVideoChatList(List<UserData> filteredUsers) {
    return buildUserList(filteredUsers, "Video chat with");
  }

  Widget buildUserList(List<UserData> filteredUsers, String buttonLabel) {
    return Column(
      children: filteredUsers.map((user) {
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
                  const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 119, 156, 240)),
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
    );
                      
  }

  Widget buildStories() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: user.isOnline ? Colors.green : Colors.red,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(user.name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

// widget search bar 80 precent width and the rest is 3 dost button that opens a dialog box with filter chips

  Widget buildSearchBar() {

    return    // container text search field with submit button
    Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 251, 251, 251),
      //   gradient: const LinearGradient(
      //     colors: [
      //  Color.fromRGBO(67, 198, 250, 0.513),
      //   Color.fromARGB(95, 138, 248, 158),
      //     ],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'חפש...',
          hintStyle: const TextStyle(color: Color.fromARGB(255, 175, 174, 174)),
          prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 175, 174, 174)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none, // Remove the default border
            
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Adjust padding to make the height less
          filled: true, // Fill the container with color
          fillColor: const Color.fromARGB(0, 170, 164, 164), // Make background color transparent
        ),
      ),
    );

  }


  Widget buildFilterChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('בחר פילטר'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildFilterChip('הכל'),
                      buildFilterChip('מחוברים'),
                      buildFilterChip('זמינים לפגישה'),
                    ],
                  ),
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
          },
        ),
      ],
    );
  }

  Widget buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedFilter == label,
      onSelected: (selected) {
        setState(() {
          selectedFilter = label;
        });
      },
    );
  }
}
class SearchScreenn extends StatefulWidget {
  const SearchScreenn({super.key});

  @override
  _SearchScreennState createState() => _SearchScreennState();
}

class _SearchScreennState extends State<SearchScreen> {
  void _navigateToNewPage() {
    Navigator.of(context).push(_createZoomInPageRoute(const NewPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _navigateToNewPage,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: Colors.blueAccent,
          ),
          child: const Text(
            'Open New Page',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Route _createZoomInPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var scaleAnimation = Tween<double>(begin: begin, end: end).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
        );

        return ScaleTransition(
          scale: scaleAnimation,
          child: child,
        );
      },
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('New Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the New Page!',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
