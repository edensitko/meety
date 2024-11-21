import 'dart:io';
import 'dart:ui';
import 'package:meety/screens/login_screen.dart';
import 'package:meety/screens/preLogin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meety/screens/splash.dart';
import 'package:meety/screens/splash2.dart';
import 'package:meety/screens/splash3.dart';

class SignupStep1Screen extends StatefulWidget {
  const SignupStep1Screen({super.key});

  @override
  _SignupWizardScreenState createState() => _SignupWizardScreenState();
}

class _SignupWizardScreenState extends State<SignupStep1Screen> {
  final _formKey = GlobalKey<FormState>();
 late PageController _pageController;

  int _currentStep = 0;
  String _name = '';
  String _email = '';
  String _location = '';
  String _accountType = '';
  String _password = '';
  File? _image;

  List<String> _selectedInterests = [];
  bool _isFormValid = false;

  final List<String> _allInterests = [
    'ספורט', 'מוזיקה', 'טכנולוגיה', 'בישול', 'אומנות',
    'טיולים', 'קריאה', 'צילום', 'מדעים',
  ];

  void _updateFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _isFormValid = isValid && _accountType.isNotEmpty && _selectedInterests.isNotEmpty && _password.isNotEmpty;
    });
  }

  void _continue() {
    if (_isStepValid(_currentStep) && _currentStep < 4) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

   Future<void> _submitForm(BuildContext context) async {
    if (_isFormValid) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        String imageUrl = await _uploadImage(_image!);

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': _name,
          'email': _email,
          'location': _location,
          'accountType': _accountType,
          'interests': _selectedInterests,
          'profileImage': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print('Signup error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $e')),
        );
      }
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('user_images/${image.path.split('/').last}');
      UploadTask uploadTask = ref.putFile(image);
      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        return _name.isNotEmpty && _email.isNotEmpty;
      case 1:
        return _location.isNotEmpty;
      case 2:
        return _accountType.isNotEmpty;
      case 3:
        return _selectedInterests.isNotEmpty;
      case 4:
        return _password.isNotEmpty;
      default:
        return false;
    }
  }

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
      )
    );
  }
}

class SignupContent extends StatefulWidget {
final PageController pageController;
  SignupContent({super.key, required this.pageController});

  @override
  _SignupContentState createState() => _SignupContentState();
}

class _SignupContentState extends State<SignupContent> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  String _name = '';
  String _email = '';
  String _location = '';
  String _accountType = '';
  String _password = '';
  File? _image;
  List<String> _selectedInterests = [];
  bool _isFormValid = false;

  Future<void> _submitForm(BuildContext context) async {
    if (_isFormValid) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        String imageUrl = await _uploadImage(_image!);

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': _name,
          'email': _email,
          'location': _location,
          'accountType': _accountType,
          'interests': _selectedInterests,
          'profileImage': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print('Signup error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $e')),
        );
      }
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('user_images/${image.path.split('/').last}');
      UploadTask uploadTask = ref.putFile(image);
      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
void _updateFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _isFormValid = isValid && _accountType.isNotEmpty && _selectedInterests.isNotEmpty && _password.isNotEmpty;
    });
  }
   void _continue() {
    if (_isStepValid(_currentStep) && _currentStep < 4) {
      setState(() {
        _currentStep += 1;
      });
    }
  }
 void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }
