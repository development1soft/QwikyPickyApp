import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:qwikypicky/constant.dart';
import 'package:qwikypicky/src/Modules/customer/home/customerHome.dart';
import 'package:qwikypicky/src/Modules/customer/providers/CustomerAuthenticationProvider.dart';
import 'package:qwikypicky/src/Services/DeviceInfoServiceProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services/ClickServiceProvider.dart';
import '../../../Services/FirebaseMessagingServiceProvider.dart';
import 'loginCustomer.dart';

class RegisterCustomerScreen extends StatefulWidget {
  @override
  _RegisterCustomerScreenState createState() => _RegisterCustomerScreenState();
}

class _RegisterCustomerScreenState extends State<RegisterCustomerScreen> {

  @override
  void initState() {

    super.initState();

    Provider.of<FirebaseMessagingServiceProvider>(context,listen: false).initializeNotificationsSettings().then((_) async{

      await Provider.of<FirebaseMessagingServiceProvider>(context,listen: false).getUserToken();

      await Provider.of<CustomerAuthenticationProvider>(context,listen: false).getAvailableCountries();

    });

  }

  @override
  Widget build(BuildContext context) {

    CustomerAuthenticationProvider customerAuthenticationProvider = Provider.of<CustomerAuthenticationProvider>(context);

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
      body: (customerAuthenticationProvider.availableCountriesList.isEmpty) ? Center(
        child: CircularProgressIndicator(),
      ) : Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Text ("Register", style: TextStyle(
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
                          Text('First Name',style:TextStyle(
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
                                hintText: 'First Name'
                            ),
                            controller: customerAuthenticationProvider.firstNameController,
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last Name',style:TextStyle(
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
                                hintText: 'Last Name'
                            ),
                            controller: customerAuthenticationProvider.lastNameController,
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
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
                            controller: customerAuthenticationProvider.emailController,
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
                            controller: customerAuthenticationProvider.passwordController,
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Country',style:TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87
                          ),),
                          SizedBox(height: 5,),
                          DropdownButtonFormField<String>(
                              hint: Text('Country',style: TextStyle(
                                color: Color(0xff473560),
                                fontSize: 16,
                              )),
                              value: customerAuthenticationProvider.selectedCountry.isEmpty ? customerAuthenticationProvider.availableCountriesList[0]['nice_name'] : customerAuthenticationProvider.selectedCountry['nice_name'],
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              style: TextStyle(
                                color: Color(0xff473560),
                              ),
                              onChanged: (String? newValue) {
                                Provider.of<CustomerAuthenticationProvider>(context,listen: false).availableCountriesList.forEach((country) {

                                  if(country['nice_name'] == newValue)
                                  {
                                    Provider.of<CustomerAuthenticationProvider>(context,listen: false).setSelectedCountry(country);
                                  }

                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.only(top: 0,bottom: 0,right: 20,left: 20)
                              ),
                              items: customerAuthenticationProvider.availableCountriesList.map((map) {
                                return DropdownMenuItem<String>(
                                  child: Text(map['nice_name']),
                                  value: map['nice_name'],
                                );
                              }).toList()
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone Number',style:TextStyle(
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
                                hintText: 'Phone Number'
                            ),
                            controller: customerAuthenticationProvider.phoneNumberController,
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                    ],
                  ),
                ),
                (clickServiceProvider.customerRegisterBtnClicked == false) ? Padding(
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
                      'Register',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async{

                      Provider.of<ClickServiceProvider>(context,listen: false).setCustomerRegisterBtnClicked(true);
                      if(

                          Provider.of<CustomerAuthenticationProvider>(context,listen: false).firstNameController.text.isEmpty ||

                          Provider.of<CustomerAuthenticationProvider>(context,listen: false).lastNameController.text.isEmpty ||

                          Provider.of<CustomerAuthenticationProvider>(context,listen: false).emailController.text.isEmpty ||

                          Provider.of<CustomerAuthenticationProvider>(context,listen: false).passwordController.text.isEmpty ||

                          Provider.of<CustomerAuthenticationProvider>(context,listen: false).selectedCountry.isEmpty ||

                          Provider.of<CustomerAuthenticationProvider>(context,listen: false).phoneNumberController.text.isEmpty

                      ){

                        Provider.of<ClickServiceProvider>(context,listen: false).setCustomerRegisterBtnClicked(false);

                        MotionToast.error(
                          title:  Text("Validation Error"),
                          description:  Text("Please Fill Out All Inputs"),
                          position: MotionToastPosition.top,
                        ).show(context);

                      }else{

                        await Provider.of<CustomerAuthenticationProvider>(context,listen: false).register(

                            Provider.of<FirebaseMessagingServiceProvider>(context,listen: false).fcmToken,

                            Provider.of<DeviceInfoServiceProvider>(context,listen: false).deviceName,

                            "en"

                        ).then((responseStatus) async{

                          print(responseStatus);

                          if(responseStatus == 200){

                            Provider.of<ClickServiceProvider>(context,listen: false).setCustomerRegisterBtnClicked(false);

                            Provider.of<CustomerAuthenticationProvider>(context,listen: false).cleanUp();

                            Navigator.of(context).pop();

                            MotionToast.success(
                              title:  Text("Registeration Completed Successfully"),
                              description:  Text("Please Verify Your Email Before Login"),
                              position: MotionToastPosition.top,
                            ).show(context);

                          }else{

                            Provider.of<ClickServiceProvider>(context,listen: false).setCustomerRegisterBtnClicked(false);

                            MotionToast.warning(
                              title:  Text("Email Already Exists"),
                              description:  Text(Provider.of<CustomerAuthenticationProvider>(context,listen: false).errorMessage),
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
                ),
                SizedBox(height: 30,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
