import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meety/screens/preLogin.dart';
import 'package:meety/screens/signUp/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.login(_email, _password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', _email);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ההתחברות נכשלה: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignupStep1Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with blur effect
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
          // Logo at the top
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/icon/MeetyLogoFull.png',
                height: 50,
              ),
            ),
          ),
          // Login form with frosted glass effect
          Positioned(
            top: 180,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Center(
                            child: Text(
                              'כניסה',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              labelText: 'שם משתמש',
                              floatingLabelAlignment: FloatingLabelAlignment.center,
                              labelStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value == null || !value.contains('@') ? 'הזן כתובת אימייל חוקית' : null,
                            onSaved: (value) => _email = value!,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              floatingLabelAlignment: FloatingLabelAlignment.center,
                              labelText: 'סיסמא',
                              labelStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                            ),
                            obscureText: true,
                            validator: (value) =>
                                value == null || value.length < 6 ? 'הסיסמא חייבת להכיל לפחות 6 תווים' : null,
                            onSaved: (value) => _password = value!,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: _submitForm,
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
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'כניסה',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward, size: 24, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("משתמש חדש?", style: TextStyle(color: Colors.white)),
                              TextButton(
                                onPressed: _navigateToSignup,
                                child: const Text(
                                  "הרשם",
                                  style: TextStyle(color: Color.fromARGB(255, 107, 197, 246)),
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 1, color: Colors.black12, height: 30),
                          const SizedBox(height: 10),
                          const Text(
                            textAlign: TextAlign.center,
                            'או התחבר באמצעות',
                            style: TextStyle(color: Color.fromARGB(221, 252, 252, 252), fontSize: 18),
                          ),
                          const SizedBox(height: 15),
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
                            const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
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
                icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(67, 198, 250, 0.845)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PreLoginScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

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
