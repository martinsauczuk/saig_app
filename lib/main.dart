import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/config/theme/app_theme.dart';
import 'package:saig_app/presentation/providers/uploads_provider.dart';
import 'package:saig_app/presentation/screens/cloud_gallery_screen.dart';
import 'package:saig_app/presentation/screens/info_screen.dart';
import 'package:saig_app/presentation/screens/playground_screens/location_playground_screen.dart';
import 'package:saig_app/presentation/screens/playground_screens/sound_playground_screen.dart';
import 'package:saig_app/presentation/screens/uploads/one_shoting_screen.dart';
import 'package:saig_app/presentation/screens/uploads/uploads_main_screen.dart';

import 'presentation/screens/playground_screens/camera_playground_screen.dart';

Future<void> main() async {

  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp( 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UploadsProvider()),
      ],
      child: MyApp(cameras: cameras),
    )
  );
}

class MyApp extends StatelessWidget {

  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantAr',
      debugShowCheckedModeBanner: true,
      theme: AppTheme().getTheme(),
      routes: {
        'upload'       : (BuildContext context) => const UploadsMainScreen(),
        'cloud'        : (BuildContext context) => CloudGalleryScreen(),
        'info'         : (BuildContext context) => const InfoScreen(),
        'one_shoting'  : (BuildContext context) => OneShotingScreen(camera: cameras.first),
        // 'multi'     : (BuildContext context) => MultipleShotingPage(cameras: cameras),
        // 'sensors'   : (BuildContext context) => SensorsTestPage(),
        'location'     : (BuildContext context) => const LocationPlaygroundScreen(),
        'sounds'       : (BuildContext context) => const SoundPlaygroundScreen(),
        'camera'       : (BuildContext context) => CameraPlatgroundScreen(cameras: cameras),
        // 'routing'   : (BuildContext context) => RoutingShootingPage(cameras: cameras)
      },
      initialRoute: 'upload',
    );
  }
}
