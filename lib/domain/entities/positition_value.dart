
import 'package:flutter/material.dart';

@immutable
class PositionValue {

  final double lat;
  final double lng;
  final double accuracy;
  final double heading;
  final double altitude;
  final double speed;
  final double speedAccuracy;
  final String timestamp;

  const PositionValue({
    required this.lat,
    required this.lng,
    required this.accuracy,
    required this.heading,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'lat: $lat lng: $lng';
  }

  factory PositionValue.fromMap( Map<String, dynamic> map ) {
    return PositionValue(
      lat: map['lat'], 
      lng: map['lng'], 
      accuracy: map['accuracy'], 
      heading: map['heading'], 
      altitude: map['altitude'], 
      speed: map['speed'], 
      speedAccuracy: map['speedAccuracy'], 
      timestamp: map['timestamp']
    );
  }


}