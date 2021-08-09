import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/auth/sign_in.dart';
import 'package:shopping_app/page/barcode_scan.dart';
import 'package:shopping_app/screens/Cart.dart';
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
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  //
  // checkAuthentication() async {
  //   _auth.authStateChanges().listen((user) {
  //     if (user != null) {
  //       print(user);
  //
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
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
      appBar: AppBar(
        title:(
            Align(
              alignment: Alignment.topLeft,
              child: Text('Home'),
            )
        ),
        actions:<Widget> [
          IconButton(
              icon: Icon(Icons.shopping_cart), color: Colors.white,
              onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                );
              }
          )
        ],
      ),
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
                  image: DecorationImage(image: AssetImage('images/header.png'),
                      fit: BoxFit.cover)
              ),
              child: Text(''),
            ),
            ListTile(
                title: const Text('Add Item'),
                leading: Icon(Icons.input),
                onTap: () {
                  if (user!.email == "admin@gmail.com") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Item()),
                    );
                  }
                  else if(user!.email == "nalin.wijemanne@gmail.com"){

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Item()),
                    );
                  }
                  else if(user!.email == "domain@gmail.com"){

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
              leading: Icon(Icons.scanner),
              title: const Text('Scan Item'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarcodeScanPage()));
              },
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
            )
          ],
        ),

      ),

    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
      children: [
            SizedBox(
              height: 30,
          ),

        Padding(
          padding: const EdgeInsets.all(8.0),
            child: Text(
              'Clothes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'STIX Two Text'),
          ),
        ),
        buildStreamClothes()
        ],
      ),

      //     backgroundColor: Colors.grey,
      //       body: Scaffold(
      //         floatingActionButton: null,
      //         body: StreamBuilder(
      //           stream: FirebaseFirestore.instance.collection("products").snapshots(),
      //           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //             if (!snapshot.hasData) {
      //               return Center(
      //                 child: CircularProgressIndicator(),
      //               );
      //             }
      //             return ListView(
      //                 children: snapshot.data.docs.map((document) {
      //                   var url = document['img'];
      //                 }
      //                 ));
      //           }
      //           ),
      //   ));
    )
    );
  }



  StreamBuilder<QuerySnapshot> buildStreamClothes() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 650,
              child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data!.docs[index];
                    return ItemCard(products: products);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 150);
                  }));
          // ));
        });
  }


}


class ItemCard extends StatelessWidget {
  const ItemCard({
     Key? key,
    required this.products,
  }) : super(key: key);

  final DocumentSnapshot products;

  @override
  Widget build(BuildContext context) {
    //String _userId;

    final String _userId = FirebaseAuth.instance.currentUser!.uid;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          height: 180,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12)),
          child: Image.network(products['img']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            products['name'],
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\Rs. " + products['price'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 30,
            ),
            GestureDetector(
              child: Icon(
                CupertinoIcons.cart_fill_badge_plus,
                color: Colors.black,
                size: 30,
              ),
              onTap: () {
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('userData')
                    .doc(_userId)
                    .collection('cartData')
                    .doc();
                documentReference
                    .set({
                  'uid': _userId,
                  'barcode': products['barcode'],
                  'img': products['img'],
                  'name': products['name'],
                  'size': products['size'],
                  'price': products['price'],
                  'id': documentReference.id
                })
                    .then((result) {})
                    .catchError((e) {
                  print(e);
                });
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text(
                    'Added to Cart',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                  duration: Duration(milliseconds: 300),
                  backgroundColor: Color(0xFF3D82AE),
                ));
              },
            ),
          ],
        )
      ],
    );
  }
}