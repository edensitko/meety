import 'package:flutter/material.dart';
import 'package:meety/providers/auth_provider.dart';

class RightSideMenu extends StatelessWidget {
  final AuthProvider authProvider;

  const RightSideMenu({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return Directionality(

      textDirection: TextDirection.rtl,
      child: Material(
        elevation: 4,

        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        child: Container(
          
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
                  color: const Color.fromARGB(255, 238, 238, 238),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.close, color: const Color.fromARGB(255, 19, 17, 17)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              _buildMenuItem(
                icon: Icons.person,
                text: 'פרופיל',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/settings' );
                },
              ),
              _buildMenuItem(
                icon: Icons.notifications,
                text: 'התראות',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildMenuItem(
                icon: Icons.calendar_today,
                text: 'לוח פגישות',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              
              _buildMenuItem(
                icon: Icons.dashboard,
                text: 'לוח מחוונים',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildMenuItem(
                icon: Icons.settings,
                text: 'הגדרות',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
             _buildMenuItem(
                icon: Icons.logout,
                text: 'יציאה',
                onTap: () async {
                  await authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/preLogin');
                },
              ),
            ],
          ),
        ),

      ),
    );
  }

                
  
  Widget _buildMenuItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 10, 9, 9)),
      title: Text(
        text,
        style: const TextStyle(color: Color.fromARGB(255, 7, 6, 6)),
      ),
      onTap: onTap,
    );
  }
}

void openRightSideMenu(BuildContext context, AuthProvider authProvider) {
  final width = MediaQuery.of(context).size.width * 0.6;
  final height = MediaQuery.of(context).size.height * 0.8;
  


  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
      return Container(
        
        alignment: Alignment.centerRight,
        
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: RightSideMenu(authProvider: authProvider),
          
        ),
        
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset(0.0, 0.0);
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
