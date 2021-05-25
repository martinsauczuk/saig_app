import 'package:flutter/material.dart';
import 'package:saig_app/src/pages/cloud_gallery_page.dart';
import 'package:saig_app/src/pages/info_page.dart';
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
      theme: Theme.of(context).copyWith(
        
        // Define the default brightness and colors.
        // brightness: Brightness.dark,
        // primaryColorBrightness: Colors.amber,
        // accentTextTheme: ,
        primaryColor: Colors.teal,
        accentColor: Colors.deepOrange,
        // iconTheme: IconTheme()
        // backgroundColor: Colors.lightGreenAccent,
      ),
      routes: {
        'upload'  :   (BuildContext context) => UploadPage(),
        'cloud'   :   (BuildContext context) => CloudGalleryPage(),
        'info'    :   (BuildContext context) => InfoPage(),
      },
      initialRoute: 'upload',
    );
  }
}