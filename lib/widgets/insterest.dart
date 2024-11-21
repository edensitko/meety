import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterestSelectionWidget extends StatelessWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onInterestChanged;
  final VoidCallback onSelectMore;

  const InterestSelectionWidget({super.key, 
    required this.selectedInterests,
    required this.onInterestChanged,
    required this.onSelectMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onSelectMore,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:const Color(0xFF0CC0DF),
          ),
          child: const Text('בחר תחומי עניין'),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.end,
          children: selectedInterests.map((interest) {
            return Chip(
              label: Text(
                interest,
                textDirection: TextDirection.rtl,
              ),
              backgroundColor: const Color.fromARGB(255, 189, 188, 188),
              labelStyle: const TextStyle(color: Color.fromARGB(255, 8, 0, 0)),
              onDeleted: () {
                final updatedInterests = List<String>.from(selectedInterests);
                updatedInterests.remove(interest);
                onInterestChanged(updatedInterests);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class InterestSelectionScreen extends StatefulWidget {
  final List<String> initiallySelectedInterests;

  const InterestSelectionScreen({super.key, 
    required this.initiallySelectedInterests,
  });

  @override
  _InterestSelectionScreenState createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  List<String> _selectedInterests = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedInterests = List<String>.from(widget.initiallySelectedInterests);
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  Future<void> _saveInterests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('email');

      if (userEmail != null) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = userSnapshot.docs.first;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userDoc.id)
              .collection('settings')
              .doc('preferences')
              .update({'interests': _selectedInterests});
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save interests. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('בחר תחומי עניין'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: _availableInterests.length,
                        itemBuilder: (context, index) {
                          final interest = _availableInterests[index];
                          final isSelected =
                              _selectedInterests.contains(interest['name']);

                          return GestureDetector(
                            onTap: () => _toggleInterest(interest['name']!),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF0CC0DF)
                                      : Colors.transparent,
                                  width: 4,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color:const Color(0xFF0CC0DF).withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      interest['image']!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: isSelected
                                          ? Colors.grey.withOpacity(0.5)
                                          : null,
                                      colorBlendMode: isSelected
                                          ? BlendMode.darken
                                          : null,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 5),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 190, 243, 200),
                          Color.fromARGB(251, 196, 177, 234),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          interest['name']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await _saveInterests();
                        Navigator.of(context).pop(_selectedInterests);
                      },
                      child: const Text('שמור שינויים'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  final List<Map<String, String>> _availableInterests = [
    {'name': 'ספורט וכושר', 'image': 'assets/images/interest/sport.png'},
    {'name': 'אוכל ובישולים', 'image': 'assets/images/interest/food.png'},
    {'name': 'סרטים וטלוויזיה', 'image': 'assets/images/interest/movie.png'},
    {'name': 'נסיעות והרפתקאות', 'image': 'assets/images/interest/travel.png'},
    {'name': 'אומנות ויצירה', 'image': 'assets/images/interest/paint.png'},
    {'name': 'משחקים וגיימינג', 'image': 'assets/images/interest/gaming.png'},
    {'name': 'קריאה וספרים', 'image': 'assets/images/interest/read.png'},
    {'name': 'טבע וסביבה', 'image': 'assets/images/interest/nature.png'},
    {'name': 'אופנה ועיצוב', 'image': 'assets/images/interest/style.png'},
    {'name': 'השקעות ופיננסים', 'image': 'assets/images/interest/financial.png'},
    {'name': 'אסטרונומיה וחלל', 'image': 'assets/images/interest/space.png'},
    {'name': 'בעלי חיים וחיות מחמד', 'image': 'assets/images/interest/pets.png'},
    {'name': 'מדע וטכנולוגיה', 'image': 'assets/images/interest/science.png'},
    {'name': 'פוליטיקה וחדשות', 'image': 'assets/images/interest/politics.png'},
    {'name': 'פילוסופיה והיסטוריה', 'image': 'assets/images/interest/phy.png'},
    {'name': 'מוזיקה ושירה', 'image': 'assets/images/interest/music.png'},
    {'name': 'ים וספורט ימי', 'image': 'assets/images/interest/sea.png'},
    {'name': 'שינה', 'image': 'assets/images/interest/sleep.png'},
  ];
}
