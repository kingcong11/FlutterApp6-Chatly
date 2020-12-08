import 'package:flutter/material.dart';

/* Screens */
import './screens/homepage_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: HomePageScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
