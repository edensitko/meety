import 'package:flutter/material.dart';
import 'package:meety/providers/notificationProvider.dart';
import 'package:meety/widgets/sideMenu.dart';
import 'package:provider/provider.dart';
import 'package:meety/providers/auth_provider.dart';
import 'package:meety/widgets/navbar.dart';
import 'package:meety/widgets/notifications.dart';
import 'package:meety/widgets/profilecard.dart';

class ProfileAndSettingsScreen extends StatefulWidget {
  const ProfileAndSettingsScreen({super.key});

  @override
  _ProfileAndSettingsScreenState createState() => _ProfileAndSettingsScreenState();
}

class _ProfileAndSettingsScreenState extends State<ProfileAndSettingsScreen> {
  late UserData currentUser; // User data object for the current user
  double _panelHeightFactor = 0.25; // Start with the panel closed

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.fetchCurrentUser().then((_) {
      // Set the current user data after fetching
      if (authProvider.currentUserData != null) {
        setState(() {
          currentUser = authProvider.currentUserData!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Ensure that the current user is fetched
    if (authProvider.currentUserData == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      currentUser = authProvider.currentUserData!;
    }

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

        


      bottomNavigationBar: const Navbar(currentRouteIndex: 1),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                ProfileCard(
                  name: currentUser.name,
                  age: currentUser.age.toString(),
                  email: currentUser.email,
                  profession: currentUser.profession,
                  imageUrl: currentUser.profileImage,
                ),
               
              ],
            ),
          ),
          // Draggable panel
          DraggableScrollableSheet(
            initialChildSize: _panelHeightFactor,
            minChildSize: 0.1,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      FloatingActionButton( 
                                             
                        backgroundColor: const Color.fromARGB(238, 238, 238, 238),

                        elevation: 0.0,
                        highlightElevation: 0.0,

                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                     


                          ),
                        ), 

                        onPressed: () {
                          setState(() {
                            if (_panelHeightFactor > 0.5) {
                              _panelHeightFactor = 0.1; // Close the panel
                            } else {
                              _panelHeightFactor = 0.8; // Open the panel
                            }
                          });
                        }, 
                                             
                        child: const Icon(Icons.swipe_vertical_rounded),
                      ),
                      // Container with background color and children setting buttons
                      Container(
                        color: const Color.fromARGB(240, 238, 238, 238),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const ListTile(
                                title: Text('החשבון שלי ', style: TextStyle(fontSize: 20)),
                              ),
                              const Divider(),
                              ListTile(
                                title: const Text(' הגדרות חשבון'),
                                onTap: () {},
                              ),
                              const SizedBox(height: 10,),
                              ListTile(
                                title: const Text(' הגדרות פרופיל'),
                                onTap: () {},
                              ),
                              const SizedBox(height: 10,),
                              ListTile(
                                title: const Text(' הגדרות פרטיות'),
                                onTap: () {},
                              ),
                              const SizedBox(height: 10,),
                              ListTile(
                                title: const Text(' הגדרות תקשורת'),
                                onTap: () {},
                              ),
                              const SizedBox(height: 10,),
                              ListTile(
                                title: const Text(' עזרה'),
                                onTap: () {},
                              ),
                              const SizedBox(height: 10,),
                              ListTile(
                                title: const Text(' שינוי סיסמה'),
                                onTap: () {},
                              ),
                              const SizedBox(height: 10,),
                               ElevatedButton(
                onPressed: () async {
                  await authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/preLogin');
                },
                child: const Text('יציאה'),
              ),
                            ],
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Gesture area for opening the settings panel
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  if (details.delta.dy < 0 && _panelHeightFactor < 0.8) {
                    // User swiped up to open
                    _panelHeightFactor += 0.1; // Open panel
                    if (_panelHeightFactor > 0.8) {
                      _panelHeightFactor = 0.8; // Limit to max height
                    }
                  } else if (details.delta.dy > 0 && _panelHeightFactor > 0.1) {
                    // User swiped down to close
                    _panelHeightFactor -= 0.1; // Close panel
                    if (_panelHeightFactor < 0.1) {
                      _panelHeightFactor = 0.1; // Limit to min height
                    }
                  }
                });
              },
              child: Container(
                width: 50,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),

  
    ),
    );



  }


      
}

