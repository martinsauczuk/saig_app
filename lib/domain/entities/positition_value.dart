
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

}