import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverAuthenticationProvider extends ChangeNotifier{

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Map<String,dynamic> authCredentials = {};

  String errorMessage = "";

  bool comesFromLoginPage = false;

  login(String fcmToken,String deviceName,String appLocale) async{

    var url = "${ApiConf.API_URL}driver/login";

    var response = await http.post(Uri.parse(url), body: {
      'email': emailController.text,
      'password': passwordController.text,
      'device_name': deviceName,
      'fcm_token': fcmToken,
      'app_locale': appLocale
    });

    if(response.statusCode == 200)
    {

      authCredentials = Map<String,dynamic>.from(json.decode(response.body));

      notifyListeners();

    }else{

      var jsonResponse = jsonDecode(response.body);

      errorMessage = jsonResponse['msg'];

      notifyListeners();

    }
  }

  logout() async{

    var url = "${ApiConf.API_URL}driver/logout";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('api_token')}',
        }
    );

    return response.statusCode;

  }

  changeComesFromLoginPage(bool val){
    comesFromLoginPage = val;
    notifyListeners();
  }

  cleanUp({authCredentialsClean = false}){
    emailController.clear();
    passwordController.clear();
    if(authCredentialsClean){
      authCredentials.clear();
    }
    errorMessage = "";
    notifyListeners();
  }



}