import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Scan Result',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$barcode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 72),
              ButtonWidget(
                text: 'Start Barcode scan',
                onClicked: scanBarcodeNormal,
              ),
            ],
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
              "netweight- " + products['netweight'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "\n " + products['price'],
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
              color: Color(0xFF3D82AE),
              child: Text(
                "Add to cart",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
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