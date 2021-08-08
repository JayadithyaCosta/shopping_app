import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  Cart({Key? key}) : super(key: key);
  // final String title;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  late User user;
  // late Razorpay razorpay;
  late int price;
  late String phoneNumber;


  Future<void> getUserData() async{
    User? userData =  FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData!;
      print(userData.uid);
    });
  }

  Future getTotalId() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userData')
        .doc('${user.uid}')
        .collection('cartData')
        .get();
    return qn.docs.length.toString();
  }

  Future getTotal() async {
    int total = 0;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('userData')
        .doc('${user.uid}')
        .collection('cartData')
        .get();
    for (int i = 0; i < qn.docs.length; i++) {
      total = total + int.parse(qn.docs[i]['price']);
      price = total;
      //return total;
    }

    setState(() {
      price = total;
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getTotalId();
    getTotal();
    // getUsercontact();
    // razorpay = new Razorpay();
    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("userData")
                      .doc('${user.uid}')
                      .collection('cartData')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null)
                      return Text(
                        '                    No Items In The Cart',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      );
                    return Container(
                        height: 510,
                        width: 395,
                        child: ListView.separated(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot products =
                              snapshot.data!.docs[index];
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Container(
                                        padding: EdgeInsets.all(1.0),
                                        height: 80,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                            BorderRadius.circular(16)),
                                        child: Image.network(products['img']),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    products['name'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "\Rs. " + products['price'],
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        getTotalId();
                                      });
                                      FirebaseFirestore.instance
                                          .collection("userData")
                                          .doc('${user.uid}')
                                          .collection('cartData')
                                          .doc(products['id'])
                                          .delete()
                                          .then((result) {})
                                          .catchError((e) {
                                        print(e);
                                      });
                                      Scaffold.of(context)
                                          .showSnackBar(new SnackBar(
                                        content: new Text(
                                          'Deleted',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          textAlign: TextAlign.start,
                                        ),
                                        duration: Duration(milliseconds: 500),
                                        backgroundColor: Colors.pinkAccent,
                                      ));
                                    },
                                  )
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 10);
                            }));
                  }),
            ],
          ),
        ),
        bottomNavigationBar: FutureBuilder(
            future: getTotalId(),
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.only(left: 35, bottom: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FutureBuilder(
                              future: getTotal(),
                              builder: (context, price) {
                                return Text(
                                  "Total:                  " +  " Rs. " + '${price.data}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                        ],
                      ),
                    ),
                    // Divider(
                    //   height: 1,
                    //   color: Colors.grey[700],
                    // ),
                    // Container(    => This is the bottom with pay button
                    //   margin: EdgeInsets.only(right: 10),
                    //   padding: EdgeInsets.symmetric(vertical: 30),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Text("Quantity",
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w700,
                    //           )),
                    //       SizedBox(
                    //         width: 200,
                    //       ),
                          // Text(
                          //     snapshot.data != null ? snapshot.data : 'Loading',
                          //     style: TextStyle(
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.w700,
                          //     )),
                        ],
                      ),
                    //),
                    // GestureDetector(
                    //   child: Container(
                    //     margin: EdgeInsets.only(right: 25),
                    //     padding: EdgeInsets.all(25),
                    //     decoration: BoxDecoration(
                    //         color: Colors.blue[600],
                    //         borderRadius: BorderRadius.circular(15)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         Text(
                    //           "Pay",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.w900,
                    //             fontSize: 17,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     //openCheckout();
                    //   },
                    // ),
                  //],
                //),
              );
            }));
  }
}

AppBar buildAppBar() {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.redAccent,
    iconTheme: IconThemeData(color: Colors.black),
    title: Text(
      "My Orders",
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );
}
