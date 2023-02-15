import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerAuthenticationProvider extends ChangeNotifier{

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  List availableCountriesList = [];

  Map<String,dynamic> selectedCountry = {};

  TextEditingController phoneNumberController = TextEditingController();

  Map<String,dynamic> authCredentials = {};

  String errorMessage = "";

  bool comesFromLoginPage = false;

  login(String fcmToken,String deviceName,String appLocale) async{

    var url = "${ApiConf.API_URL}customer/login";

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

  getAvailableCountries() async{

    var url = "${ApiConf.API_URL}customer/countries";
    
    var response = await http.get(Uri.parse(url));

    availableCountriesList.clear();

    availableCountriesList.addAll(json.decode(response.body));

    notifyListeners();

  }

  register(String fcmToken,String deviceName,String appLocale) async{

    var url = "${ApiConf.API_URL}customer/register";

    var response = await http.post(Uri.parse(url), body: {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'country_id': selectedCountry['id'].toString(),
      'phone_number': phoneNumberController.text,
      'device_name': deviceName,
      'fcm_token': fcmToken,
      'app_locale': appLocale
    });

    if(response.statusCode != 200){

      var jsonResponse = jsonDecode(response.body);

      errorMessage = jsonResponse['msg'];

    }

    notifyListeners();

    return response.statusCode;

  }

  logout() async{

    var url = "${ApiConf.API_URL}customer/logout";

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

  setSelectedCountry(tempCountry){

    selectedCountry = Map<String,dynamic>.from(tempCountry);

    notifyListeners();

  }

  changeComesFromLoginPage(bool val){
    comesFromLoginPage = val;
    notifyListeners();
  }

  cleanUp({authCredentialsClean = false}){
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    if(authCredentialsClean){
      authCredentials.clear();
    }
    availableCountriesList.clear();
    selectedCountry.clear();
    phoneNumberController.clear();
    errorMessage = "";
    notifyListeners();
  }

}