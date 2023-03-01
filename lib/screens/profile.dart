
import 'dart:convert';
import 'dart:io';


import 'package:esquare_redeem/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? obtainkey;
  List userList = [];
  Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

Future removekey ()async{
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
sharedPreferences.remove("mobile");
 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

Future getkey ()async{
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
var key = sharedPreferences.getString("mobile");
setState(() {
obtainkey = key.toString();
});
}

Future getUserData(String mobile)async{
    try{
      var response = await http.get(Uri.parse("http://52.66.119.148/api/user/bymobile/${mobile}/1"));
     var jsondata = jsonDecode(response.body);
    
      if(jsondata[0]["status"] == true){
        var jdata = jsondata[0]["data"];
        print(jdata);
        var username = jdata[0]["user_name"];
        var usermobile = jdata[0]["user_mobile"];
        var usercity = jdata[0]["user_city"];
        var userupiid = jdata[0]["user_duid"];
        print(username);
      // print(productName);
      // print(productDescription);
      List user = [username,usermobile,usercity,userupiid];
      print(user[0]);
      setState(() {
        userList.add(user);
      });
      print(userList[0][1]);
      print(userList[0]);
      }else{
        // setState(() {
        //   // nodata = true;
        //   // loadervisible = false;
        // });
      }
    }on SocketException{
      print("socket");
    }on HttpException{
      print("http");
    }on PlatformException{
      print("platform");
    }catch(e){
      print(e);
    }
  }

@override
  void initState(){
    // TODO: implement initState
    super.initState();
   getkey().whenComplete(() => getUserData(obtainkey!));
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 65.0,
                    child: SvgPicture.asset('assets/images/user-solid.svg',
                    width: 90.0,
                    height: 90.0,
                    color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top :8.0),
                    child: Text(userList.length == 0 ? "" : userList[0][0],style: GoogleFonts.secularOne(color:Colors.green,fontSize: 18.0),),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left :25.0,right: 25.0,top: 16.0,bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("City : " ,style: GoogleFonts.secularOne(color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  Text(userList.length == 0 ? "" : userList[0][2],style: GoogleFonts.secularOne(color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold))
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left :25.0,right: 25.0,top: 16.0,bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mobile Number : " ,style: GoogleFonts.secularOne(color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  Text(userList.length == 0 ? "" : userList[0][1],style: GoogleFonts.secularOne(color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold))
                ],
              ),
            ),
                Padding(
              padding: const EdgeInsets.only(left :25.0,right: 25.0,top: 16.0,bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("UPI ID : " ,style: GoogleFonts.secularOne(color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  Text(userList.length == 0 ? "" : userList[0][3],style: GoogleFonts.secularOne(color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold))
                ],
              ),
            ),

                    SizedBox(height: 25.0,),
            Padding(padding: EdgeInsets.only(bottom :8.0),
          child: GestureDetector(
          onTap: (() async{
            _signOut().whenComplete(() => removekey());
          }),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                ),
                height: 45.0,
                width: double.infinity,
                child: Center(child: Text("Logout", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)),
              ),
            )),
          )

          ],
        ),
      ),
    );
  }

}