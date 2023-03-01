
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esquare_redeem/models/Prod.dart';
import 'package:esquare_redeem/screens/proddetail.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class ProdList extends StatefulWidget {
  int cateid;
  int subcateid;
  ProdList(this.cateid,this.subcateid);

  @override
  State<ProdList> createState() => _ProdListState();
}

class _ProdListState extends State<ProdList> {

  bool nodata = false;
  bool loadervisible = true;

// get prodcut

Future getProduct(int cateid,int subcateid)async{
try{
      var response = await http.get(Uri.parse("http://52.66.119.148/api/prod/byparam/${cateid}/${subcateid}/1"));
     var jsondata = jsonDecode(response.body);
    
      if(jsondata[0]["status"] == true){
        var jdata = jsondata[0]["data"];
        print(jdata);
        return jdata.map((json) => Prod.fromJson(json)).toList();
      
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
      body: Stack(children: [
          // when data
          FutureBuilder(
            future: getProduct(widget.cateid,widget.subcateid),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Visibility(
                  visible: loadervisible,
                  child: Center(child: GFLoader(
                          type:GFLoaderType.circle
                        ),
                        ),
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2
                ), 
                itemCount: snapshot.data.length == 0 ? 0 : snapshot.data.length,
                itemBuilder: (BuildContext context,int index){
                  return gridcontainer(snapshot.data[index].prodName,snapshot.data[index].prodUrl, snapshot.data[index].prodId,widget.cateid,widget.subcateid);
                });
              
            },
          ),
          //when not
          Visibility(
            visible: nodata,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,color: Colors.red,size: 108.0,),
                  Text("No Product to show !",style: GoogleFonts.montserrat(color:Colors.green,fontSize: 26.0),)
                ],
              ),
            ))
        ],),
    );
  }
}