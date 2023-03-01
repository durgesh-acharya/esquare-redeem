


// To parse this JSON data, do
//
//     final prodImg = prodImgFromJson(jsonString);

import 'dart:convert';

ProdImg prodImgFromJson(String str) => ProdImg.fromJson(json.decode(str));

String prodImgToJson(ProdImg data) => json.encode(data.toJson());

class ProdImg {
    ProdImg({
        required this.prodimgId,
        required this.prodimgProd,
        required this.prodimgUrl,
    });

    int prodimgId;
    int prodimgProd;
    String prodimgUrl;

    factory ProdImg.fromJson(Map<String, dynamic> json) => ProdImg(
        prodimgId: json["prodimg_id"],
        prodimgProd: json["prodimg_prod"],
        prodimgUrl: json["prodimg_url"],
    );

    Map<String, dynamic> toJson() => {
        "prodimg_id": prodimgId,
        "prodimg_prod": prodimgProd,
        "prodimg_url": prodimgUrl,
    };
}
