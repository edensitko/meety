import 'dart:ui';

import 'package:flutter/material.dart';


class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 92, 92, 93),
      ),
      home: Scaffold(
        body: ListView(children: [
          Settings(),
        ]),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 233, 233).withOpacity(0.2), // You can adjust the opacity here
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Blurred Background',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            )),
        const SizedBox(height: 20),

        // Add your settings widgets here
        const ListTile(
          title: Text('Settings 1'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        const ListTile(
          title: Text('Settings 2'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        const ListTile(
          title: Text('Settings 3'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}

  class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double contWidth = size.width * 0.90;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: Image.asset('assets/images/main.png').image, fit: BoxFit.cover)),
        child: Center(
          child: FrostedGlassBox(
            width: contWidth,
            height: contWidth,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "RetroPortal Studio",
                    style: TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                        
                  Text(
                    "Frosted Glass",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FrostedGlassBox extends StatelessWidget {
  final double width, height;
  final Widget child;

  const FrostedGlassBox({super.key, required this.width, required this.height, required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: 
      
      Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8.0,
                sigmaY: 8.0,
              ),
              child: Container(width: width, height: height, child: Text(" ")),
            ),
            Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/noise.png',       
                    fit: BoxFit.cover,
                  width: width,
                  height: height,
                )),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 30, offset: Offset(2, 2))],
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ])),
              child: child,
            ),
          ],
        ),
      ),

    );
  }
}
