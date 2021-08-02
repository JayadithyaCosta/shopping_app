import 'package:flutter/material.dart';
import 'package:shopping_app/page/barcode_scan.dart';
import 'package:shopping_app/screens/Home.dart';


class Test extends StatefulWidget {

  @override
  _TestState createState() => _TestState();
}

// navigateToLogin() async {
//   Navigator.push(MaterialPageRoute(builder: (context)=> BarcodeScanPage()));
// }


class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          child: Column(
            children: <Widget> [
              RaisedButton(child: Text('Add Item'), onPressed: () {} , shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10))),
              RaisedButton(child: Text('Scan Item'), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarcodeScanPage()),
                );
              } , shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10))),
            ],
          ),
        ),
    );
  }
}
