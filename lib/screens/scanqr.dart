

import 'dart:io';


import 'package:esquare_redeem/screens/qrresult.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQr extends StatefulWidget {
 
  

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'qrKey');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose() {
    // TODO: implement dispose
    
    super.dispose();
   
    controller!.dispose();
    //  controller.stopCamera();
    
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
  if(Platform.isAndroid){
       controller!.pauseCamera();
  }
  controller!.resumeCamera();
  }
  
  @override
  Widget build(BuildContext context) {
    controller?.pauseCamera();
    controller?.resumeCamera();
    return Scaffold(
      body: QRView(
       
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 10,
          borderColor: Colors.green,
        ),
        key: qrKey, 
        onQRViewCreated: (QRViewController controller){
            setState(() {
              this.controller = controller;

              controller.scannedDataStream.listen((barcode) { 
                setState(() {
                  this.barcode = barcode;
                });
                controller.pauseCamera();
                controller.stopCamera();
                  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) =>  QrResult(barcode.code!),
    ),
    (Route<dynamic> route) => false
  );
              });
            });
        })
    );
  }
}


