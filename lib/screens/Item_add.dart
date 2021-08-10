import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app/page/barcode_scan.dart';
import 'dart:io';

import 'package:shopping_app/screens/Home.dart';

 String imageUrl= 'https://previews.123rf.com/images/bsd555/bsd5551808/bsd555180800806/119694111-select-items-concept-icon-choosing-goods-or-services-idea-thin-line-illustration-parcel-tracking-vec.jpg';


class Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuthDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirebaseAuthDemo extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<FirebaseAuthDemo>{

  TextEditingController _barcodeEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();
  final TextEditingController _sizeEditingController = TextEditingController();

  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('products');
  String itemCode= '0000';


  gotoBarcodeScan(BuildContext context){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScanPage()),
    );

  }
@override
  void initState() {
    super.initState();

    imageUrl = 'https://previews.123rf.com/images/bsd555/bsd5551808/bsd555180800806/119694111-select-items-concept-icon-choosing-goods-or-services-idea-thin-line-illustration-parcel-tracking-vec.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Item'), backgroundColor: Colors.redAccent,),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            (imageUrl != null)
            ? Image.network(imageUrl)
            : Placeholder(fallbackHeight: 1000.0, fallbackWidth: 500,),
            ButtonTheme(
              minWidth: 200,
              height: 10,
                child: IconButton(
                  color: Colors.lightBlue,
                  icon: const Icon(Icons.upload_file),
                  iconSize: 30,
                  onPressed: () => {
                    showAlertDialog(context),
                  },
                ),

            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.7,
                  child: TextFormField(
                    controller: _barcodeEditingController,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "$itemCode"
                      // hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                      // icon: IconButton(
                      //   onPressed: () {
                      //
                      //     scanBarcode();
                      //     itemCode= _barcodeEditingController.text;
                      //   },
                      //   icon: Icon(Icons.qr_code_scanner_sharp),
                      // ),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 30,
                  child: RaisedButton(
                    child: Text('SCAN', style: TextStyle( fontWeight: FontWeight.bold),),
                    onPressed: (){
                      setState(() {
                        print(itemCode);
                        itemCode = _barcodeEditingController.text;
                      });
                    },
                ),
                )
              ],
            ),

            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 1.7,
            //   child: TextFormField(
            //     controller: _imageEditingController,
            //     style: TextStyle(fontSize: 22, color: Colors.black),
            //     decoration: InputDecoration(
            //       hintText: "Image URL",
            //       hintStyle: TextStyle(fontSize: 22, color: Colors.black),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextFormField(
                controller: _nameEditingController,
                style: TextStyle(fontSize: 22, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Brand",
                  hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextFormField(
                controller: _priceEditingController,
                style: TextStyle(fontSize: 22, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextFormField(
                controller: _sizeEditingController,
                style: TextStyle(fontSize: 22, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Size",
                  hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              child: ElevatedButton(
                  onPressed: () async {
                    await collectionReference.add({
                      'barcode': itemCode,
                      'img': imageUrl,
                      'name': _nameEditingController.text,
                      'price': _priceEditingController.text,
                      'size': _sizeEditingController.text

                    }).then((result) =>
                        gotoBarcodeScan(context)
                    );
                  },
                  child: Text(
                    'Add Data',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          ],

        ),
      ),
    );
  }

  //Camera snap
  Future snapImage() async{

    final _storage = FirebaseStorage.instance;

    final _picker = ImagePicker();
    PickedFile cameraImage;

    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    var file = File(pickedFile!.path);

    if(pickedFile != null){

      DateTime currentDate = new DateTime.now();
      //Upload to firebase
      var snapshot = await _storage.ref()
          .child('/added_images/$currentDate')
          .putFile(file)
          .whenComplete(() => null);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });

    }else{
      print("No path received!");
    }
  }

  // Gallery
  uploadImage() async{
    final _storage = FirebaseStorage.instance;

    final _picker = ImagePicker();
    PickedFile image;

    

    //Check permission
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if(permissionStatus.isGranted){

      //Select Image
      image = (await _picker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);

      if(image != null){

        DateTime currentdate = new DateTime.now();


        //Upload to firebase
        var snapshot = await _storage.ref()
            .child('/added_images/$currentdate')
            .putFile(file)
            .whenComplete(() => null);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });

      }else{
        print("No path received!");
      }

    }else{
      print('Grant Permission and continue!');
    }


  }

  late Timer _timer;

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget remindButton = TextButton(
      child: Text("Camera"),
      onPressed:  () => {
        snapImage()
      }
    );
    Widget cancelButton = TextButton(
      child: Text("Gallery"),
      onPressed:  () =>{
        uploadImage(),
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Image.network("https://cdn4.iconfinder.com/data/icons/ionicons/512/icon-camera-512.png", width: 150, height: 150, fit: BoxFit.contain,),
      actions: [

        remindButton,
        cancelButton,

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _timer = Timer(Duration(seconds: 5), () {
          Navigator.of(context).pop();
        });
        return alert;

      },
    ).then((value) => {
    if (_timer.isActive) {
        _timer.cancel()
  }
    });
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      setState(() {
        itemCode = barcodeScanRes;
      });
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // if(barcodeScanRes != "-1"){
    //
    //   _barcodeEditingController = barcodeScanRes;
    // }
  }

}
