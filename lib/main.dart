import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/config/theme/app_theme.dart';
import 'package:saig_app/presentation/screens/screens.dart';

Future<void> main() async {

  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp( 
    const ProviderScope(
      child: MainApp()
    )
  );
}

class MainApp extends StatelessWidget {

  const MainApp({super.key});

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
        'one_shoting'  : (BuildContext context) => const OneShotingScreen(),
        // 'multi'     : (BuildContext context) => MultipleShotingPage(cameras: cameras),
        'location'     : (BuildContext context) => const LocationPlaygroundScreen(),
        'sounds'       : (BuildContext context) => const SoundPlaygroundScreen(),
        'camera'       : (BuildContext context) => const CameraPlaygroundScreen(),
        'permissions'  : (BuildContext context) => const PermissionsScreen(),

        // Sensors
        'sensors'       : (BuildContext context) => const SensorsPlaygroundScreen(),
        'gyroscope'     : (BuildContext context) => const GyroscopeScreen(),
        'accelerometer' : (BuildContext context) => const AccelerometerScreen(),
        'magnetometer'  : (BuildContext context) => const MagnetometerScreen(),
        'gyroscope-ball': (BuildContext context) => const GyroscopeBallScreen(),
        'compass'       : (BuildContext context) => const CompassScreen(),

        // 'routing'   : (BuildContext context) => RoutingShootingPage(cameras: cameras)
      },
      initialRoute: 'upload',
    );
  }
}
