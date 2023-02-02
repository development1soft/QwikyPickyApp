import 'package:flutter/material.dart';

class DriverHomeScreen extends StatefulWidget {

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();

}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome Driver'),
      ),
    );
  }
}
