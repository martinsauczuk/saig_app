import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saig_app/presentation/screens/cloud_gallery_screen.dart';
import 'package:saig_app/presentation/screens/info_screen.dart';

import 'presentation/screens/playground_screens/camera_playground_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp( MyApp(cameras: cameras,) );
}

class MyApp extends StatelessWidget {

  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantAr',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      routes: {
        // 'upload'    : (BuildContext context) => UploadPage(),
        'cloud'        : (BuildContext context) => const CloudGalleryScreen(),
        'info'         : (BuildContext context) => const InfoScreen(),
        // 'precarga'  : (BuildContext context) => OneShotingPage(cameras: cameras),
        // 'multi'     : (BuildContext context) => MultipleShotingPage(cameras: cameras),
        // 'sensors'   : (BuildContext context) => SensorsTestPage(),
        // 'location'  : (BuildContext context) => LocationTestPage(),
        // 'sounds'    : (BuildContext context) => PlaySoundTest(),
        'camera'       : (BuildContext context) => CameraPlatgroundScreen(cameras: cameras,),
        // 'routing'   : (BuildContext context) => RoutingShootingPage(cameras: cameras)
      },
      initialRoute: 'info',
    );
  }
}