bool _isStepValid(int step) {
    switch (step) {
      case 0:
        return _name.isNotEmpty && _email.isNotEmpty;
      case 1:
        return _location.isNotEmpty;
      case 2:
        return _accountType.isNotEmpty;
      case 3:
        return _selectedInterests.isNotEmpty;
      case 4:
        return _password.isNotEmpty;
      default:
        return false;
    }
  }
 Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/green.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
                ),
              ),
            ),
          ),
          // Blurred container with form inside
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            bottom: 20,
            child: ClipRRect(
 borderRadius: const BorderRadius.all(
      Radius.circular(50),
    ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                    child: Image.asset(
                      'assets/noise.png',
                      fit: BoxFit.cover,

                    ),

                  ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      onChanged: _updateFormValidity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'הרשמה',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 251, 249, 249),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Stepper(
                            type: StepperType.vertical,
                            currentStep: _currentStep,
                            onStepContinue: _continue,
                            onStepCancel: _cancel,
                            steps: _buildSteps(),
                            controlsBuilder: (context, details) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: _isStepValid(_currentStep) ? details.onStepContinue : null,
                                    child: const Text('הבא'),
                                  ),
                                  if (_currentStep > 0)
                                    TextButton(
                                      onPressed: details.onStepCancel,
                                      child: const Text('חזור'),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: _isFormValid ? () => _submitForm(context) : null,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: _isFormValid
                                      ? [const Color(0xFF42A5F5), const Color.fromARGB(255, 206, 138, 248)]
                                      : [Colors.grey, Colors.grey],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                  icon: const Icon(Icons.arrow_back, color:   Color.fromRGBO(67, 198, 250, 0.513),),
                onPressed:
                    () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PreLoginScreen())),
              ),
            ),
          ),
         
        ],
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      _buildStep(0, 'פרטים אישיים', Icons.person, ),
      _buildStep(1, 'מיקום וטלפון', Icons.location_on),
      _buildStep(2, 'סוג חשבון', Icons.account_circle),
      _buildStep(3, 'תחומי עניין', Icons.favorite),
      _buildStep(4, 'סיסמא', Icons.password),
    ];
  }

  Step _buildStep(int step, String title, IconData icon) {
    return Step(
      title: Row(
        children: [
          Icon(icon, color: _getStepColor(step), size: 20),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: _getStepColor(step))),
        ],
      ),
      isActive: _currentStep >= step,
      state: _currentStep > step ? StepState.complete : StepState.indexed,
      content: _buildStepContent(step),
    );
  }

  Color _getStepColor(int step) {
    return _currentStep > step ? Colors.green : Colors.white;
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return Column(
          
          children: [
            _buildTextField('שם מלא', (value) {
              _name = value;
              _updateFormValidity();
              
            }),
            _buildTextField('אימייל', (value) {
              _email = value;
              _updateFormValidity();
            }, keyboardType: TextInputType.emailAddress),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload Image'),
            ),
            if (_image != null) Image.file(_image!),
          ],
        );
      case 1:
        return Column(
          children: [
            _buildTextField('מיקום', (value) {
              _location = value;
              _updateFormValidity();
            }),
            _buildTextField('מספר טלפון', (value) {}, keyboardType: TextInputType.phone),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildRadioTile('מורה', 'מורה'),
            _buildRadioTile('תלמיד', 'תלמיד'),
          ],
        );
      case 3:
        return Column(
          children: [
            if (_selectedInterests.isNotEmpty)
              Wrap(
                spacing: 8.0,
                children: _selectedInterests.map((interest) {
                  return Chip(
                    label: Text(interest),
                    onDeleted: () {
                      setState(() {
                        _selectedInterests.remove(interest);
                        _updateFormValidity();
                      });
                    },
                  );
                }).toList(),
              ),
           
          ],
        );

              
      case 4:
        return Column(
          children: [
            _buildTextField('סיסמא', (value) {
              _password = value;
              _updateFormValidity();
            }),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white , fontSize: 14) ,
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white)),
          focusColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromARGB(255, 148, 195, 244))),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white)),
        ),
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? 'שדה חובה' : null,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRadioTile(String title, String value) {
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: value,
        groupValue: _accountType,
        onChanged: (val) {
          setState(() {
            _accountType = val!;
            _updateFormValidity();
          });
        },
      ),
    );
  }
}

class InterestSelectionDialog extends StatelessWidget {
  final List<String> allInterests;
  final List<String> selectedInterests;

  const InterestSelectionDialog({super.key, required this.allInterests, required this.selectedInterests});

  @override
  Widget build(BuildContext context) {
    List<String> tempSelected = List.from(selectedInterests);
    return AlertDialog(
      title: const Text('בחר תחומי עניין'),
      content: SingleChildScrollView(
        child: Column(
          children: allInterests.map((interest) {
            return CheckboxListTile(
              title: Text(interest),
              value: tempSelected.contains(interest),
              onChanged: (bool? value) {
                if (value == true) {
                  tempSelected.add(interest);
                } else {
                  tempSelected.remove(interest);
                }
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ביטול'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(tempSelected),
          child: const Text('אישור'),
        ),
      ],
    );
  }
}
