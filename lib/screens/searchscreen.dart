import 'package:flutter/material.dart';

class ZoomNavigationButton extends StatelessWidget {
  final Widget destination;


  const ZoomNavigationButton({
    super.key,
    required this.destination,
  
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(_createZoomInPageRoute(destination));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: Colors.blueAccent,
      ), child: null,
     
    );
  }

  Route _createZoomInPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Stack(
        children: [
          // Dimmed background
          Container(color: Colors.black.withOpacity(0.3)),
          // Destination page with zoom-in effect
          ScaleTransition(
            scale: animation,
            child: page,
          ),
        ],
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
    );
  }
}
