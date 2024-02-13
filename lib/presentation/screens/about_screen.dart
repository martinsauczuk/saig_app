import 'package:flutter/material.dart';
import 'package:saig_app/presentation/widgets/shared/menu_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información'),
      ),
      drawer: const MenuWidget(),
      body: Container(
        margin: const EdgeInsetsDirectional.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Esta aplicación forma parte del plan de trabajo del convenio de investigación y desarrollo entre la Universidad Nacional de Quilmes y la Facultad de Agronomía de la Universidad de Buenos Aires.'),
            const Divider(),
            const Image(image: AssetImage('assets/unq-logo.png')),
            const Image(image: AssetImage('assets/fauba-logo.png')),
            const Divider(),
            Column(
              children: [
                const Text('Desarrollo: Ing Martin Sauczuk' ),
                const Text('martin.sauczuk@gmail.com'),
                Text('Version: ${_packageInfo.version}'),
                Text('Build: ${_packageInfo.buildNumber}'),
              ],
            )
          ]
        ),
      )
    );
  }
}