
import 'package:meety/providers/auth_provider.dart';
import 'package:meety/providers/matchProvider.dart';
import 'package:meety/providers/messageProvider.dart';
import 'package:meety/providers/userActionProvider.dart';
import 'package:meety/screens/ExploreScreen.dart';
import 'package:meety/screens/dmo.dart';
import 'package:meety/screens/home_screen.dart';
import 'package:meety/screens/login_screen.dart';
import 'package:meety/screens/meeting.dart';
import 'package:meety/screens/signUp/signup_screen.dart';
import 'package:meety/screens/theSearch.dart';
import 'package:meety/screens/splash3.dart'; 
import 'package:meety/screens/preLogin.dart';
import 'package:meety/screens/splash.dart';
import 'package:meety/screens/userProfile_screen.dart';
import 'package:meety/screens/settings_screen.dart';
import 'package:meety/providers/UnreadMessagesProvider.dart';
import 'package:meety/providers/notificationProvider.dart';
import 'package:meety/providers/requestProvider.dart';
import 'package:meety/providers/settingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UnreadMessagesProvider()),
         ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => UserActionsProvider()),

ChangeNotifierProvider(create: (_) => FriendRequestProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),


   
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Meety',
            theme: ThemeData(primarySwatch: Colors.blue , 
                    scaffoldBackgroundColor:Color.fromARGB(255, 238, 238, 238),



            ),
            
            home: FutureBuilder<bool>(
              future: authProvider.isUserLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // User is logged in or not
                  return snapshot.data == true ? const HomeScreen() : const SplashScreen();
                }
              },
            ),
            routes: {
              '/splash': (context) => const SplashScreen(), 
              '/preLogin': (context) => const PreLoginScreen(), 
              '/signup': (context) => const SignupStep1Screen(),
              '/home': (context) => const HomeScreen(),
              '/match': (context) => const MeetingsCalendarScreen(),
              '/chat': (context) => const ExploreScreen(),
              '/profile': (context) => const UserProfileScreen() ,  
              '/login': (context) => const LoginScreen(),
              '/settings': (context) => const ProfileAndSettingsScreen(),
             '/groups': (context) => const SearchScreen(),
            '/dmo': (context) => const FigmaToCodeApp(),



            },
          );
        },
      ),
    );
  }
}
