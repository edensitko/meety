import 'package:flutter/material.dart';

// Define your global gradient colors
const LinearGradient globalGradient = LinearGradient(
  colors: [
   Color.fromARGB(255, 190, 243, 200),
                          Color.fromARGB(251, 196, 177, 234),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const GradientIcon({super.key, required this.icon, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return globalGradient.createShader(bounds);
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white, // Set to white to apply the gradient
      ),
    );
  }
}
