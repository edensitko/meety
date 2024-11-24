import 'package:flutter/material.dart';
import 'package:meety/screens/preLogin.dart';
import 'package:meety/screens/signUp/signup_screen.dart';
import 'package:meety/screens/splash3.dart';
import 'package:meety/screens/splash.dart';

class Splash2Screen extends StatefulWidget {
  const Splash2Screen({super.key});

  @override
  _Splash2ScreenState createState() => _Splash2ScreenState();
}

class _Splash2ScreenState extends State<Splash2Screen> {
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


class Splash2Content extends StatelessWidget {
  final PageController pageController;

  const Splash2Content({Key? key, required this.pageController}) : super(key: key);
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
                    image: AssetImage('assets/images/tosplash2.png'), // נתיב לתמונת רקע
                    fit:BoxFit.cover,
                     colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken
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
                  const SizedBox(height: 20),
                  // container with text
                  Container(
                    padding: const EdgeInsets.fromLTRB(5,5,5,20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
              
                ),
                ],
              
              ),
            ),
            // רשימת התכונות
          Positioned(
              top: 250, // מיקום אנכי של הלוגו
              left: 20,
              right: 20,
              child: Column(
                children: [
                  // container with text
                  Container(
                    padding: const EdgeInsets.fromLTRB(20,10,20,20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                  const Text(
                    'השלב הבא בקריירה שלך עם פלטפורמת מידע ולמידה ייחודית', 
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 254, 253, 253),
                    ),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                  ),
                  ),
                ],
              
              ),
            ),
             Positioned(
              top: 400, // מיקום אנכי של הלוגו
              left: 20,
              right: 20,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  // container with text
                  Container(
                    padding: const EdgeInsets.fromLTRB(15,10,10,20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                  const Text(
                    'AI מתקדם וכלים חכמים לניהול קריירה', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 186, 186, 186),
                    ),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                  ),
                
            
                  ),
                ],

              ),
            ),
            Positioned(
              top: 500, // מיקום אנכי של הלוגו
              left: 20,
              right: 20,
              child: Row(
                // make the element near each other 
                textDirection: TextDirection.rtl,
                children: [
                  // container with text
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                    const Text( ' למה ', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 254, 253, 253),
                    ),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,

                  ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    child:
                  const Text(
                    ' אתם צריכים להיות חלק מ-meety ?',  
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 254, 253, 253),
                    ),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                  ),
                
            
                  ),
                ],

              ),
            ),
            // chip with text
            const Positioned(
              top: 540, // מיקום אנכי של הלוגו
              left: 20,
              right: 20,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Chip(
                    label: Text(
                      'נטוורקינג חכם',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 254, 253, 253),
                      ),
                    ),
                    backgroundColor: Color.fromARGB(203, 0, 0, 0),
                  ),
                  SizedBox(width: 15),
                    Chip(
                    
                    label: Text(
                      'ניהול יומן מתקדם',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 254, 253, 253),
                      ),
                    ),
                    backgroundColor: Color.fromARGB(203, 0, 0, 0),
                  ),
                  SizedBox(width: 15),
                   Chip(
                    label: Text(
                       'יעילות בזמן',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 254, 253, 253),
                      ),
                    ),
                    backgroundColor: Color.fromARGB(203, 0, 0, 0),
                  ),
                ],
              ),
              
            ),
            const Positioned(
              top: 590, // מיקום אנכי של הלוגו
              left: 20,
              right: 20,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Chip(
                    label: Text(
                      ' פגישה בקליק',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 254, 253, 253),
                      ),
                    ),
                    backgroundColor: Color.fromARGB(203, 0, 0, 0),
                  ),
                  SizedBox(width: 15),
                    Chip(
                    label: Text(
                      'כלי ניהול קריירה',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 254, 253, 253),
                      ),
                    ),
                    backgroundColor: Color.fromARGB(203, 0, 0, 0),
                  ),
                  SizedBox(width: 15),
                   Chip(
                    label: Text(
                      ' קהילה רחבה',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 254, 253, 253),
                      ),
                    ),
                    backgroundColor: Color.fromARGB(203, 0, 0, 0),
                  ),
                ],
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
                pageController.nextPage(
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
        Positioned(
            top: 50,
            right: -30,
            child: 
          //image 
          Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/baloon.png'),
                opacity: 0.4,
                fit: BoxFit.contain,

                      ),  
                                  
                
              ),
            ),
          ),
Positioned(
            bottom: 290,
            left: 10,
            child: 
          //image 
          Container(
            height: 130,
            width: 130,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/lama.png'),
                opacity: 0.4,
                fit: BoxFit.contain,

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
                  color: index == 1 ? Colors.white : Colors.white.withOpacity(0.5),
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
                      pageBuilder: (context, animation, secondaryAnimation) => SplashScreen(),
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
