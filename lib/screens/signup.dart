
import 'dart:convert';
import 'dart:io';


import 'package:esquare_redeem/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
 String mobile;
 SignupScreen(this.mobile);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //text editing controller
  TextEditingController _name = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _upiid = TextEditingController();

  //add user method
  Future adduer(String usermobile, String username,String usercity,String userduid,int userstatus)async{
    Map usermap = {
      "usermobile": usermobile,
      "username": username,
     "usercity":  usercity,
    "userduid": userduid,
    "userstatus" : userstatus
    };
    String url ="http://52.66.119.148/api/user/create";
    Map<String,String> headers = {'Content-Type': 'application/json'};
    try{
       var response = await http.post(Uri.parse(url),
          headers: headers,
          body: jsonEncode(usermap),
          encoding: Encoding.getByName("utf-8")
          );
      if(response.statusCode == 200){
        //to dashboard
                  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => DashBoard(usermobile)),
  );
       
        }else{
          //reedem fail route
          addusererror();
     
        }
    }on HttpException{
      print("http");
    }on SocketException{
      print("socket");
    }on PlatformException{
      print("platform");
    }
    catch(e){
      print(e);
    }
  }

  // //empty box error
  Future<void> emptybox(){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("All fields are mandatory!!"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Okay"))
        ],
      );
    });
  }

  //add user error

  Future<void> addusererror(){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Something went wrong!!"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Okay"))
        ],
      );
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
       
        children: [
          SizedBox(height: 145.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("As we dont find an account associate to ${widget.mobile}, we require some information from you !!",style: TextStyle(fontSize: 18.0),),
          ),
          SizedBox(height: 45.0),
          // name text field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _name,
  decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        
      ),
      filled: true,
      
      hintStyle: TextStyle(color: Colors.grey[800]),
      hintText: "Enter your Name",
      fillColor: Colors.white70),
),
          ),
          // Enter your city
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _city,
  decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        
      ),
      filled: true,
      
      hintStyle: TextStyle(color: Colors.grey[800]),
      hintText: "Enter your City",
      fillColor: Colors.white70),
),
          ),
            // Enter your defalut upi id

           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _upiid,
  decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        
      ),
      filled: true,
      
      hintStyle: TextStyle(color: Colors.grey[800]),
      hintText: "Enter your Default UPI id",
      fillColor: Colors.white70),
),
          ),

          SizedBox(height: 25.0,),
          // ok button

          Padding(padding: EdgeInsets.all(8.0),
          child: GestureDetector(
           onTap: (() async{
            
              if(_name.text.length == 0 || _city.text.length == 0 || _upiid.text.length == 0){
                emptybox();
              }else{
                adduer(widget.mobile, _name.text, _city.text, _upiid.text,1);
              }
            
           }),
            child: Container(
              color: Colors.lightGreen,
              height: 40.0,
              width: double.infinity,
              child: Center(child: Text("Add", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)),
            )),
          )
        ],
      ),

    
      
      ),);
  }
}