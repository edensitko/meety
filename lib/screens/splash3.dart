import 'package:flutter/material.dart';
import 'package:meety/screens/login_screen.dart';
import 'package:meety/screens/signUp/signup_screen.dart';
import 'package:meety/screens/splash3.dart';
import 'package:meety/screens/preLogin.dart';
import 'package:meety/screens/splash.dart';
import 'package:meety/screens/splash2.dart';
import 'package:video_player/video_player.dart';

class Splash3Screen extends StatefulWidget {
  const Splash3Screen({super.key});

  @override
  _Splash3ScreenState createState() => _Splash3ScreenState();
}

class _Splash3ScreenState extends State<Splash3Screen> {
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


class Splash3Content extends StatelessWidget {
  final PageController pageController;

  const Splash3Content({Key? key, required this.pageController}) : super(key: key);
@override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            // תמונת רקע
            Positioned.fill(
              
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/tosplash.png'), // נתיב לתמונת רקע
                    fit:BoxFit.cover,
                     colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken
                     )
                  ),
                ),
              ),
            ),
            // לוגו וכותרת
           
        // back bottom to previous page positioned left top 
         


            Positioned(
              top: 120, // מיקום אנכי של הלוגו
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/MeetyLogoFull.png', // נתיב ללוגו
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  // container with text
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                  const Text(
                    'התאמה אישית של פגישות ונטוורקינג בעזרת AI מתקדם',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 254, 253, 253),
                    ),
                    textAlign: TextAlign.center,
                  ),),
                ],
              
              ),
            ),
            // רשימת התכונות
            
            Positioned(
              top: 350, // מיקום אנכי של רשימת התכונות
              left: 20,
              right: 20,
              
              child: Container(
               padding:  const EdgeInsets.fromLTRB(20, 20, 20, 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(255, 249, 248, 248),

                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeature('ניהול יומן מתקדם'),
                    _buildFeature('מערכת מבוססת AI'),
                    _buildFeature('שיפור יחסי אנוש'),
                    _buildFeature('הרחבת קהילה'),
                    _buildFeature('נטוורקינג חכם'),
                  ],
                ),
              ),
            ),
            // כפתור המשך
            Container(
          decoration: BoxDecoration(

            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.8),
                 Colors.black.withOpacity(0.4),

                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ),
          ),
        ),
       Positioned(
            bottom: 130,
            left: 20,
            right: 20,
            
            child: 
          //image 
          Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sitt.png'),
                opacity: 0.4,
                fit: BoxFit.contain,
                      ),  
              ),
            ),
          ),
            // כפתור חזור בתחתית
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
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => PreloginContent( pageController: pageController),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
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
                  color: index == 2 ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              );
            }),
          ),
        ),
          Positioned(
              top: 70, 
              left: 20,
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                  color: Color.fromARGB(72, 220, 219, 219),
                  shape: BoxShape.circle,
                  ),
                  child: IconButton(
                  icon: const Icon(Icons.arrow_back, color:   Color.fromRGBO(67, 198, 250, 0.845),),
                  onPressed: () {
                    Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => Splash2Content(pageController: pageController),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                      },
                    ),
                    );
                  },
                  ),
                ),
              ),
            ),

        
          ],
        ),
      ),
    );
  }

  // פונקציה לבניית תכונה עם אייקון '✔️'
  Widget _buildFeature(String text) {
    return Padding(

      padding: const EdgeInsets.symmetric(vertical:10.0 , horizontal: 20.0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [

          const Icon(Icons.check, color: Color.fromARGB(255, 22, 20, 20)),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Color.fromARGB(255, 17, 16, 16), fontSize: 18),
          ),
          
        ],
      ),
    );
  }
}
