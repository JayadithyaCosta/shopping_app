import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarcodeScanPage extends StatefulWidget {
  @override
  _BarcodeScanPageState createState() => _BarcodeScanPageState();

}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  String barcode = 'Unknown';

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        floatingActionButton: floatingBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        appBar: AppBar(
          title: Text(MyApp.title),
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
                  if (!snapshot.hasData) {
                    return Dialog(
                      child: Container(
                        height: 300,
                        child: Text('Product Not Found'),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          height: 180,
          width: 160,
          decoration: BoxDecoration(
              color: Color(0xFF3D82AE),
              borderRadius: BorderRadius.circular(16)),
          child: Image.network(products['img']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            products['name'],
            style: TextStyle(
              color: Color(0xFF535353),
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
              width: 60,
            ),
            Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
              size: 27,
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
              color: Color(0xFFE8284F),
              child: Text(
                "Add to cart",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                addToCartMessage(context);
              //   DocumentReference documentReference = FirebaseFirestore.instance
              //       .collection('userData')
              //       .collection('cartData')
              //       .document();
              //   documentReference.setData({
              //     'uid': _userId,
              //     'barcode': products['barcode'],
              //     'img': products['img'],
              //     'name': products['name'],
              //     'netweight': products['netweight'],
              //     'price': products['price'],
              //     'id': documentReference.documentID
              //   }).then((result) {
              //     dialogTrigger(context);
              //   }).catchError((e) {
              //     print(e);
              //   });
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
                  'Alright',
                  style: TextStyle(fontSize: 18, color: Colors.deepOrange),
                ),
              onPressed: (){
                  Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );
}