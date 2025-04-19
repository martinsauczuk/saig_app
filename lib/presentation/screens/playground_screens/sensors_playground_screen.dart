import 'package:flutter/material.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  MenuItem(this.title, this.icon, this.route);
}

final menuItems = <MenuItem> [
  MenuItem('Gyroscope', Icons.downloading, 'gyroscope'),
  MenuItem('Accelerometer', Icons.speed, 'accelerometer'),
  MenuItem('Magnetometer', Icons.explore_outlined, 'magnetometer'),
  MenuItem('Gyroscope Ball', Icons.sports_baseball_outlined, 'gyroscope-ball'),
];

class SensorsPlaygroundScreen extends StatelessWidget {
  
  const SensorsPlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de sensores')),
      drawer: const MenuWidget(),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.all(20),
        children: menuItems.map((item) => HomeMenuItem(
          title: item.title, 
          route: item.route, 
          icon: item.icon)
        ).toList(),
      )
    );
  }
}

class HomeMenuItem extends StatelessWidget {

  final String title;
  final String route;
  final IconData icon;
  final List<Color> bgColors;

  const HomeMenuItem({
    super.key, 
    required this.title,
    required this.route,
    required this.icon,
    this.bgColors = const [ Colors.lightBlue, Colors.blue ]
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(8),
        // height: 100,
        // width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: Colors.white, 
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              title, 
              textAlign: TextAlign.center, 
              style: const TextStyle(color: Colors.white, fontSize: 20)
            )
          ]
        ),
      ),
    );
  }
}

