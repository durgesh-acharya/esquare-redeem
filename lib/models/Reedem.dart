// To parse this JSON data, do
//
//     final reedem = reedemFromJson(jsonString);

import 'dart:convert';

Reedem reedemFromJson(String str) => Reedem.fromJson(json.decode(str));

String reedemToJson(Reedem data) => json.encode(data.toJson());

class Reedem {
    Reedem({
        required this.rrId,
        required this.rrQrid,
        required this.rrQrunique,
        required this.qrRupees,
        required this.rrMadeby,
        required this.rrUpiid,
        required this.rrTranid,
        this.rrDatetime,
        required this.rrStatus,
    });

    int rrId;
    int rrQrid;
    String rrQrunique;
    int qrRupees;
    String rrMadeby;
    String rrUpiid;
    String rrTranid;
    dynamic rrDatetime;
    int rrStatus;

    factory Reedem.fromJson(Map<String, dynamic> json) => Reedem(
        rrId: json["rr_id"],
        rrQrid: json["rr_qrid"],
        rrQrunique: json["rr_qrunique"],
        qrRupees: json["qr_rupees"],
        rrMadeby: json["rr_madeby"],
        rrUpiid: json["rr_upiid"],
        rrTranid: json["rr_tranid"],
        rrDatetime: json["rr_datetime"],
        rrStatus: json["rr_status"],
    );

    Map<String, dynamic> toJson() => {
        "rr_id": rrId,
        "rr_qrid": rrQrid,
        "rr_qrunique": rrQrunique,
        "qr_rupees": qrRupees,
        "rr_madeby": rrMadeby,
        "rr_upiid": rrUpiid,
        "rr_tranid": rrTranid,
        "rr_datetime": rrDatetime,
        "rr_status": rrStatus,
    };
}
