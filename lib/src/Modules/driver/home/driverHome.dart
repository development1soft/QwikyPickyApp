import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:qwikypicky/constant.dart';
import 'package:qwikypicky/src/Modules/driver/authentication/login.dart';
import 'package:qwikypicky/src/Modules/driver/providers/DriverAuthenticationProvider.dart';
import 'package:qwikypicky/src/Modules/driver/providers/DriverLocationProvider.dart';
import 'package:qwikypicky/src/Modules/driver/providers/DriverProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../launch.dart';

class DriverHomeScreen extends StatefulWidget {

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();

}

class _DriverHomeScreenState extends State<DriverHomeScreen> {

  @override
  void initState() {

    super.initState();

    Provider.of<DriverLocationProvider>(context,listen: false).checkIfGpsEnabled().then((_) async{

      await Provider.of<DriverLocationProvider>(context,listen: false).checkIfLocationPermissionGranted().then((_) async{

        if((! Provider.of<DriverLocationProvider>(context,listen: false).serviceEnabled ) || (Provider.of<DriverLocationProvider>(context,listen: false).permissionGranted != PermissionStatus.granted)){

          MotionToast.error(
            title:  Text("GPS Service Or Permissions Not Granted"),
            description:  Text("Please Enable GPS Serivce and Grant Permission To Use Our Program"),
            position: MotionToastPosition.top,
          ).show(context);

        }else{

          try{

            await Provider.of<DriverLocationProvider>(context,listen: false).getLocationForFirstTime().then((responseStatus){

              if(responseStatus != 200){

                MotionToast.warning(
                  title:  Text("Internet Connection Status"),
                  description:  Text("Please Ensure From Internet Connection"),
                  position: MotionToastPosition.top,
                ).show(context);

              }

            });

          }catch(e){

            MotionToast.warning(
              title:  Text("Unexpected Error"),
              description:  Text("${e}"),
              position: MotionToastPosition.top,
            ).show(context);

          }

          await Provider.of<DriverProvider>(context,listen: false).getDriverInfo();

          if(Provider.of<DriverProvider>(context,listen: false).isOn){

            await Provider.of<DriverLocationProvider>(context,listen: false).trackDriver();

          }

        }

      });

    });

  }

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();


  @override
  Widget build(BuildContext context) {

    DriverLocationProvider driverLocationProvider = Provider.of<DriverLocationProvider>(context);

    DriverProvider driverProvider = Provider.of<DriverProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('QwikyPicky'),
        titleSpacing: 0,
        actions: [
          Switch(
            value: driverProvider.isOn,
            activeColor: Colors.green,
            activeTrackColor: Colors.greenAccent,
            inactiveThumbColor: Colors.redAccent,
            onChanged: (value) async{
              print(value);
              if(value){

                await Provider.of<DriverProvider>(context,listen: false).makeDriverOn();

                await Provider.of<DriverLocationProvider>(context,listen: false).trackDriver();

                MotionToast.info(
                  title:  Text("Attention Please"),
                  description:  Text("Your Status is On"),
                  position: MotionToastPosition.top,
                ).show(context);

              }else{

                await Provider.of<DriverProvider>(context,listen: false).makeDriverOff();

                await Provider.of<DriverLocationProvider>(context,listen: false).cancelListenToLocation();

                MotionToast.info(
                  title:  Text("Attention Please"),
                  description:  Text("Your Status is Off"),
                  position: MotionToastPosition.top,
                ).show(context);

              }
            },
          ),
        ],
        backgroundColor: Color(COLOR_PRIMARY),
      ),
      body: ((driverLocationProvider.serviceEnabled == false) || (driverLocationProvider.permissionGranted != PermissionStatus.granted)) ?  Center(
        child: Text('Please Enable GPS Serivce and Grant Permission To Use Our Program'),
      ) : (driverProvider.driverInfo.isEmpty) ? Center(
        child: CircularProgressIndicator(),
      ): Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: driverLocationProvider.driverCurrentLocation,
              zoom: 14.4746,
            ),
            markers: driverLocationProvider.markers.toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ],
      ) ,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(COLOR_PRIMARY),
              ),
              accountEmail: Text("${(driverProvider.driverInfo.isNotEmpty) ? driverProvider.driverInfo['user']['email'].toString() : '...'}"),
              accountName: Text("${(driverProvider.driverInfo.isNotEmpty) ? driverProvider.driverInfo['user']['name'] : '...'}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "${(driverProvider.driverInfo.isNotEmpty) ? driverProvider.driverInfo['user']['name'][0] : '...'}",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.logout),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Logout",style: TextStyle(fontFamily: 'Roboto')),
                  )
                ],
              ),
              onTap: () async {

                SharedPreferences prefs = await SharedPreferences.getInstance();

                await Provider.of<DriverAuthenticationProvider>(context,listen: false).logout().then((responseStatus){

                  prefs.clear();

                  Provider.of<DriverAuthenticationProvider>(context,listen: false).cleanUp(authCredentialsClean: true);

                  Provider.of<DriverLocationProvider>(context,listen: false).cleanUp();

                  Provider.of<DriverProvider>(context,listen: false).cleanUp();

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));

                  MotionToast.success(
                    title:  Text("Logout"),
                    description:  Text("You Logged Out Successfully"),
                    position: MotionToastPosition.top,
                  ).show(context);

                });


              },
            ),
          ],
        ),
      ),
    );
  }
}
