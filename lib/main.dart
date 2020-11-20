import 'package:flutter/material.dart';
import 'package:gender_detector_app/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: MainPage(),
    );
  }
}


