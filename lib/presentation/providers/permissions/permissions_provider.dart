import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionsProvider = StateNotifierProvider<PermissionNotifier, PermissionState>((ref) {
  return PermissionNotifier(); 
});


class PermissionNotifier extends StateNotifier<PermissionState> {
  
  PermissionNotifier(): super( PermissionState() ) {
    checkPermissions();
  }
  
  Future<void> checkPermissions() async {
    final statusArray = await Future.wait([
      Permission.camera.status,
      Permission.location.status,
      Permission.locationAlways.status,
      Permission.locationWhenInUse.status,
    ]);
    state = PermissionState( 
      camera                : statusArray[0],
      location              : statusArray[1],
      locationAlways        : statusArray[2],
      locationWhenInUse     : statusArray[3],
    );
  }


}

class PermissionState {

  final PermissionStatus camera;
  final PermissionStatus location;
  final PermissionStatus locationAlways;
  final PermissionStatus locationWhenInUse;

  PermissionState({
    this.camera             = PermissionStatus.denied,
    this.location           = PermissionStatus.denied,
    this.locationAlways     = PermissionStatus.denied,
    this.locationWhenInUse  = PermissionStatus.denied,
  });


}