
import 'package:esquare_redeem/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvalidQr extends StatefulWidget {
  const InvalidQr({super.key});

  @override
  State<InvalidQr> createState() => _InvalidQrState();
}

class _InvalidQrState extends State<InvalidQr> {
  String? madeby;
     //get key
Future getkey()async{
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
var key = sharedPreferences.getString("mobile");
setState(() {
madeby = key.toString();
});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
                    'assets/animation/heartbreak.json',
                    height: 200,
                    fit: BoxFit.cover,
                    repeat: false
                  ),
                  Text("It seems, you have scanned an invalid QR !",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Splash()));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        color: Colors.red,
                        child:Center(child: Text("Okay !",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))
                      ),
                    ),
                  )
        ],
      ),)
    );
  }
}