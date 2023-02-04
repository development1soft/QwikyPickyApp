import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverProvider extends ChangeNotifier{

  Map<String,dynamic> driverInfo = {};

  bool isOn = false;

  getDriverInfo() async{

    driverInfo.clear();

    var url = "${ApiConf.API_URL}driver/info";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('api_token')}',
      }
    );

    driverInfo = Map<String,dynamic>.from(json.decode(response.body));

    print(driverInfo['user']['driver']['is_busy']);

    if(driverInfo['user']['driver']['is_busy'] == 1){

      isOn = false;

    }else{

      isOn = true;

    }

    notifyListeners();

  }

  makeDriverOff() async{

    var url = "${ApiConf.API_URL}driver/busy";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('api_token')}',
        }
    );

    print(Map<String,dynamic>.from(json.decode(response.body))['is_busy']);

    if(Map<String,dynamic>.from(json.decode(response.body))['is_busy'] == 1){

      isOn = false;

    }else{

      isOn = true;

    }

    notifyListeners();

  }

  makeDriverOn() async{

    var url = "${ApiConf.API_URL}driver/available";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('api_token')}',
        }
    );

    print(Map<String,dynamic>.from(json.decode(response.body))['is_busy']);

    if(Map<String,dynamic>.from(json.decode(response.body))['is_busy'] == 1){

      isOn = false;

    }else{

      isOn = true;

    }

    notifyListeners();

  }

  cleanUp(){

    driverInfo.clear();

    isOn = false;

    notifyListeners();

  }
}