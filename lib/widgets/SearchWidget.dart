import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to right-to-left
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),

        decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 251, 251, 251),

  //         gradient: const LinearGradient(
  //           colors: [
  //  Color.fromRGBO(67, 198, 250, 0.254),
  //                     Color.fromARGB(71, 122, 213, 139)

  //           ],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'חפש...',
            //
            hintStyle: const TextStyle(color: Color.fromARGB(255, 25, 23, 23), fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 34, 32, 32), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none, // Remove the default border
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5), // Adjust padding to make the height less
            filled: true, // Fill the container with color
            fillColor: const Color.fromARGB(0, 170, 164, 164), // Make background color transparent
          ),
        ),
      ),
    );
  }
}
