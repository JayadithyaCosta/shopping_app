import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_app/Start.dart';
import 'package:shopping_app/page/barcode_scan.dart';
import 'package:shopping_app/screens/Home.dart';
import 'package:shopping_app/widget/button_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  static final String title = 'Barcode Scanner';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.red[800],
          scaffoldBackgroundColor: Colors.white,
        ),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[400]
      ),
      home: Start() ,
    );
  }
  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       appBar: AppBar(
  //         title: Text(widget.title),
  //       ),
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             ButtonWidget(
  //               text: 'Scan Barcode',
  //               onClicked: () => Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (BuildContext context) => BarcodeScanPage(),
  //               )),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
}
