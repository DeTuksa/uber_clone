import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:uber_clone/models/location_model.dart';

class PickUpLocation extends StatefulWidget {
  @override
  _PickUpLocationState createState() => _PickUpLocationState();
}

class _PickUpLocationState extends State<PickUpLocation> {

  GoogleMapController mapController;
  String pickUpSpot;
  LatLng loc;

  void updatePosition(CameraPosition position) {
    Position newPosition = Position(
      latitude: position.target.latitude,
      longitude: position.target.longitude
    );
    setState(() {
      loc = LatLng(newPosition.latitude, newPosition.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(
        builder: (context, locationModel, child) {
          pickUpSpot = locationModel.pickUpLocationInfo.name;
          loc = LatLng(
            locationModel.currentLocation.latitude,
            locationModel.currentLocation.longitude
          );

          if(locationModel.currentLocation == null)
            return Container();

      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: height(context),
              width: width(context),
            ),
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    locationModel.currentLocation.latitude,
                    locationModel.currentLocation.longitude
                  ),
                  zoom: 20.0),
              trafficEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              markers: Set<Marker>.of(
                <Marker>[
                  Marker(
                    draggable: true,
                    markerId: MarkerId("1"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure
                    ),
                    position: loc,
                    onDragEnd: ((value) {
                      setState(() {
                        loc =LatLng(
                          value.latitude, value.longitude
                        );
                      });
                      print(value.latitude);
                      print(value.longitude);
                    })
                  )
                ]
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 30, left: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height(context) * 0.3,
                width: width(context),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: height(context) * 0.02,
                          bottom: height(context) * 0.02),
                      child: Center(
                        child: Text(
                          'Set your pick-up location',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height(context) * 0.02,
                          bottom: height(context) * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                                '$pickUpSpot',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                          SizedBox(
                            width: 20,
                          ),
                          FlatButton(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {},
                            color: Colors.grey[200],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: height(context) * 0.02),
                      child: FlatButton(
                        onPressed: () {
                          //TODO
                        },
                        child: Text(
                          'CONFIRM PICK-UP',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
