
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esquare_redeem/models/Cate.dart';
import 'package:esquare_redeem/screens/subcatepage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class Products extends StatefulWidget {
 

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  bool nodata = false;
  bool loadervisible = true;
    Future getCate()async{ 
    try{
      var response = await http.get(Uri.parse("http://52.66.119.148/api/cate/active"));
     var jsondata = jsonDecode(response.body);
    
      if(jsondata[0]["status"] == true){
        var jdata = jsondata[0]["data"];
        print(jdata);
        return jdata.map((json) => Cate.fromJson(json)).toList();
      
      }else{
        setState(() {
          nodata = true;
          loadervisible = false;
        });
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
   //cate widget
   Widget cateWidget(String catename, String url){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
       children: [
        //bottom contianer green

        Container(
          
        width: double.infinity,
        height : 150.0,
        decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
        boxShadow: [
            BoxShadow(
                color: Colors.green,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
        ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 65.0),
          child: Text(catename,style: GoogleFonts.secularOne(color : Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
        )
      ),
      //top contianer 
      Padding(
        padding: const EdgeInsets.only(left:230.0),
        child: Container(
          width: double.infinity,
          height: 150.0,
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 150.0,
            child: CachedNetworkImage(
                            imageUrl: url,
                            placeholder: ((context, url) {
                              return SizedBox(
                                width: double.infinity,
                               
                                child: Shimmer.fromColors(
                                   baseColor: Colors.grey[700]!,
                                  highlightColor: Colors.grey[500]!, child: Placeholder(),
                                ),
                              );
                            }),
                            errorWidget: (context, url, error) {
                              return SizedBox(
                                width: double.infinity,
                                
                                child: Center(child: Icon(Icons.error_outline,color: Colors.red,size: 25.0,),),
                              );
                            },
                            cacheManager: CacheManager(
                              Config('customCacheKey',
                              stalePeriod: const Duration(days: 7)
                              )
                            ),
                          ),
          ),
        ),
      )

       ],
        
      ),
    );
   }
    // gtridcard
    Widget gridcontainer(String name,String url,int id){
      return GestureDetector(
        onTap: (){
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SubCatePage(id),
  ));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 150.0,
                  child:  CachedNetworkImage(
                            imageUrl: url,
                            placeholder: ((context, url) {
                              return SizedBox(
                                width: double.infinity,
                               
                                child: Shimmer.fromColors(
                                   baseColor: Colors.grey[700]!,
                                  highlightColor: Colors.grey[500]!, child: Placeholder(),
                                ),
                              );
                            }),
                            errorWidget: (context, url, error) {
                              return SizedBox(
                                width: double.infinity,
                                
                                child: Center(child: Icon(Icons.error_outline,color: Colors.red,size: 25.0,),),
                              );
                            },
                            cacheManager: CacheManager(
                              Config('customCacheKey',
                              stalePeriod: const Duration(days: 7)
                              )
                            ),
                          ),
                ),
                Text(name,style: GoogleFonts.montserrat(color: Colors.green,fontSize: 14.0,fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ),
      );
    }


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCate();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: FutureBuilder(
          future: getCate(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(color: Colors.green),);
            }else if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return   ListView.builder(
             
              itemCount: snapshot.data.length == 0 ? 0 : snapshot.data.length,
              itemBuilder: ((BuildContext context, int index) {
                return GestureDetector
                (onTap: () {
                       Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SubCatePage(snapshot.data[index].cateId),
  ));
                },
                  child: cateWidget(snapshot.data[index].cateName,snapshot.data[index].cateUrl));
          

              } ));
              }else if(snapshot.hasError){
                return Center(child: Text("Something went wrong!"),);
              }else{
                return Center(child: Text("No Category to show!"),);
              }
            }else{
              return Center(child: Text("Something went wrong!"),);
            }
            
          },
        ),
     
    
      )
         
      
    ;
  }

  
}