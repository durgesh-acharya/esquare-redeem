

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esquare_redeem/models/SubCate.dart';
import 'package:esquare_redeem/screens/prodlist.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class SubCatePage extends StatefulWidget {
  int cateid;
  SubCatePage(this.cateid);

  @override
  State<SubCatePage> createState() => _SubCatePageState();
}

class _SubCatePageState extends State<SubCatePage> {
  
  bool nodata = false;
  bool loadervisible = true;

  //future method

   Future getSubCate(int id)async{ 
    try{
      var response = await http.get(Uri.parse("http://52.66.119.148/api/subcate/${id}/1"));
     var jsondata = jsonDecode(response.body);
    
      if(jsondata[0]["status"] == true){
        var jdata = jsondata[0]["data"];
        print(jdata);
        return jdata.map((json) => SubCate.fromJson(json)).toList();
      
      }else{
       
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

    //old view

    Widget oldview(String subcatename, String subcateurl){
      return GestureDetector(
                    onTap: (){
                  print("yay");
                    },
                    child: Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 150.0,
                        width: 150.0,
                        child: CachedNetworkImage(
                          imageUrl: subcateurl,
                          placeholder: ((context, url) {
                            return SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: Shimmer.fromColors(
                                 baseColor: Colors.grey[500]!,
                                highlightColor: Colors.grey[300]!, child: Placeholder(),
                              ),
                            );
                          }),
                          errorWidget: (context, url, error) {
                            return SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: Center(child: Icon(Icons.error_outline,color: Colors.red,size: 25.0,),),
                            );
                          },
                          cacheManager: CacheManager(
                            Config('customCacheKey',
                            stalePeriod: const Duration(days: 7)
                            )
                          ),
                        )
                      ),
                    ),
                    Column(
                      children: [
                        Text(subcatename,style: GoogleFonts.montserrat(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.green),),
                        
                     ],
                    )
                                ],
                              ),
                            ),
                  );
    }

    //new view
    Widget subcateWidget(String catename, String url){
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
          child: Text(catename,style: GoogleFonts.secularOne(color : Colors.white,fontWeight: FontWeight.bold,fontSize: 12.0),textAlign: TextAlign.start,),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        title: Text("E Square",style: GoogleFonts.fredokaOne(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: FutureBuilder(
            future: getSubCate(widget.cateid),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: Colors.green,),);
              }else if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                   return ListView.builder(
                
                itemCount: snapshot.data.length == 0 ? 0 : snapshot.data.length,
                itemBuilder: ((BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProdList(widget.cateid,snapshot.data[index].subcateId),
  ));
                    },
                    child: subcateWidget(snapshot.data[index].subcateName,snapshot.data[index].subcateUrl));
            
    
                } ));
                }else if(snapshot.hasError){
                  return Center(child: Text("Something Went Wrong!"),);
                }else{
                  return Center(child: Text("No Subcategory to show!"),);
                }
              }else{
                return Center(child: Text("Something Went Wrong!"),);
              }
            },
          ),
        
      
    );
  }
}