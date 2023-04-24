import 'dart:math';

import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class GeoProvider {
  
  ///
  /// Get from Github
  ///
  Future<String> getExample() async {

    final namefile = 'camino_unq_01.js';

    final uri =
        Uri.https('raw.githubusercontent.com', '/martinsauczuk/plantar-geojson/main/$namefile');

    final response = await http.get(uri);
    print(response);
    return response.body;
  }

  Future<String> getJsonFile(String url) async {
    final uri = Uri.https(url);

    final response = await http.get(uri);
    print(response);
    return response.body;
  }

  ///
  /// Draw circle
  ///
  GeoJsonPolygon buildGeoJsonCircle(LatLng latLng, radiusInKm) {
    const int points = 64;

    var km = radiusInKm;

    // var ret = [];
    List<GeoPoint> geopoints = List.empty(growable: true);

    var distanceX = km / (111.320 * cos(latLng.latitude * pi / 180));
    var distanceY = km / 110.574;

    var theta, x, y;
    for (var i = 0; i < points; i++) {
      theta = (i / points) * (2 * pi);
      x = distanceX * cos(theta);
      y = distanceY * sin(theta);
// ret.push([coords.longitude+x, coords.latitude+y])
      geopoints.add(GeoPoint(latitude: latLng.latitude + y, longitude: latLng.longitude + x));
    }
    geopoints.add(geopoints[0]);

    // geopoints.add(GeoPoint(latitude: -32.0, longitude: -42.0));

    GeoSerie geoserie = GeoSerie(name: 'name', type: GeoSerieType.polygon, geoPoints: geopoints);

    GeoJsonPolygon poly = GeoJsonPolygon(geoSeries: [geoserie], name: 'aGeoserie');

    print(poly);
    // return
    //     "type": "geojson",
    //     "data": {
    //         "type": "FeatureCollection",
    //         "features": [{
    //             "type": "Feature",
    //             "geometry": {
    //                 "type": "Polygon",
    //                 "coordinates": [ret]
    //             }
    //         }]
    //     }
    // };

    return poly;
  }
}
