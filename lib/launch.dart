import 'package:flutter/material.dart';
import 'package:qwikypicky/src/Modules/driver/authentication/login.dart';

import 'constant.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
                left: 16, top: 32, right: 16, bottom: 8),
            child: Text(
              'Say Hello To Your New App!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(COLOR_PRIMARY),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: Text(
              'You\'ve just saved a week of development and headaches.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(COLOR_PRIMARY),
                textStyle: const TextStyle(color: Colors.white),
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side:
                    const BorderSide(color: Color(COLOR_PRIMARY))),
              ),
              child: const Text(
                'Driver Login',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginPage())
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 40.0, left: 40.0, top: 20, bottom: 20),
            child: TextButton(
              child: const Text(
                'Customer Login',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(COLOR_PRIMARY)),
              ),
              onPressed: () {

              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.only(top: 12, bottom: 12),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: const BorderSide(
                      color: Color(COLOR_PRIMARY),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}