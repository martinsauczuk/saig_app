import 'package:flutter/material.dart';
import 'package:saig_app/src/pages/cloud_gallery_page.dart';
import 'package:saig_app/src/pages/upload_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAIG upload',
      debugShowCheckedModeBanner: false,
      routes: {
        // 'home'    : (BuildContext context) => HomePage(),
        // 'map'     : (BuildContext context) => MapPage(),
        'upload'  : (BuildContext context) => UploadPage(),
        'cloud' :   (BuildContext context) => CloudGalleryPage(),
      },
      initialRoute: 'upload',
    );
  }
}