import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/config/theme/app_theme.dart';
import 'package:saig_app/presentation/screens/screens.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {

  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN']!);

  WakelockPlus.enable();

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
        'upload'           : (BuildContext context) => const UploadsMainScreen(),
        'cloud'            : (BuildContext context) => CloudGalleryScreen(),
        'about'            : (BuildContext context) => const AboutScreen(),

        'one_shoting'      : (BuildContext context) => const OneShotingScreen(),
        'distance_shoting' : (BuildContext context) => const DistanceShotingScreen(),

        'sounds'           : (BuildContext context) => const SoundPlaygroundScreen(),
        'camera'           : (BuildContext context) => const CameraPlaygroundScreen(),
        'permissions'      : (BuildContext context) => const PermissionsScreen(),

        // Sensors
        'sensors'          : (BuildContext context) => const SensorsPlaygroundScreen(),
        'gyroscope'        : (BuildContext context) => const GyroscopeScreen(),
        'accelerometer'    : (BuildContext context) => const AccelerometerScreen(),
        'magnetometer'     : (BuildContext context) => const MagnetometerScreen(),
        'gyroscope-ball'   : (BuildContext context) => const GyroscopeBallScreen(),

        // Location
        'location'         : (BuildContext context) => const LocationScreen(),
        'maps'             : (BuildContext context) => const MapScreen(),
        'controlled-map'   : (BuildContext context) => const ControlledMapScreen(),
      },
      initialRoute: 'upload',
    );
  }
}
