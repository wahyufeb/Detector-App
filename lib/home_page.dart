import 'package:flutter/material.dart';
import 'package:gender_detector_app/coming_soon_page.dart';
import 'package:gender_detector_app/components/appBarComponent.dart';
import 'package:gender_detector_app/components/cardComponent.dart';
import 'package:gender_detector_app/gender_detector_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(title: "Welcome to My App"),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          BuildCardApp(
            icon: Icons.face,
            title: "Gender Detector",
            desc:
                "Menentukan apakah kamu adalah seorang Laki-Laki atau Perempuan?",
            page: GenderDetectorPage(),
          ),
          BuildCardApp(
            icon: Icons.text_fields,
            title: "Text Recognition",
            desc: "Coming soon",
            page: ComingSoonPage(),
          ),
        ],
      ),
    );
  }
}
