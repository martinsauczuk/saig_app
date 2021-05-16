import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
          children: <Widget> [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'SAIG App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          
          ListTile(
            leading: Icon(Icons.sync, color: Colors.pink),
            title: Text('Carga de imágenes'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'upload');
            },
          ),
          
          ListTile(
            leading: Icon(Icons.cloud, color: Colors.pink),
            title: Text('Contenido de la nube'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'cloud');
            },
          ),
          
          // ListTile(
          //   leading: Icon(Icons.settings, color: Colors.blue),
          //   title: Text('Settings'),
          //   onTap: () => Navigator.pushReplacementNamed(context, SettingsPage.routeName),
          // ),

        ],
      )
    );
  }
}