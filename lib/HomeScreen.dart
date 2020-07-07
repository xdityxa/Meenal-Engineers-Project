import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meenal_app_project/checklist.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'LoginScreen.dart';

class HomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    fetchdetails();
    fetchorders();
  }

 var name;
  var mobileno;


    fetchdetails()
async{
    final user = await SharedPreferences.getInstance();
    name=user.getString("fullname");
    mobileno=user.getString("mobileno");
    print(name);
    print(mobileno);
    setState(() {
      
    });

}



    var orders;
    var flag=1;
   fetchorders() async {
    final user = await SharedPreferences.getInstance();
     print(jsonEncode({"masterhash": user.getString("masterhash")}));
    print(user.getString("deliveryhash"));
    final String url =
        "https://conexo.in/dev/meenalengg/public/listing.php/singleuser/leads";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {"accept": "application/json"},
        body: {"masterhash": user.getString("masterhash")});
    ////print("login response"+response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      setState(() {
        orders = jsondecoded["data"];
      });
    } else if (jsondecoded['message'] == "no_lead_found") {
      flag=0;
      setState(() {
      });
      showsnack("No orders available");
    } else {
      showsnack("Some error has ouccered");
    }
  }





  void _showdialogue() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(child: CircularProgressIndicator()),
          );
        });
  }

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Leads"),
      ),
      drawer: name==null?CircularProgressIndicator(): Drawer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Important: Remove any padding from the ListView.
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            backgroundBlendMode: BlendMode.darken),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 24,
                              child: Text(name[0], style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),)
                            ),
                            Container(
                              // color: Colors.amber,
                              padding: EdgeInsets.only(left: 10,),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(name.length>13?name.substring(0,13)+"..":name,
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 17.0)),
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                  ),
                                  Text(mobileno,
                                      style: TextStyle(
                                          color:  Colors.grey[600],
                                          fontSize: 15.0)),
                                  
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Log out '),
                        onTap: () async{
                          final user = await SharedPreferences.getInstance();
                        user.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                        },
                      ),
                      
                    ],
                  ),
                ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal:5),
        child:flag==0
                        ? Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Image.asset(
                                    "assets/noorders.png",
                                    height: 230,
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No upcoming leads",
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              
                            ],
                          )
                        : orders == null
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    :  ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Checklist(
                            orders[index]["id"],orders[index]["inspector"])),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)

                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Status:  ",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                             "Pending",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/delivery-truck.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Container(
                                          margin: EdgeInsets.all(5),
                                          child: Text(
                                            "Company name:",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child: Text(
                                           orders[index]["companyname"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.blueGrey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ],),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              "Address:",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            )),
                                            Container(
                                              margin: EdgeInsets.all(5),
                                                child: Container(
                                                  width: 130,
                                              
                                              child: Text(
                                                "124 San Francisco, CA",
                                                maxLines: 5,
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.all(5),
                                                child: Text(
                                                  "Date :",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                                margin: EdgeInsets.all(5),
                                                child: Text(
                                                  "12-12-20",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
