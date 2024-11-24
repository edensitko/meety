import 'package:flutter/material.dart';
import 'package:meety/screens/preLogin.dart';
import 'package:meety/screens/signUp/signup_screen.dart';
import 'package:meety/screens/splash3.dart';
import 'package:meety/screens/splash2.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
         SignupContent(pageController: _pageController),


        ],
      ),
    );
  }
}

class SplashContent extends StatefulWidget {
  final PageController pageController;

  const SplashContent({Key? key, required this.pageController}) : super(key: key);

  @override
  _SplashContentState createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/log.mp4')
      ..initialize().then((_) {
        setState(() {}); // Update the UI when the video is ready
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background video
        if (_controller != null && _controller!.value.isInitialized)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),

        // Gradient overlay for background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(1),
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ),
          ),
        ),

        // Logo image
        Positioned(
          top: 120,
          left: 50,
          right: 50,
          child: Transform.scale(
            scale: 0.9, // Static scale for the logo
            child: Image.asset('assets/images/logowhite.png', height: 40),
          ),
        ),

        // Main text
        const Positioned(

          bottom: 240,
          left: 20,
          right: 20,
          child: Text(
            'הצעד הבא לעבר פגישות ונטוורקינג בקריירה שלך',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
            
          ),
        ),
 const Positioned(

          bottom: 190,
          left: 140,
          right: 20,
          child: Text(
            ' עם התאמה אישית של פגישות ונטוורקינג בעזרת AI מתקדם וכלים חכמים לניהול קריירה', 
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w200),
            
          ),
        ),
        // Scrolling indicator dots
        Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 20.0,
                height: 3.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: index == 0 ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              );
            }),
          ),
        ),

        // Elevated button
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                 Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(95, 138, 248, 158),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'המשך',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
