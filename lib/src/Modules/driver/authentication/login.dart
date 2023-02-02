import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:qwikypicky/src/Modules/driver/home/driverHome.dart';
import 'package:qwikypicky/src/Modules/driver/providers/DriverAuthenticationProvider.dart';
import 'package:qwikypicky/src/Services/ClickServiceProvider.dart';
import 'package:qwikypicky/src/Services/DeviceInfoServiceProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant.dart';
import '../../../Services/FirebaseMessagingServiceProvider.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {

    super.initState();

    Provider.of<FirebaseMessagingServiceProvider>(context,listen: false).initializeNotificationsSettings().then((_) async{

      await Provider.of<FirebaseMessagingServiceProvider>(context,listen: false).getUserToken();

    });

  }

  @override
  Widget build(BuildContext context) {

    DriverAuthenticationProvider driverAuthenticationProvider = Provider.of<DriverAuthenticationProvider>(context);

    ClickServiceProvider clickServiceProvider = Provider.of<ClickServiceProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:
        IconButton( onPressed: (){
          Navigator.pop(context);
        },icon:Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Text ("Login", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 20,),
                    Text("Welcome back ! Login with your credentials",style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),),
                    SizedBox(height: 30,)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email',style:TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87
                          ),),
                          SizedBox(height: 5,),
                          TextField(
                            obscureText: false,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                ),
                                hintText: 'Email'
                            ),
                            controller: driverAuthenticationProvider.emailController,
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Password',style:TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87
                          ),),
                          SizedBox(height: 5,),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                ),
                                hintText: 'Password'
                            ),
                            controller: driverAuthenticationProvider.passwordController,
                          ),
                          SizedBox(height: 30,)
                        ],
                      )
                    ],
                  ),
                ),
                (clickServiceProvider.loginBtnClicked == false) ? Padding(
                  padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, top: 0),
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
                      'Login',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async{

                      Provider.of<ClickServiceProvider>(context,listen: false).setLoginBtnValue(true);
                      if(

                          Provider.of<DriverAuthenticationProvider>(context,listen: false).emailController.text.isEmpty ||

                          Provider.of<DriverAuthenticationProvider>(context,listen: false).passwordController.text.isEmpty

                      ){

                        Provider.of<ClickServiceProvider>(context,listen: false).setLoginBtnValue(false);

                        MotionToast.error(
                            title:  Text("Validation Error"),
                            description:  Text("Please Fill Out Your Email and Password To Login"),
                            position: MotionToastPosition.top,
                        ).show(context);

                      }else{

                        await Provider.of<DriverAuthenticationProvider>(context,listen: false).login(

                          Provider.of<FirebaseMessagingServiceProvider>(context,listen: false).fcmToken,

                          Provider.of<DeviceInfoServiceProvider>(context,listen: false).deviceName,

                          "en"

                        ).then((_) async{

                          if(Provider.of<DriverAuthenticationProvider>(context,listen: false).authCredentials.isNotEmpty) {

                            if(Provider.of<DriverAuthenticationProvider>(context,listen: false).authCredentials['user']['driver']['is_active'] == 1)
                            {

                              SharedPreferences prefs = await SharedPreferences.getInstance();

                              prefs.setString("api_token", Provider.of<DriverAuthenticationProvider>(context,listen: false).authCredentials['token']);

                              prefs.setBool("driverLoggedIn", true);

                              prefs.setBool("loggedIn", true);

                              Provider.of<ClickServiceProvider>(context,listen: false).setLoginBtnValue(false);

                              Provider.of<DriverAuthenticationProvider>(context,listen: false).changeComesFromLoginPage(true);

                              Provider.of<DriverAuthenticationProvider>(context,listen: false).cleanUp();

                              Navigator.of(context).pushReplacement(

                                MaterialPageRoute(builder: (context) => DriverHomeScreen())

                              );

                            }else{

                              Provider.of<ClickServiceProvider>(context,listen: false).setLoginBtnValue(false);

                              MotionToast.warning(
                                title:  Text("Account Disabled"),
                                description:  Text("Your Account Has Been Disabled Please Contact Support To Activate your Account"),
                                position: MotionToastPosition.top,
                              ).show(context);


                            }

                          }else{

                            Provider.of<ClickServiceProvider>(context,listen: false).setLoginBtnValue(false);

                            MotionToast.warning(
                              title:  Text("Unexpected Error"),
                              description:  Text(Provider.of<DriverAuthenticationProvider>(context,listen: false).errorMessage),
                              position: MotionToastPosition.top,
                            ).show(context);

                          }

                        });

                      }
                    },
                  ),
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator()
                  ],
                )
              ],

            ),
          ],
        ),
      ),
    );
  }
}
