import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meety/screens/login_screen.dart';
import 'package:meety/screens/signUp/signup_screen.dart';
import 'package:meety/screens/splash3.dart';
import 'package:meety/screens/splash.dart';
import 'package:meety/screens/splash2.dart';

class PreLoginScreen extends StatefulWidget {
  const PreLoginScreen({super.key});

  @override
  _PreLoginScreenState createState() => _PreLoginScreenState();
}  


class _PreLoginScreenState extends State<PreLoginScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          SplashContent(pageController: _pageController),
          Splash2Content(pageController: _pageController),
          Splash3Content(pageController: _pageController),
          PreloginContent(pageController: _pageController),

        ],
      )
    );
  }
}


class PreloginContent extends StatelessWidget {
  final PageController pageController;

  const PreloginContent({super.key, required this.pageController});

  void _navigateToSignup(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignupContent(pageController: pageController),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false,
    );
  }
   

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen()
      
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/tosplash.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                ),
              ),
            ),
          ),
          
            Positioned(
            top: 70,
            left: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(72, 220, 219, 219),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  icon: const Icon(Icons.arrow_back, color:   Color.fromRGBO(67, 198, 250, 0.845),),
                onPressed:
                    () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Splash3Content(pageController: pageController))),
              ),
            ),
          ),
          // White semi-transparent container for content
        Positioned(
  top: 180,
  left: 20,
  right: 20,
  child: ClipRRect(
    borderRadius: const BorderRadius.all(
      Radius.circular(50),
    ),
    child: Stack(
      children: [
        // Background image with opacity for a softened effect
        Positioned.fill(
          child: Opacity(
            opacity: 0.2, // Adjust the opacity for the frosted effect
            child: Image.asset(
              'assets/noise.png', // Path to your image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // BackdropFilter for blur effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1), // Adds a frosted glass overlay
            ),
          ),
        ),
        // Content inside the frosted glass container
        Padding(
          padding: const EdgeInsets.all(50),
          child: _buildInitialScreen(context),
        ),
      ],
    ),
  ),
),
 Positioned(
      top: 180,

     child: 
          //image 
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wellcome.png'),
                opacity: 0.4,
                fit: BoxFit.contain,

                      ),  
                                  
                
              ),
            ),
          ),

          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Image.asset(
                  'assets/icon/MeetyLogoFull.png',
                  height: 50,
                ),
                const SizedBox(height: 20),
                
              ],
            ),
          ),
        
        ],
      ),
      
    );
  }

  // Main screen layout with buttons and social icons
  Widget _buildInitialScreen(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'ברוך הבא',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 30),
        // Login button

        
        ElevatedButton(
          
          onPressed: () => _navigateToLogin(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor:  Color.fromRGBO(67, 198, 250, 0.497),
          ),
          child: const Text(
            'התחברות',
            style: TextStyle(fontSize: 18, color: Color.fromARGB(221, 249, 247, 247)),
            
          ),
          
        ),
        const SizedBox(height: 20),
        // Signup button
        ElevatedButton(
          onPressed: () => _navigateToSignup(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:                      Color.fromARGB(124, 138, 248, 158),

            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'הרשמה',
            style: TextStyle(fontSize: 18, 
            color: Color.fromARGB(255, 255, 254, 254)),
          ),
        ),
        const SizedBox(height: 20),
        // Divider line and social media text
        const Divider(thickness: 1, color: Colors.black12, height: 30),
        const Text(
          'או התחבר באמצעות',
          style: TextStyle(color: Color.fromARGB(221, 252, 252, 252), fontSize: 18),
        ),
        const SizedBox(height: 15),
        // Social media icons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(Icons.facebook),
            const SizedBox(width: 20),
            _buildSocialButton(Icons.wallet),
            const SizedBox(width: 20),
            _buildSocialButton(Icons.mail),
          ],
        ),
      ],
    );
  }

  // Helper to build social media button
  Widget _buildSocialButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(67, 198, 250, 0.513),
            Color.fromARGB(95, 138, 248, 158),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: const Color.fromARGB(43, 224, 224, 224),
        child: Icon(icon, color: const Color.fromARGB(221, 252, 251, 251), size: 28),
      ),
    );
  }
}
