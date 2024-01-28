import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {

  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
          children: <Widget> [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal,
                  Colors.tealAccent
                ]
              )
            ),
            child: Column(
              children: [
                Image.asset('assets/plantapp-logo.png', height: 100, width: 100),
                RichText(
                  text: const TextSpan(
                    text: 'Plant',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w400
                    ),
                    children: <TextSpan> [
                      TextSpan(
                        text: 'Ar',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800
                        )
                      )  
                    ],
                  )
                ),
              ],
                        ), 
          ),
          ListTile(
            leading: const Icon(Icons.sync, color: Colors.cyan),
            title: const Text('Carga de imágenes'),
            onTap: () => Navigator.pushReplacementNamed(context, 'upload')
          ),
          ListTile(
            leading: const Icon(Icons.cloud, color: Colors.cyan),
            title: const Text('Contenido de la nube'),
            onTap: () => Navigator.pushReplacementNamed(context, 'cloud')
          ),
          const ListTile(
            leading: Icon(Icons.settings_remote, color: Colors.cyan),
            title: Text('Prueba de sensores'),
            // onTap: () => Navigator.pushReplacementNamed(context, 'sensors')
          ),
          ListTile(
            leading: const Icon(Icons.satellite, color: Colors.cyan),
            title: const Text('Prueba de ubicación GPS'),
            onTap: () => Navigator.pushReplacementNamed(context, 'location')
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.cyan),
            title: const Text('Prueba de cámara'),
            onTap: () => Navigator.pushReplacementNamed(context, 'camera')
          ),
          ListTile(
            leading: const Icon(Icons.volume_down_alt, color: Colors.cyan),
            title: const Text('Prueba de sonidos'),
            onTap: () => Navigator.pushReplacementNamed(context, 'sounds')
          ),
          ListTile(
            leading: const Icon(Icons.info_outlined, color: Colors.cyan),
            title: const Text('Información'),
            onTap: () => Navigator.pushReplacementNamed(context, 'info')
          ),
        ],
      )
    );
  }
}