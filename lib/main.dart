import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/config/theme/app_theme.dart';
import 'package:saig_app/presentation/screens/screens.dart';

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
    // MultiProvider(
      // providers: [
        // ChangeNotifierProvider(create: (_) => UploadsProvider()),
        // ChangeNotifierProvider(create: (_) => SensorsProvider()),
      // ],
      // child: MainApp(cameras: cameras),
    // )
    ProviderScope(
      child: MainApp(cameras: cameras)
    )
  );
}

class MainApp extends StatelessWidget {

  final List<CameraDescription> cameras;
  const MainApp({super.key, required this.cameras});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantAr',
      debugShowCheckedModeBanner: true,
      theme: AppTheme().getTheme(),
      routes: {
        'upload'       : (BuildContext context) => const UploadsMainScreen(),
        'cloud'        : (BuildContext context) => CloudGalleryScreen(),
        'about'        : (BuildContext context) => const AboutScreen(),
        'one_shoting'  : (BuildContext context) => OneShotingScreen(camera: cameras.first),
        // 'multi'     : (BuildContext context) => MultipleShotingPage(cameras: cameras),
        'sensors'      : (BuildContext context) => const SensorsPlaygroundScreen(),
        'location'     : (BuildContext context) => const LocationPlaygroundScreen(),
        'sounds'       : (BuildContext context) => const SoundPlaygroundScreen(),
        'camera'       : (BuildContext context) => CameraPlaygroundScreen(cameras: cameras),
        'permissions'  : (BuildContext context) => const PermissionsScreen(),
        // 'routing'   : (BuildContext context) => RoutingShootingPage(cameras: cameras)
      },
      initialRoute: 'upload',
    );
  }
}
