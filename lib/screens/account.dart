
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Reedem.dart';

class Accounts extends StatefulWidget {
 
  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
String madeby = "";



     //get key
Future getkey()async{
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
var key = sharedPreferences.getString("mobile");
setState(() {
madeby = key.toString();
});
}

//card
Widget card(int reedemid, double rupees,int rrstatus,String tranid){
  return Card(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 35.0,
                      color: Colors.green,
                      child : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Redeem Request id : ${reedemid}",style: TextStyle(color: Colors.white),),
                          Text("INR : ${rupees}",style: TextStyle(color: Colors.white))
                        ],
                      )
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          rrstatus == 0 ? Text("Your Request is under Process !") : Text("Your request is proccessed and transaction id for the same is ${tranid}")
                        ],
                      ),
                    )
                  ],
                ),
              );
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getkey();
  }

  //get redeem reqeust
  Future getreedemrequest(String madeby)async{
    String url = "http://52.66.119.148/api/reedem/frommadeby/${madeby}";
    try{
      var response = await http.get(Uri.parse(url));
      var jsondata = jsonDecode(response.body);
         if(jsondata[0]["status"] == true){
        var jdata = jsondata[0]["data"];
        print(jdata);
        return jdata.map((json) => Reedem.fromJson(json)).toList();
      
      }else{
       
      }
    }on HttpException{
      print("http");
    }on SocketException{
      print("socket");
    }on PlatformException{
      print("Platform");
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: FutureBuilder(
            future: getreedemrequest(madeby!),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: Colors.green,),);
              }else if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  return  ListView.builder(
                itemCount: snapshot.data.length == 0 ? 0 : snapshot.data.length,
                itemBuilder:(BuildContext context, int index){
                  return card(snapshot.data[index].rrId,snapshot.data[index].qrRupees.toDouble(),snapshot.data[index].rrStatus,snapshot.data[index].rrTranid);
                });
                }else if(snapshot.hasError){
                   return Center(child: Text("Something went wrong!!"),);
                }else{
                  return Center(child: Text("No Redeem Requests to show!"),);
                } 
              }else{
                return Center(child: Text("Something went wrong!!"),);
              } 
            }),
    
        
    );
  }


  
}