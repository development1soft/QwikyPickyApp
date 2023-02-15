import 'package:flutter/material.dart';

class ClickServiceProvider extends ChangeNotifier{

  bool loginBtnClicked = false;

  bool customerLoginBtnClicked = false;

  bool customerRegisterBtnClicked = false;

  setLoginBtnValue(bool val) {

    loginBtnClicked = val;

    notifyListeners();

  }

  setCustomerLoginBtnClicked(bool val) {

    customerLoginBtnClicked = val;

    notifyListeners();

  }

  setCustomerRegisterBtnClicked(bool val) {

    customerRegisterBtnClicked = val;

    notifyListeners();

  }

}