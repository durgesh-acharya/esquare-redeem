

import 'package:esquare_redeem/screens/account.dart';
import 'package:esquare_redeem/screens/product.dart';
import 'package:esquare_redeem/screens/profile.dart';
import 'package:esquare_redeem/screens/scanqr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  String mobilenumber;
  DashBoard(this.mobilenumber);
  

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  
    Future sharedpreferenceadd(String mno)async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("mobile", mno);
    print(mno);
  }
 
   Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
         title: Text("Are You Sure Want to Exit ??"),
    actions: [
      TextButton(onPressed: (){
        SystemNavigator.pop();
      }, child: Text("Yes")),
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("No")),
    ],
      ),
    )) ?? false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    sharedpreferenceadd(widget.mobilenumber);
   
  }

 
  int index = 0;
  final screens = [
    Products(),
    ScanQr(),
    Accounts(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("E Square",style: GoogleFonts.fredokaOne(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop ,
        child: screens[index]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          
          indicatorColor: Colors.white,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14,fontWeight: FontWeight.w500)
          )
        ),
        child: NavigationBar(
          height: 80,
          backgroundColor: Colors.white10,
          selectedIndex: index,
          onDestinationSelected: ((index) => setState(() {
            this.index = index;
          })),
          destinations: [
          NavigationDestination(icon: FaIcon(FontAwesomeIcons.list,color: index == 0 ? Colors.green : Colors.grey),label: '',),
          NavigationDestination(icon: FaIcon(FontAwesomeIcons.qrcode,color:index == 1 ? Colors.green : Colors.grey),label: '',),
          NavigationDestination(icon: FaIcon(FontAwesomeIcons.indianRupeeSign,color: index == 2 ? Colors.green : Colors.grey), label: ''),
           NavigationDestination(icon: FaIcon(FontAwesomeIcons.user,color: index == 3 ? Colors.green : Colors.grey), label: ''),
        ]),
      ),
    );
  }
}