
import 'dart:convert';


import 'package:esquare_redeem/screens/dashboard.dart';
import 'package:esquare_redeem/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  final String _mobilenumber;
  
  OTPScreen(this._mobilenumber);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  @override
  void initState() {
    _verifyphone();
  
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pincontroller.dispose();
    super.dispose();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController pincontroller = TextEditingController();
  
  String? _verificationId;



  Future checkuser(String mobile, int status)async{
    String url = "http://52.66.119.148/api/user/exist/${mobile}/${status}";
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body);
    if(jsondata[0]["status"] == true){
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                             return DashBoard(widget._mobilenumber);
                            }));
      
    }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                             return SignupScreen(widget._mobilenumber);
                            }));
    }
  }

 
  Widget pinput(){
    return  Pinput(
                  controller: pincontroller,
                    length: 6,
                    onCompleted: (pin)async{
                      try{
                        AuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: pin);
                        if(credential !=null){
                          try{
                             await FirebaseAuth.instance.signInWithCredential(credential).then((value){
                            if(value.user !=null){
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            //  return DashBoard(widget._mobilenumber);
                            // }));
                            checkuser(widget._mobilenumber, 1);
                            }
                           });

                          }catch(e){
                            _dialogBuilder(context);
                          
                              print(e);
                          }
                        }else if(credential == null){
                          print("invalid otp");
                          _dialogBuilder(context);
                     
                        }
                      }catch(e){
                        print(e);
                      }


                     
                    },
                    onSubmitted: (pin)async{
                      try{
                          await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: pin)).then((value)async{
                          if(value.user != null){
                            print("move to dashboard");
                              Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) =>  DashBoard(widget._mobilenumber)));
                          }else{
                            _dialogBuilder(context);
                            FocusScope.of(context).unfocus();
                            
                          }
                        })
                        ;

                      }catch(e){
                         _dialogBuilder(context);
                            FocusScope.of(context).unfocus();
                      }
                    },
                  );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Lottie.asset(
                'assets/animation/otpr.json',
                height: 200,
                fit: BoxFit.cover,
                repeat: true
              ),
              SizedBox(height : 15.0),
            Text("OTP has been sent to ${widget._mobilenumber}.",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
            SizedBox(height: 35.0,),
            pinput(),
           
SizedBox(height: 15.0,),
            
          ],
        ),
        ),
      ));
      
    
  }

   _verifyphone()async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget._mobilenumber}',
      verificationCompleted: (PhoneAuthCredential credential)async{
        await FirebaseAuth.instance.signInWithCredential(credential).then((value)async{
          if(value.user!=null){
            print("Logged in Succesfully");
          }
        });
      }, 
      verificationFailed: (FirebaseAuthException e){
        print(e.message);
      }, 
      codeSent: (verificationId, forceResendingToken) {
        print("code sent");
        setState(() {
          _verificationId = verificationId;
        });
      }, 
      codeAutoRetrievalTimeout: (String verificationId){
        print("Code sent after 60 sec");
        setState(() {
          _verificationId = verificationId;
        });
      },timeout: Duration(seconds: 60));
  }

  //invalid otp
  Future<void> _dialogBuilder(BuildContext context){
    return showDialog(context: context, 
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("Invalid OTP!"),
                                actions: [
                                  TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
                                ],
                              );
                            });
  }
}