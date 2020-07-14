import 'package:polyline/polyline.dart' as poly;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class PolylineApi {
  List<Polyline> polyLines = new List();
  static Future<List<LatLng>> getPolyLines(LatLng pickUp, LatLng dropOff) async {
    poly.Polyline polyline;
    final response = await http.get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${pickUp.latitude},${pickUp.longitude}'
            '&destination=${dropOff.latitude},${dropOff.longitude}&key=AIzaSyDS1Eq6__8-Cfb1_vizG1w9jPza8gkjhvI'
    );
    if(response.statusCode == 200) {
      print(
          json.decode(response.body)['routes'][0]['overview_polylines']['points']
      );
      polyline = poly.Polyline.Decode(
          precision: 5,
          encodedString: json
              .decode(response.body)['routes'][0]['overview_polylines']['points']
      );
      return coordinatesConverter(polyline);
    } else {
      print('Bla bla');
      return null;
    }
  }

  static List<LatLng> coordinatesConverter(poly.Polyline polyline) {
    var points = polyline.decodedCoords;
    List<LatLng> coordinates = new List();
    points.forEach((element) {
      coordinates.add(LatLng(element[0], element[1]));
    });

    return coordinates;
  }

}