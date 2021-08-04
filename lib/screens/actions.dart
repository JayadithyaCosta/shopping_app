import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/page/barcode_scan.dart';
import 'package:shopping_app/screens/Home.dart';
import 'package:shopping_app/screens/Item_add.dart';


class Test extends StatefulWidget {

  @override
  _TestState createState() => _TestState();
}

// navigateToLogin() async {
//   Navigator.push(MaterialPageRoute(builder: (context)=> BarcodeScanPage()));
// }

logOut() async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();

}


  // final googleSignIn = GoogleSignIn();
  // await googleSignIn.signOut();


class _TestState extends State<Test> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey,
        body: Container(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: <Widget> [
                SizedBox(width: 200, height: 200,),
                RaisedButton(child: Text('Add Item'), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Item()),
                  );
                } , shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                ),
                SizedBox(width: 30, height: 30, ),

                RaisedButton(child: Text('Scan Item'),
                    padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    onPressed: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarcodeScanPage()),
                  );

                  padding: EdgeInsets.only(left: 50, right: 50, top: 50);
                } , shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10))),

                SizedBox(width: 100, height: 100,),

                RaisedButton(

                  padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  onPressed: () {
                    logOut;
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text('Sign Out',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                )
              ],
            ),

          ),
        ),
    );
  }
}
