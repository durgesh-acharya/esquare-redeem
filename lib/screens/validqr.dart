import 'dart:convert';
import 'dart:io';

import 'package:esquare_redeem/screens/reedemfail.dart';
import 'package:esquare_redeem/screens/reedemsuccess.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidQr extends StatefulWidget {
  List? data;
 
  ValidQr(this.data);

  @override
  State<ValidQr> createState() => _ValidQrState();
}

class _ValidQrState extends State<ValidQr> {
  String? madeby;
  List userList = [];
  bool anotherid = false;
  bool anotheridtrigger = true;
  bool defaultid = true;
  bool selecttext = true;
  bool entertext = false;
  TextEditingController _upicontroller = TextEditingController();
  //widget data
  
   //get key
Future getkey()async{
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
var key = sharedPreferences.getString("mobile");
setState(() {
madeby = key.toString();
});
}
//get user data
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
      // print(userList[0][1]);
      // print(userList[0]);
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

  //post reedem request

  Future postRedeemrequest(int qrid, String unique, double rupees, String madeby, String upi, String tran)async{
    Map reedem = {
      "rrqrid" : qrid,
      "rrqrunique" : unique,
      "rrqrrupees" : rupees,
      "rrmadeby" : madeby,
      "rrupiid" : upi,
      "rrtranis" : tran
    };
    String url = "http://52.66.119.148/api/reedem/create";
    Map<String,String> headers = {'Content-Type': 'application/json'};
    try{
      var response = await http.post(Uri.parse(url),
          headers: headers,
          body: jsonEncode(reedem),
          encoding: Encoding.getByName("utf-8")
          );
      if(response.statusCode == 200){
        //reedem success route
        
        }else{
          //reedem fail route
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ReedemFail()));
        }
    }on SocketException{
      print("socket");
    }on HttpException{
      print("http");
    }on PlatformException{
      print("Platform");
    }
    catch(e){
      print(e);
    }
  }
//update qruse
  Future updateqruse(String madeby, String qrunique)async{
    Map qrusemap = {
      "qruse" : 1,
      "qrreedem" : 1,
      "qrreedemby" : madeby,
      "qrreedemstatus" : 1
    };
    String url = "http://52.66.119.148/api/qr/updatestatus/${qrunique}";
    Map<String,String> headers = {'Content-Type': 'application/json'};
    try{
      var response = await http.put(Uri.parse(url),
          headers: headers,
          body: jsonEncode(qrusemap),
          encoding: Encoding.getByName("utf-8")
          );
      if(response.statusCode == 200){
        //reedem success route
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ReedemSuccess()));
        }else{
          //reedem fail route
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ReedemFail()));
        }
    }on HttpException{
      print("Http");
    }on SocketException{
      print("Socket");
    }on PlatformException{
      print("Platform");
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getkey().whenComplete(() => getUserData(madeby.toString()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          Lottie.asset(
                'assets/animation/success.json',
                height: 200,
                fit: BoxFit.cover,
                repeat: false
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Text("INR ${widget.data![0]['qr_rupees']}/- is reedemed succesfully",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              SizedBox(height: 10.0,),
           

            ],
          ),
          SizedBox(height: 15.0,),
          Visibility(
            visible: selecttext,
            child: Text("Select an UPI id to reedem.",style: TextStyle(color: Colors.green),)),
              Visibility(
            visible: entertext,
            child: Text("Enter an UPI id to reedem.",style: TextStyle(color: Colors.green),)),
          //default upi id
          Visibility(
            visible: defaultid,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  int wqrid = widget.data![0]['qr_id'];
                  String wqrunique = widget.data![0]['qr_unique'].toString();
                  double wqrrupee = widget.data![0]['qr_rupees'].toDouble();
                  String wmadeby = userList[0][1].toString();
                  String wupi = userList[0][3].toString();
                  postRedeemrequest(wqrid, wqrunique, wqrrupee, wmadeby, wupi, "pending").whenComplete(() => updateqruse(wmadeby, wqrunique));
                },
                child: Container(
                  width: double.infinity,
                  height: 40.0,
                  color: Colors.green,
                  child:Center(child: Text(userList.length == 0 ? "" : userList[0][3],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ),
          // SizedBox(height: 15.0,),
          //another id
          Visibility(
            visible: anotheridtrigger,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                      setState(() {
                    anotherid = true;
                    defaultid = false;
                    anotheridtrigger = false;
                    selecttext = false;
                    entertext = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 40.0,
                  color: Colors.green,
                  child:Center(child: Text("I want to reedem in another id",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ),
          Visibility(
            visible: anotherid,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _upicontroller,
                  ),
                ),
                //reedem button
                Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                int wqrid = widget.data![0]['qr_id'];
                  String wqrunique = widget.data![0]['qr_unique'].toString();
                  double wqrrupee = widget.data![0]['qr_rupees'].toDouble();
                  String wmadeby = userList[0][1].toString();
                  String wupi = _upicontroller.text;
                  postRedeemrequest(wqrid, wqrunique, wqrrupee, wmadeby, wupi, "pending").whenComplete(() => updateqruse(wmadeby, wqrunique));
              },
              child: Container(
                width: double.infinity,
                height: 40.0,
                color: Colors.green,
                child:Center(child: Text("Reedem",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              ),
            ),
          ),
          //i will provide it later(not recomended)
              Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                int wqrid = widget.data![0]['qr_id'];
                  String wqrunique = widget.data![0]['qr_unique'].toString();
                  double wqrrupee = widget.data![0]['qr_rupees'].toDouble();
                  String wmadeby = userList[0][1].toString();
                  String wupi = "provide later";
                  postRedeemrequest(wqrid, wqrunique, wqrrupee, wmadeby, wupi, "pending").whenComplete(() => updateqruse(wmadeby, wqrunique));
              },
              child: Container(
                width: double.infinity,
                height: 40.0,
                color: Colors.green,
                child:Center(child: Text("I will provide later",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              ),
            ),
          ),

              ],
              
              
              
            ))
        ],
      ),
    );
  }
}

