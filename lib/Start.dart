import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        child: Column(
            children: <Widget>[

              SizedBox(height: 45),

              Container(

                child: Image(image: AssetImage("images/splash_two.png"),
                fit: BoxFit.contain
                ),
              ),
              SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                    text: 'Welcome to ',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,
                  color: Colors.black
                  ),

                    children: <TextSpan>[
                      TextSpan(
                        text: 'Scan & Pay',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
                          color: Colors.orange
                        )
                      )
                    ]
                  ),
              ),
              SizedBox(height: 10),
              Text('New styles everyday!', style: TextStyle(color: Colors.black),),

              SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[

                  RaisedButton(

                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30
                    ),

                    onPressed: () {},
                    child: Text('LOGIN', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: Colors.redAccent,
                  ),

                  SizedBox(width:20.0),

                  RaisedButton(

                    padding: EdgeInsets.only(
                        left: 30,
                        right: 30
                    ),

                    onPressed: () {},
                    child: Text('SIGN UP', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: Colors.cyan,
                  )
                ],
              )
            ],
        ),
      ),
    );
  }
}
