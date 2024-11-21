import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meety/providers/notificationProvider.dart';
import 'package:meety/screens/sidemenu.dart';
import 'package:meety/widgets/notifications.dart';
import 'package:meety/widgets/switchable.dart';
import 'package:provider/provider.dart';
import 'package:meety/providers/auth_provider.dart';
import 'package:meety/widgets/ProjectsWidget.dart';
import 'package:meety/widgets/SearchWidget.dart';
import 'package:meety/widgets/UpcomingMeetingsWidget.dart';
import 'package:meety/widgets/statistics.dart';
import 'package:meety/widgets/recommendations.dart';
import 'package:meety/widgets/navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    UserData? currentUserData = authProvider.currentUserData;
 
    void navigatemeeting() {

      Navigator.pushReplacementNamed(context, '/match');
    }
    return Scaffold(
      bottomNavigationBar: const Navbar(currentRouteIndex: 0),
      body: Stack(
        
        children: [
          
          // Background and Header Section
          Column(
            children: [
              // Background image
             
              Container(
                // image background
                
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                height: 400, // Adjust the height as necessary for the header
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fgree.png'),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(103, 0, 0, 0), // Equivalent to Colors.black.withOpacity(0.5)
                      BlendMode.darken,
                    ),
                    
                  ),

                ),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row with notifications and logo
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                             IconButton(
                              icon: const Icon(Icons.notifications),
                              color: const Color.fromARGB(255, 250, 249, 249),
                              iconSize: 30,
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
                            IconButton(
  icon: const Icon(Icons.menu),
  color: Colors.white,
  iconSize: 30,
  onPressed: () {
    // open SideMenu
   openRightSideMenu(context, authProvider);
  },
)
                          ]
                        
                        ),    
                        

                        Row(
                          
                          children: [
                            Image.asset('assets/images/logowhite.png', width: 80, height: 100),

                            

                          ],
                        )
                    
                      ],
                    ),
                    const SizedBox(height: 0),
                    // Profile info
                    
                    Row(
                      textDirection:  TextDirection.rtl,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: currentUserData?.profileImage != null
                              ? NetworkImage(currentUserData!.profileImage)
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,15,10,20),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Text(
                                ',היי',
                                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 30 , fontWeight: FontWeight.w400),
                              ),
                              Text(
                                currentUserData?.name ?? 'משתמש',
                                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600 ,// 
                                
                                color: Color.fromARGB(255, 255, 255, 255),
                                
                              ),
                              ),

                            ],

                          ),

                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Positioned(
          ////  top: 100,
          //  left: 0,
          //  child: 
          //image 
          // Container(
          //   height: 250,
          //   width: 200,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/astro1.png'),
          //       opacity: 0.1,
          //       fit: BoxFit.contain,

          //             ),  
                                  
                
          //     ),
          //   ),
          //),
          
          
          
          
          Column(
            // text of how much meets you have 
            children: [
              const SizedBox(height: 220),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      ' יש לך 3 פגישות קרובות',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Color.fromARGB(255, 255, 254, 254)),
                    ),
                    const Spacer(),
                  Container(
                   padding: const EdgeInsets.fromLTRB( 4,0,4,0),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                    Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(95, 138, 248, 158),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        navigatemeeting();
                      },
                      child: const Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text('כל הפגישות', style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 130, 130, 130))),
                          Icon(Icons.arrow_back_ios, size: 16, color: Color.fromARGB(255, 165, 165, 165)),
                        ],
                      ),
                    ),
                  ),
     
                  ],
                ),
              ),
            ],

          ),
          // Draggable Scrollable Section
         
          DraggableScrollableSheet(
            initialChildSize: 0.6, // Initial size of the scrollable sheet
            minChildSize: 0.6, // Minimum size to which it can be dragged down
            maxChildSize: 1.0, // Maximum size to which it can be expanded
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 238, 238),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 237, 237, 237).withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                                const SizedBox(height: 10),

                        // button that indicates the drag with icon 
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 200, 200, 200),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        const SearchWidget(),
                       const SwitchableWidget() , 
                        const UpcomingMeetingsWidget(),
                        const SizedBox(height: 20),
                        const StatisticsWidget(
                          meetings: 57,
                          posts: 16,
                          followers: 71,
                          completedMeetings: 10,
                        ),
                        const SizedBox(height: 20),
                        const RecommendationsWidget(),
                        
                        const SizedBox(height: 20),
                        const ProjectsWidget(),
                        const SizedBox(height: 20),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // Add navigation action here
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   child: const Text('פגישה חדשה'),
                        // ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
