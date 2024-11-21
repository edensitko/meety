import 'package:flutter/material.dart';
import 'package:meety/widgets/PaymentBottomSheet.dart';
import 'package:meety/widgets/ballance.dart';
import 'package:meety/widgets/createmeet.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Side Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
           ElevatedButton(
          onPressed: () {
            // Open the Payment Bottom Sheet
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return const PaymentBottomSheet();
              },
            );
          },
          child: Text('Open Payment Bottom Sheet'),
        ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle the tap for Home
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('חשבון '),
            onTap: () {
              // open BalanceScreen 
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BalanceScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Meeting'),
            onTap: () {
              // Handle the tap for Add Meeting
 showModalBottomSheet(
      context: context,
      builder: (context) {
     return Container(
                  height: MediaQuery.of(context).size.height * 0.9, // Set height to 80% of screen
                  child: const CreateMeetingWidget(),
                );
      },
    );            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Handle the tap for About
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}