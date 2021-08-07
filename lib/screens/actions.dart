import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/auth/sign_in.dart';
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

// logOut() async{
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   await auth.signOut();
//
// }

Future<void> logOut() async {
  await FirebaseAuth.instance.signOut();
}


  // final googleSignIn = GoogleSignIn();
  // await googleSignIn.signOut();


class _TestState extends State<Test> {

  final user = FirebaseAuth.instance.currentUser;
  //final FirebaseAuth _auth = FirebaseAuth.instance;


  // checkAuthentication() async {
  //   _auth.authStateChanges().listen((user) {
  //     if (user != null) {
  //       print(user);
  //
  //       Navigator.pushReplacementNamed(context, "/");
  //     }
  //   });
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   this.checkAuthentication();
  // }

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
                image: DecorationImage(image: NetworkImage('https://cdn.dribbble.com/users/879147/screenshots/11116516/media/5c26ba9c6dde85a17f99dc89ddd08f84.png?compress=1&resize=400x300'),fit: BoxFit.cover )
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Text('Add Item'),
              leading: Icon(Icons.input),
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
              leading: Icon(Icons.scanner),
              title: const Text('Scan Item'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarcodeScanPage()));
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
            )
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
