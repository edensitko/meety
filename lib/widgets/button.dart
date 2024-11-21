
import 'package:flutter/material.dart';

class GradientOutlineButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const GradientOutlineButton({super.key, required this.label, required this.onPressed});
   @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5), // Outer margin
            padding: const EdgeInsets.all(2), // Inner padding
            
            decoration: BoxDecoration(
              
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [ Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(95, 138, 248, 158),
                          ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 1, 14, 1),
              decoration: BoxDecoration(
                
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                
              ),
              child: OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      
                    ),
                  ),
                ),
              ),
              
              
            ),
          ),
        ],
      ),
    );
  }
}