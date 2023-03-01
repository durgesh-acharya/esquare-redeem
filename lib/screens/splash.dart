
import 'dart:async';


import 'package:esquare_redeem/screens/dashboard.dart';
import 'package:esquare_redeem/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {


  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  String? mobilenumber;
  

  Future getmobile()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainnum = sharedPreferences.getString("mobile");
    print(obtainnum.toString());
    setState(() {
      mobilenumber = obtainnum.toString();
    });
    print(mobilenumber.toString());
    
    
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();


   getmobile().whenComplete(() {
         if(mobilenumber!.length < 10){
          Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) =>  LoginScreen()));
         }else{
            Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) =>  DashBoard(mobilenumber.toString())));;
         }
   });
    
    
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body : Center(
        child: CircularProgressIndicator(color: Colors.white,),
      )
    );
  }
}