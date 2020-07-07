import 'package:flutter/material.dart';
import 'package:meenal_app_project/HomeScreen.dart';
import 'dart:async';

class Ordersuccess extends StatefulWidget {
  var orderid;
  Ordersuccess(this.orderid);
  @override
  _OrdersuccessState createState() => _OrdersuccessState();
}

class _OrdersuccessState extends State<Ordersuccess> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }
  
  var timer;
  startTime() async {
    var duration = new Duration(seconds: 5);
    timer = Timer(duration, route);
  }

  route() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Expanded(
            flex: 12,
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Image.asset(
                      "assets/images/success.png",
                      height: 230,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Submitted Sucessfully",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
