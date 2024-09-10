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
    state = state.copyWith( 
      camera                : statusArray[0],
      location              : statusArray[1],
      locationAlways        : statusArray[2],
      locationWhenInUse     : statusArray[3],
    );
    
  }

  Future<void> requestLocationCamera() async{
    await Permission.camera.request();
    await checkPermissions();
  }

  Future<void> requestLocationAccess() async{
    await Permission.location.request();
    await checkPermissions();
  }
  
  Future<void> requestLocationAlwaysAccess() async{
    await Permission.locationAlways.request();
    await checkPermissions();
  }

  Future<void> requestLocationWhenInUseAccess() async{
    await Permission.locationWhenInUse.request();
    await checkPermissions();
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

  PermissionState copyWith({
    PermissionStatus? camera,
    PermissionStatus? location,
    PermissionStatus? locationAlways,
    PermissionStatus? locationWhenInUse
  }) => PermissionState(
    camera:             camera ?? this.camera,
    location:           location ?? this.location,            
    locationAlways:     locationAlways ?? this.locationAlways,
    locationWhenInUse:  locationWhenInUse ?? this.locationWhenInUse,
  );

}