

// To parse this JSON data, do
//
//     final prod = prodFromJson(jsonString);

import 'dart:convert';

Prod prodFromJson(String str) => Prod.fromJson(json.decode(str));

String prodToJson(Prod data) => json.encode(data.toJson());

class Prod {
    Prod({
        required this.prodId,
        required this.prodCate,
        required this.prodSubcate,
        required this.prodName,
        required this.prodDescription,
        required this.prodUrl,
        required this.prodStatus,
    });

    int prodId;
    int prodCate;
    int prodSubcate;
    String prodName;
    String prodDescription;
    String prodUrl;
    int prodStatus;

    factory Prod.fromJson(Map<String, dynamic> json) => Prod(
        prodId: json["prod_id"],
        prodCate: json["prod_cate"],
        prodSubcate: json["prod_subcate"],
        prodName: json["prod_name"],
        prodDescription: json["prod_description"],
        prodUrl: json["prod_url"],
        prodStatus: json["prod_status"],
    );

    Map<String, dynamic> toJson() => {
        "prod_id": prodId,
        "prod_cate": prodCate,
        "prod_subcate": prodSubcate,
        "prod_name": prodName,
        "prod_description": prodDescription,
        "prod_url": prodUrl,
        "prod_status": prodStatus,
    };
}
