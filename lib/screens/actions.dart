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

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Add Item'),
              onTap: () {
                if(user!.email == "admin@gmail.com"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Item()),
              );
          }
              else{
                  const snackBar = SnackBar(content: Text('Only Admin can access adding items!'));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);
              }
              }

            ),
            ListTile(
              title: const Text('Scan Item'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarcodeScanPage()));
              },
            ),
          ],
        ),
      ),

      backgroundColor: Colors.grey,
        body: Container(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: <Widget> [
                SizedBox(width: 200, height: 200,),
                RaisedButton(child: Text('Add Item'), onPressed: () {

                  if(user!.email == "admin@gmail.com"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Item()),
                    );
                  }
                  else{
                    Text("Hello User!");
                  }

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
