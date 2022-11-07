import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
          children: <Widget> [
          DrawerHeader(
            child: Container(
              child: Column(
                children: [
                  Image.asset('assets/plantapp-logo.png', height: 100, width: 100),
                  RichText(
                    text: TextSpan(
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
            )), 
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal,
                  Colors.tealAccent
                ] 
              )
            ),
          ),
          // Image.asset('assets/icon/icon.png'),
          ListTile(
            leading: Icon(Icons.sync, color: Colors.cyan),
            title: Text('Carga de imágenes'),
            onTap: () => Navigator.pushReplacementNamed(context, 'upload')
          ),
          ListTile(
            leading: Icon(Icons.cloud, color: Colors.cyan),
            title: Text('Contenido de la nube'),
            onTap: () => Navigator.pushReplacementNamed(context, 'cloud')
          ),
          ListTile(
            leading: Icon(Icons.settings_remote, color: Colors.cyan),
            title: Text('Prueba de sensores'),
            onTap: () => Navigator.pushReplacementNamed(context, 'sensors')
          ),
          ListTile(
            leading: Icon(Icons.satellite, color: Colors.cyan),
            title: Text('Prueba de ubicación GPS'),
            onTap: () => Navigator.pushReplacementNamed(context, 'location')
          ),
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.cyan),
            title: Text('Prueba de cámara'),
            onTap: () => Navigator.pushReplacementNamed(context, 'camera')
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.cyan),
            title: Text('Mapa y ubicación'),
            onTap: () => Navigator.pushReplacementNamed(context, 'map')
          ),
          ListTile(
            leading: Icon(Icons.info_outlined, color: Colors.cyan),
            title: Text('Información'),
            onTap: () => Navigator.pushReplacementNamed(context, 'info')
          ),
        ],
      )
    );
  }
}