import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:qwikypicky/src/Modules/customer/providers/CustomerAuthenticationProvider.dart';
import 'package:qwikypicky/src/Modules/customer/providers/CustomerLocationProvider.dart';
import 'package:qwikypicky/src/Modules/customer/providers/CustomerProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant.dart';
import '../../../../launch.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<CustomerLocationProvider>(context,listen: false).checkIfGpsEnabled().then((_) async{

      await Provider.of<CustomerLocationProvider>(context,listen: false).checkIfLocationPermissionGranted().then((_) async{

        if((! Provider.of<CustomerLocationProvider>(context,listen: false).serviceEnabled ) || (Provider.of<CustomerLocationProvider>(context,listen: false).permissionGranted != PermissionStatus.granted)){

          MotionToast.error(
            title:  Text("GPS Service Or Permissions Not Granted"),
            description:  Text("Please Enable GPS Serivce and Grant Permission To Use Our Program"),
            position: MotionToastPosition.top,
          ).show(context);

        }else{

          try{

            await Provider.of<CustomerLocationProvider>(context,listen: false).getLocationForFirstTime().then((responseStatus){

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

          await Provider.of<CustomerProvider>(context,listen: false).getCustomerInfo();


        }

      });

    });

  }

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();


  @override
  Widget build(BuildContext context) {

    CustomerLocationProvider customerLocationProvider = Provider.of<CustomerLocationProvider>(context);

    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('QwikyPicky'),
        titleSpacing: 0,
        backgroundColor: Color(COLOR_PRIMARY),
      ),
      body: ((customerLocationProvider.serviceEnabled == false) || (customerLocationProvider.permissionGranted != PermissionStatus.granted)) ?  Center(
        child: Text('Please Enable GPS Serivce and Grant Permission To Use Our Program'),
      ) : (customerProvider.customerInfo.isEmpty) ? Center(
        child: CircularProgressIndicator(),
      ): Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: customerLocationProvider.customerCurrentLocation,
              zoom: 14.4746,
            ),
            markers: customerLocationProvider.markers.toSet(),
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
              accountEmail: Text("${(customerProvider.customerInfo.isNotEmpty) ? customerProvider.customerInfo['user']['email'].toString() : '...'}"),
              accountName: Text("${(customerProvider.customerInfo.isNotEmpty) ? customerProvider.customerInfo['user']['name'] : '...'}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "${(customerProvider.customerInfo.isNotEmpty) ? customerProvider.customerInfo['user']['name'][0] : '...'}",
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

                await Provider.of<CustomerAuthenticationProvider>(context,listen: false).logout().then((responseStatus){

                  prefs.clear();

                  Provider.of<CustomerAuthenticationProvider>(context,listen: false).cleanUp(authCredentialsClean: true);

                  Provider.of<CustomerLocationProvider>(context,listen: false).cleanUp();

                  Provider.of<CustomerProvider>(context,listen: false).cleanUp();

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
