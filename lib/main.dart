import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/src/pages/cloud_gallery_page.dart';
import 'package:saig_app/src/pages/info_page.dart';
import 'package:saig_app/src/pages/precarga_page.dart';
import 'package:saig_app/src/pages/upload_page.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UploadsProvider()),
      ],
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UploadsProvider() )
      ],
      child: MaterialApp(
        title: 'PlantApp',
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context).copyWith(
          primaryColor: Colors.teal,
          accentColor: Colors.deepOrange,
        ),
        routes: {
          'upload'          :   (BuildContext context) => UploadPage(),
          'cloud'           :   (BuildContext context) => CloudGalleryPage(),
          'info'            :   (BuildContext context) => InfoPage(),
          'precarga'        :   (BuildContext context) => PrecargaPage(),
        },
        initialRoute: 'upload',
      ),
    );
  }
}