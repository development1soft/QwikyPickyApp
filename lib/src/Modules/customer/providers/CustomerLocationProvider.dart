import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:qwikypicky/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerLocationProvider extends ChangeNotifier{

  LatLng customerCurrentLocation = LatLng(0, 0);

  bool serviceEnabled = false;

  PermissionStatus permissionGranted = PermissionStatus.denied;

  List<Marker> markers = [];

  late StreamSubscription<LocationData> locationSubscription;

  checkIfGpsEnabled() async{

    Location location = Location();

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {

      serviceEnabled = await location.requestService();

    }

    print('gps service status');

    print(serviceEnabled);

    notifyListeners();

  }

  checkIfLocationPermissionGranted() async{

    Location location = Location();

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {

      permissionGranted = await location.requestPermission();

    }

    print(permissionGranted);

    notifyListeners();

  }

  getLocationForFirstTime() async{

    Location location = Location();

    var locationData = await location.getLocation();

    customerCurrentLocation = LatLng(locationData.latitude!, locationData.longitude!);

    markers.add(
      Marker(
        markerId: MarkerId('My Location'),
        infoWindow : InfoWindow(
          title: 'My Location'
        ),
        position: LatLng(locationData.latitude!, locationData.longitude!)
      )
    );

    print(customerCurrentLocation);

    var url = "${ApiConf.API_URL}customer/track";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('api_token')}',
        },
        body: convert.jsonEncode( {
          'lat' : customerCurrentLocation.latitude.toString(),
          'lng' : customerCurrentLocation.longitude.toString(),
        }),
    );

    print('customer location sent to backend for first time');

    notifyListeners();

    return response.statusCode;

  }

  trackDriver(){

    Location location = Location();

    location.changeSettings(accuracy: LocationAccuracy.low,distanceFilter: 100);

    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) async {

      customerCurrentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);

      var url = "${ApiConf.API_URL}customer/track";

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('api_token')}',
        },
        body: convert.jsonEncode( {
          'lat' : customerCurrentLocation.latitude.toString(),
          'lng' : customerCurrentLocation.longitude.toString(),
        }),
      );

      print('customer location changed successfully ${customerCurrentLocation}');

      notifyListeners();

    });

  }

  cancelListenToLocation(){

    locationSubscription.cancel();

    print('stoppppped listen to location changes');

    notifyListeners();

  }

  cleanUp({cancelSubscription = false}){
    customerCurrentLocation = LatLng(0, 0);
    markers.clear();
    if(cancelSubscription){
      locationSubscription.cancel();
    }
    notifyListeners();
  }

}