import 'package:flutter/material.dart';
import 'package:saig_app/src/pages/cloud_gallery_page.dart';
import 'package:saig_app/src/pages/info_page.dart';
import 'package:saig_app/src/pages/upload_multiple_page.dart';
import 'package:saig_app/src/pages/upload_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantApp',
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
        primaryColor: Colors.teal,
        accentColor: Colors.deepOrange,
      ),
      routes: {
        'upload'          :   (BuildContext context) => UploadPage(),
        'upload_multiple' :   (BuildContext context) => UploadMultiplePage(),
        'cloud'           :   (BuildContext context) => CloudGalleryPage(),
        'info'            :   (BuildContext context) => InfoPage(),
      },
      initialRoute: 'upload_multiple',
    );
  }
}