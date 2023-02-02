import 'package:flutter/material.dart';

class ClickServiceProvider extends ChangeNotifier{

  bool loginBtnClicked = false;

  setLoginBtnValue(bool val) {

    loginBtnClicked = val;

    notifyListeners();

  }

}