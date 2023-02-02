import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoServiceProvider extends ChangeNotifier{

  String deviceName = "";

  getDeviceInfo() async{

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if(Platform.isAndroid){

      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      print('Running on ${androidInfo.data}');  // e.g. "Moto G (4)"

      print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

      deviceName = androidInfo.model;

    }else if(Platform.isIOS){

      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      print('Running on ${iosInfo.data}');  // e.g. "iPod7,1"

      print('Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"

      deviceName = iosInfo.model!;

    }

    notifyListeners();

  }

}