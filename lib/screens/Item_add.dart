import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app/page/barcode_scan.dart';
import 'dart:io';

 String imageUrl= '';


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

  final TextEditingController _barcodeEditingController = TextEditingController();
  final TextEditingController _imageEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();
  final TextEditingController _sizeEditingController = TextEditingController();

  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('products');



  gotoBarcodeScan(BuildContext context){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScanPage()),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Item')),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            (imageUrl != null)
            ? Image.network(imageUrl)
            : Placeholder(fallbackHeight: 1000.0, fallbackWidth: 500,),
            RaisedButton(
                child: Text('Upload Image'),
                color: Colors.lightBlue,
                onPressed: () => uploadImage(),
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
                      hintText: "Item Code",
                      hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                  ),
                ),
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
                      'barcode': _barcodeEditingController.text,
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

        //Upload to firebase
        var snapshot = await _storage.ref()
            .child('folder/ImageName')
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
}
