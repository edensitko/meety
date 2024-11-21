import 'package:meety/widgets/createmeet.dart';
import 'package:meety/widgets/meetingDetails.dart';
import 'package:meety/widgets/switchable.dart';
import 'package:flutter/material.dart';

class GradientButtonGrid extends StatelessWidget {
  const GradientButtonGrid({super.key, required Null Function() onPressed, required String text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // First Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            _buildGradientButton(' הוסף פגישה', () {
              // show the bottom sheet with create new meeting form
           
             showModalBottomSheet(
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.9, // Set height to 80% of screen
                  child: const CreateMeetingWidget(),
                );
              },
            );
          
            
            }),
            const SizedBox(width: 8), // Space between buttons
            _buildGradientButton('הוסף חבר ', () {
              // Action for Button 2
            }),
          ],
        ),
        const SizedBox(height: 8), // Space between rows
        // Second Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGradientButton(' הוסף פרוייקט ', () {
              // Action for Button 3
            }),
            const SizedBox(width: 8), // Space between buttons
            _buildGradientButton('הוסף פוסט  ', () {
              // Action for Button 4
            }),
          ],
        ),
      ],
    );
  }

// widget for createMeet 
  Widget createMeet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'צור פגישה חדשה',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              labelText: 'שם הפגישה',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              labelText: 'תיאור הפגישה',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Create the meeting
            },
            child: const Text('צור פגישה'),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String label, void Function() onPressed) {
    return Container(
      width: 150,
      height: 100,
      margin: const EdgeInsets.all(4), // Outer margin
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Match the button's border radius
        gradient: const LinearGradient(
          colors: [
 Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(95, 138, 248, 158),
          ],
                          
                          
                                    begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(4),
            backgroundColor: const Color.fromARGB(255, 255, 252, 252) , // Remove padding for the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Match the border radius
            ),
            side: const BorderSide(
              width: 0, // No border width as we want the gradient to be visible
              
            ),
          ),
            // add here an icon 
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Color.fromARGB(255, 13, 13, 13)),
                const SizedBox(width: 4), // Space between icon and text
                Text(
                  label,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 8, 8, 8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
        ),
      ),
    );
  }
}
