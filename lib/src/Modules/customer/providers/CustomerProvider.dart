import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerProvider extends ChangeNotifier{

  Map<String,dynamic> customerInfo = {};

  getCustomerInfo() async{

    customerInfo.clear();

    var url = "${ApiConf.API_URL}customer/info";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('api_token')}',
      }
    );

    customerInfo = Map<String,dynamic>.from(json.decode(response.body));

    notifyListeners();

  }

  cleanUp(){

    customerInfo.clear();

    notifyListeners();

  }
}