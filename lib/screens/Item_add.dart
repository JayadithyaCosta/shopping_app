import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/page/barcode_scan.dart';
import 'package:shopping_app/screens/actions.dart';

class Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuthDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirebaseAuthDemo extends StatelessWidget {
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
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
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextFormField(
                controller: _imageEditingController,
                style: TextStyle(fontSize: 22, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Image URL",
                  hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
            ),
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
                      'img': _imageEditingController.text,
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
}