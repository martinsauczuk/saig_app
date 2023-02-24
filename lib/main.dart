import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/src/pages/multiple_shoting_page.dart';
import 'package:saig_app/src/providers/sensors_provider.dart';
import 'package:saig_app/src/test_pages/camera_test.dart';
import 'package:saig_app/src/pages/cloud_gallery_page.dart';
import 'package:saig_app/src/pages/info_page.dart';
import 'package:saig_app/src/test_pages/location_test.dart';
import 'package:saig_app/src/test_pages/map_test.dart';
import 'package:saig_app/src/pages/one_shoting_page.dart';
import 'package:saig_app/src/test_pages/sensors_test.dart';
import 'package:saig_app/src/pages/upload_page.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';

void main() async {
  
  await dotenv.load(fileName: ".env");

  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
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
        ChangeNotifierProvider(create: (_) => SensorsProvider()),
      ],
      child: MyApp(cameras: cameras),
    ),
  );
}

class MyApp extends StatelessWidget {

  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UploadsProvider())
      ],
      child: MaterialApp(
        title: 'PlantAr',
        debugShowCheckedModeBanner: true,
        theme: Theme.of(context).copyWith(
          primaryColor: Colors.teal,
          accentColor: Colors.deepOrange,
        ),
        routes: {
          'upload'    : (BuildContext context) => UploadPage(),
          'cloud'     : (BuildContext context) => CloudGalleryPage(),
          'info'      : (BuildContext context) => InfoPage(),
          'precarga'  : (BuildContext context) => OneShotingPage(cameras: cameras),
          'multi'     : (BuildContext context) => MultipleShotingPage(cameras: cameras),
          'sensors'   : (BuildContext context) => SensorsTestPage(),
          'location'  : (BuildContext context) => LocationTestPage(),
          'camera'    : (BuildContext context) => CameraTestPage(cameras: cameras),
          'map'       : (BuildContext context) => MapTestPage()
        },
        initialRoute: 'upload',
      ),
    );
  }
}
