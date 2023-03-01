
import 'package:esquare_redeem/screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
 

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _mobilecontroller = TextEditingController();
  Color color = Colors.green;

  Widget mobilenumber(textcontroller){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
                'assets/images/otp.jpg',
                width: 300,
                height: 300,
              ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.green),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 40,
                            // child: TextField(
                            //   //controller: countryController,
                            //   keyboardType: TextInputType.number,
                            //   decoration: InputDecoration(
                            //     border: InputBorder.none,
                            //   ),
                            // ),
                            child :Container(
                              alignment: Alignment.center,
                              child: Text("+91",style: TextStyle(fontSize: 16.0,color: Colors.green),))
                          ),
                          Text(
                            "|",
                            style: TextStyle(fontSize: 33, color: Colors.green),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextField(
                                maxLength: 10,
                                controller: textcontroller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                              counterText: "",
                              
                            ),
                          ))
                        ],
                      ),
                    ),
        ),
                  //submit button
     Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 45.0,
        child: ElevatedButton(
          child: Text("Send OTP",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),),
        onPressed: () {
          Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) =>  OTPScreen(_mobilecontroller.text)));
        },
   
  ),
      ),
    ),

      ],
    );
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.white10,
        alignment: Alignment.center,
        child: mobilenumber(_mobilecontroller)
),
      ),
    );
  }

 
}