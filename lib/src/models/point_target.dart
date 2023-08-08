import 'package:geojson/geojson.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class PointTarget {
  
  GeoJsonPoint geojsonPoint;
  Circle circle;

  // PointTarget();
  PointTarget(this.geojsonPoint, this.circle);
}
