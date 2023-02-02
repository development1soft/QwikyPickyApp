import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwikypicky/launch.dart';
import 'package:qwikypicky/src/Modules/driver/home/driverHome.dart';
import 'package:qwikypicky/src/Modules/driver/providers/DriverAuthenticationProvider.dart';
import 'package:qwikypicky/src/Services/ClickServiceProvider.dart';
import 'package:qwikypicky/src/Services/DeviceInfoServiceProvider.dart';
import 'package:qwikypicky/src/Services/FirebaseMessagingServiceProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();

  bool? loggedIn = (preferences.containsKey('loggedIn')) ? preferences.getBool('loggedIn') : false;

  bool? driverLoggedIn = (preferences.containsKey('driverLoggedIn')) ? preferences.getBool('driverLoggedIn') : false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DeviceInfoServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseMessagingServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClickServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DriverAuthenticationProvider(),
        ),
      ],
      child: MyApp(loggedIn,driverLoggedIn),
    )
  );
}

class MyApp extends StatefulWidget {

  final bool? loggedIn;

  final bool? driverLoggedIn;

  MyApp(this.loggedIn,this.driverLoggedIn);

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    super.initState();

    Provider.of<DeviceInfoServiceProvider>(context,listen: false).getDeviceInfo();

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QwikyPicky',
      debugShowCheckedModeBanner: false,
      home: (widget.loggedIn!) ? (widget.driverLoggedIn!) ? DriverHomeScreen() : Center(
        child: Text('customer logged In'),
      ) : WelcomeScreen(),
    );
  }
}

