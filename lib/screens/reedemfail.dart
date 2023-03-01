
import 'package:esquare_redeem/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReedemFail extends StatefulWidget {
  const ReedemFail({super.key});

  @override
  State<ReedemFail> createState() => _ReedemFailState();
}

class _ReedemFailState extends State<ReedemFail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splash()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'assets/animation/error.json',
                height: 200,
                fit: BoxFit.cover,
                repeat: false
            ),
          )
        ],
      ),
    );;
  }
}