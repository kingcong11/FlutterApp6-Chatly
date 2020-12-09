import 'package:flutter/material.dart';

/* Screens */
// import './screens/homepage_screen.dart';
import './screens/navigation_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /* Custom MaterialColor Method */
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatly',
      theme: ThemeData(
        primaryColor: Color(0xFFe71d36),
        accentColor: Color(0xFFFFFBFE), //snow
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
        fontFamily: 'Nunito',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: HomePageScreen(),
      home: NavigationScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}
