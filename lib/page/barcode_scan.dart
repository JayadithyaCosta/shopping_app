import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/screens/Cart.dart';
import 'package:shopping_app/screens/Item_add.dart';
import 'package:shopping_app/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarcodeScanPage extends StatefulWidget {
  @override
  _BarcodeScanPageState createState() => _BarcodeScanPageState();

}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  String barcode = 'Unknown';
  final user = FirebaseAuth.instance.currentUser;


  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) =>
      Scaffold(
        floatingActionButton: floatingBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('images/header.png'),
                        fit: BoxFit.cover)
                ),
                child: Text(''),
              ),
              ListTile(
                leading: Icon(Icons.home_filled),
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarcodeScanPage()));
                },
              ),
              ListTile(
                  title: const Text('Add Item'),
                  leading: Icon(Icons.input),
                  onTap: () {
                    if (user!.displayName == "admin") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Item()),
                      );
                    }

                    else {
                      const snackBar = SnackBar(
                          content: Text('Only Admins can access adding items!'));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    }
                  }

              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: const Text('Your Shopping Cart'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: const Text('Log Out'),
                onTap: () {
                  logOut();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Tap Button To Start!',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      );

  Widget floatingBar() => Ink(
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
      ),
    child: FloatingActionButton.extended(
        onPressed: (){
          scanBarcodeNormal();
        },
        backgroundColor: Colors.black,
      icon: Icon(
        FontAwesomeIcons.barcode,
        color: Colors.pinkAccent,
      ),
      label: Text(
        "SCAN",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
      );

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (barcodeScanRes != '-1') {
      return showDialog(
          context: context,
          builder: (context) {
            return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .where("barcode", isEqualTo: '$barcodeScanRes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );//or return a black container if you don't want to show anything while fetching data from firestore
                  }
                  else if (snapshot.data!.docs.isEmpty) {
                    return Dialog(
                      child: Container(
                        height: 80,
                        child: Text('Product Not Found', textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'STIX Two Text',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                        ),
                        ),
                      ),
                    );
                  } else {
                    return Dialog(
                      child: Container(
                        height: 350,
                        child: Column(children: [
                          Container(
                              height: 350,
                              width: 165,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot products =
                                  snapshot.data!.docs[index];
                                  return ScanCard(products: products);
                                },
                              )),
                        ]),
                      ),
                    );
                  }
                });
          });
    }
  }


}


class ScanCard extends StatelessWidget {
  const ScanCard({
     Key? key,
    required this.products,
  }) : super(key: key);
  final DocumentSnapshot products;


  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    String _userId = user!.uid;


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          height: 180,
          width: 160,
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(16)),
          child: Image.network(products['img']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            products['name'],
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              "Size: " + products['size'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.brown),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "\tRs. " + products['price'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              width: 40,
            ),
            Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
              size: 25,
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.red,
              child: Text(
                "Add to cart",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('userData')
                    .doc(_userId)
                    .collection('cartData')
                    .doc();
                documentReference.set({
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                  'barcode': products['barcode'],
                  'img': products['img'],
                  'name': products['name'],
                  'size': products['size'],
                  'price': products['price'],
                  'id': documentReference.id
                }).then((result) {
                  addToCartMessage(context).then((value) => {
                    Navigator.pop(context)
                  });
                }).catchError((e) {
                  print(e);
                });
               },
            ),
          ),
        )
      ],
    );
  }
}


Future<dynamic> addToCartMessage(BuildContext context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){


        return AlertDialog(
          content: Text(
            'Added To Cart Successfully!',
            style: TextStyle(fontSize: 20.0, color: Colors.black),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              onPressed: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarcodeScanPage()),
                  );
                },
            ),
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18, color: Colors.deepOrange),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                  ).then((value) => {
                    Navigator.pop(context)
                });
              },

            )
          ],
        );
      }
  );
}