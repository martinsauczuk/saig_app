import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';


class InfoPage extends StatefulWidget {
  
  @override
  _InfoPageState createState() => _InfoPageState();
  
}

class _InfoPageState extends State<InfoPage> {
  
  // PackageInfo _packageInfo = PackageInfo(
  //   appName: 'Unknown',
  //   packageName: 'Unknown',
  //   version: 'Unknown',
  //   buildNumber: 'Unknown',
  // );


  @override
  void initState() { 
    super.initState();
    // _initPackageInfo();
  
  }
  
  // Future<void> _initPackageInfo() async {
  //   final info = await PackageInfo.fromPlatform();
  //   setState(() {
  //     _packageInfo = info;
  //   });
  // }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      drawer: MenuWidget(),
      body: Container(
        margin: EdgeInsetsDirectional.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Esta aplicación forma parte del plan de trabajo del convenio de investigación y desarrollo entre la Universidad Nacional de Quilmes y la Facultad de Agronomía de la Universidad de Buenos Aires.'),
            Divider(),
            Image(image: AssetImage('assets/unq-logo.png')),
            Image(image: AssetImage('assets/fauba-logo.png')),
            Divider(),
            Column(
              children: [
                Text('Desarrollo: Ing Martin Sauczuk', style: Theme.of(context).textTheme.subtitle1 ),
                Text('martin.sauczuk@gmail.com', style: Theme.of(context).textTheme.subtitle2 ),
                // Text('Version: ${_packageInfo.version}', style: Theme.of(context).textTheme.button),
                // Text('Build: ${_packageInfo.buildNumber}', style: Theme.of(context).textTheme.button),
              ],
            )
          ]
        ),
      )
    );
  }
}