import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart' ;
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:http/http.dart' as http;


class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  LatLng? destLocation = const LatLng(25.2048, 55.2708);
  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  String? _address;
  TextEditingController searchController = TextEditingController();
  List<dynamic> predictions = [];
  LatLng selectedLocation = const LatLng(37.7749, -122.4194);
  String apiKey = 'AIzaSyDvTeGBMZwiNI1acJ-biduXVem8XTS26Uw';

  GoogleMapController? mapController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.appColor,
          child: const Icon(Icons.navigate_next, color: Colors.white,),
          onPressed: () {
            final RegExp locationPattern = RegExp(r'^.+,.+$');

            // Check if the location matches the pattern
            if (!locationPattern.hasMatch(searchController.text)) {
              showSnackBar(context, 'Please enter full location.');

            } else {
              Navigator.of(context).pop(searchController.text);

            }

          }),
      body: Stack(
        children: [
          if(destLocation != null)
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: destLocation!,
              zoom: 16,
            ),
            onCameraMove: (CameraPosition? position) {
              if (destLocation != position!.target) {
                setState(() {
                  destLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              print('camera idle');
              getAddressFromLatLng();
            },
            onTap: (latLng) {
              print(latLng);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Image.asset(
                'assets/images/pick.png',
                height: 45,
                width: 45,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child:  Column(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Google Maps',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 12.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(predictions.isNotEmpty ? 8 : 32.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                predictions = [];
                              });
                            },
                          ),
                        ),
                        onChanged: onSearchTextChanged,
                      ),
                    ),
                    if(predictions.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(
                              predictions[index]['description'],
                              style: const TextStyle(color: Colors.black, fontSize: 14.0),
                            ),
                            // subtitle: Text(
                            //   predictions[index]['description'],
                            //   style: TextStyle(fontSize: 12.0),
                            // ),
                            onTap: () {
                              fetchPlaceDetails(predictions[index]['place_id']);
                              setState(() {
                                searchController.text = predictions[index]['description'];
                                predictions = [];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        predictions = [];
      });
    }

    else {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=$apiKey',
        ),
      );


      if (response.statusCode == 200) {
        setState(() {
          predictions = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    }
  }

  void fetchPlaceDetails(String placeId) async {


    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final placeDetails = json.decode(response.body)['result'];
      final location = placeDetails['geometry']['location'];
      setState(() {
        selectedLocation = LatLng(location['lat'], location['lng']);
        getLocation(location['lat'], location['lng']);
      });
    } else {
      throw Exception('Failed to load place details');
    }
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
           destLocation!.latitude,
           destLocation!.longitude,
          );

      searchController.text = buildAddress(placeMarks);
      setState(() {
        predictions = [];
      });
    } catch (e) {
      print(e);
    }
  }
  String buildAddress(List<Placemark> placeMarks) {
    String address = "";
    if (placeMarks[0].subLocality != null && placeMarks[0].subLocality!.isNotEmpty) {
      address += "${placeMarks[0].subLocality!}, ";
    }
    if (placeMarks[0].subAdministrativeArea != null && placeMarks[0].subAdministrativeArea!.isNotEmpty) {
      address += "${placeMarks[0].subAdministrativeArea!.replaceAll(' City', '')}, ";
    }
    if (placeMarks[0].administrativeArea != null && placeMarks[0].administrativeArea!.isNotEmpty) {
      address += "${placeMarks[0].administrativeArea}, ";
    }
    if (placeMarks[0].country != null && placeMarks[0].country!.isNotEmpty) {
      address += "${placeMarks[0].country}.";
    }

    // Remove trailing comma and space if present
    if (address.endsWith(", ")) {
      address = address.substring(0, address.length - 2);
    }

    return address;
  }
  getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    final GoogleMapController? controller = await _controller.future;

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (permissionGranted == loc.PermissionStatus.granted) {
      location.changeSettings(accuracy: loc.LocationAccuracy.high);

      _currentPosition = await location.getLocation();
      controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
        zoom: 16,
      )));
      setState(() {
        destLocation =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      });
    }
  }

  getLocation(double latitude, double longitude) async {

    final GoogleMapController? controller = await _controller.future;

      controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(latitude, longitude),
        zoom: 16,
      )));
      setState(() {
        destLocation =
            LatLng(latitude, longitude);
      });

  }
}