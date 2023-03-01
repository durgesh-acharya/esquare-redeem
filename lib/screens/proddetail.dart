
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esquare_redeem/models/Prod.dart';
import 'package:esquare_redeem/models/ProdImg.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';


class ProdDetail extends StatefulWidget {
  int productid;
  int subcateid;
  int cateid;
  
  ProdDetail(this.productid,this.cateid,this.subcateid);

  @override
  State<ProdDetail> createState() => _ProdDetailState();
}

class _ProdDetailState extends State<ProdDetail> {

  bool nodata = false;
  bool loadervisible = true;
   bool spnodata = false;
  bool sploadervisible = true;

  List productlist = [];
//product url
  Future getUrl(int prodid)async{
    try{
      var response = await http.get(Uri.parse("http://52.66.119.148/api/prodimg/${prodid}"));
     var jsondata = jsonDecode(response.body);
    
      if(jsondata[0]["status"] == true){
        var jdata = jsondata[0]["data"];
        // print(jdata);
        return jdata.map((json) => ProdImg.fromJson(json)).toList();
      
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

  // get product data

  Future getProductdata(int prodid)async{
    try{
      var response = await http.get(Uri.parse("http://52.66.119.148/api/prod/byid/${prodid}"));
     var jsondata = jsonDecode(response.body);
    
      if(jsondata[0]["status"] == true){
        var jdata = jsondata[0]["data"];
        // print(jdata);
        var productName = jdata[0]["prod_name"];
        var productDescription = jdata[0]["prod_description"];
      // print(productName);
      // print(productDescription);
      List prod = [productName,productDescription];
      setState(() {
        productlist.add(prod);
      });
      print(productlist[0][1]);
      print(productlist[0]);
      }else{
        setState(() {
          // nodata = true;
          // loadervisible = false;
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
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductdata(widget.productid);
  }

//get similar product

Future getsimilarProduct(int prodid,int cateid, int subcateid)async{
    try{
      var response = await http.get(Uri.parse("http://52.66.119.148/api/prod/byparam/eone/${prodid}/${cateid}/${subcateid}"));
     var jsondata = jsonDecode(response.body);
    
      if(jsondata[0]["status"] == true){
        var jdata = jsondata[0]["data"];
        // print(jdata);
        return jdata.map((json) => Prod.fromJson(json)).toList();
      
      }else{
        setState(() {
          spnodata = true;
          sploadervisible = false;
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

  //grid container

  // grid card

    Widget gridcontainer(String name,String url,int id,int categoryid,int subcategoryid){
      return GestureDetector(
        onTap: (){
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProdDetail(id,categoryid,subcategoryid),
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
                Text(name,style: GoogleFonts.secularOne(color: Colors.green,fontSize: 14.0,fontWeight: FontWeight.bold),)
              ],
            ),
          ),
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
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            
                FutureBuilder(
              future: getUrl(widget.productid),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(color: Colors.green,),);
                }else if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    return Column(
                  children: [
                    SizedBox(height: 25.0,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: CarouselSlider.builder(
                          itemCount: snapshot.data.length == 0 ? 0 : snapshot.data.length,
                          itemBuilder: ((context, index, realIndex) {
                             return Image.network(
                                              snapshot.data[index].prodimgUrl,
                                              fit: BoxFit.fill,
                                            );
                          }), 
                          options: CarouselOptions(
                                            initialPage: 0,
                                            autoPlay: true,
                                            aspectRatio: 16/9,
                                            enlargeCenterPage: true,
                                            viewportFraction: 1,
                                            enlargeStrategy: CenterPageEnlargeStrategy.height
                                          ),),
                      ),
                    ),
                  ],
                );
                  }else if(snapshot.hasError){
                    return Center(child: Text("Something went wrong!"),);
                  }else{
                    return Center(child:Text("No Product to show!"));
                  }
                }else{
                  return Center(child: Text("Something went wrong!"),);
                }
                
                
              }),
          
            Padding(
              padding: const EdgeInsets.only(top :8.0,left: 8.0,right: 8.0,bottom: 2.0),
              child: Container(
                width: double.infinity,
                height: 45.0,
                decoration: BoxDecoration(
                  color: Colors.green
                ),
                child: Center(child: Text(productlist.length == 0 ? "" : productlist[0][0],style: GoogleFonts.secularOne(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),)))
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right : 8.0,top: 2.0),
              child: Container(
                width: double.infinity,
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    // bottomLeft: Radius.circular(25.0),
                    // bottomRight: Radius.circular(25.0),
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(productlist.length == 0 ? "" : productlist[0][1],textAlign: TextAlign.justify,style: GoogleFonts.secularOne(color:Colors.green),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.green,
                thickness: 3.0,
              ),
            ),
            Text("Similar Products",style: GoogleFonts.secularOne(color: Colors.green,fontSize: 20.0),),
                FutureBuilder(
                  future: getsimilarProduct(widget.productid, widget.cateid, widget.subcateid),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(color: Colors.green),);
                    }else if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){
                        return Container(
                      height: 225.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length == 0 ? 0 : snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: similarwidget(snapshot.data[index].prodName,snapshot.data[index].prodUrl, snapshot.data[index].prodId, widget.cateid, widget.subcateid)
                          );
                          
                        }),
                    );
                      }else if(snapshot.hasError){
                        return Center(child: Text("Something Went Wrong !"),);
                      }else{
                        return Center(child: Text("No Similar Products to Show !"),);
                      }
                    }else{
                      return Center(child: Text("Something Went Wrong !"),);
                    }
                 
                    
                  }),
        
              ],
            )
      
        
      ),
    );
  }

  //similar widget card

  Widget similarwidget(String name, String url, int productid, int cateid, int subcateid){
    return GestureDetector(
                              onTap:() {
                                  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => ProdDetail(productid,cateid,subcateid),
  ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                border: Border.all(color: Colors.green)
                                ),
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                  SizedBox(
                                    width: 150.0,
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
                                  Text(name,style: GoogleFonts.secularOne(color: Colors.green,fontSize: 14.0,fontWeight: FontWeight.bold))
                                  ],
                                ),
                                
                              ),
                            );
  }
}