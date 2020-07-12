import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meenal_app_project/leaddetails.dart';

class Checklist extends StatefulWidget {
  var items, index;
  Checklist(this.items, this.index);
  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");
  List<Map<String, String>> items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // special = widget.items;
    items = widget.items;
    if (items[widget.index]["data"] == "[]") {
      print("object");
      // special = [
      //   {"key": "serial no", "value":""},
      //   {"Key": "Make", "value":""},
      //   {"Key": "Capacity", "value":""},
      //   {"Key": "Location", "value":""},
      //   {"Key": "Dimention/Measurements", "value":""},
      //   {"Key": "Remarks/observations", "value":""}
      // ];

       special = [
        {"key": "serial no", "value":""},
        {"key": "Make", "value":""},
        {"key": "Capacity", "value":""},
        {"key": "location", "value":""},
        {"key": "Dimention/Measurements", "value":""},
        {"key": "Remarks/observations", "value":""}
      ];
      print(special.length);
      setState(() {});
    } else {
      special = jsonDecode(items[widget.index]["data"]);
    }
  }

  var special;
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

  addparam(index) {
    print({"key": t1.text, "value": t2.text});
    // return;
    var param = {"key": t1.text, "value": t2.text};
    // if (special == null) {
    //   special = [param];
    // } else {
    //   special.add(param);
    // }
    special[index]["value"] = t2.text;
    print(special);
    t1.text = "";
    t2.text = "";
    setState(() {});
    Navigator.pop(context);
  }

  void remarks(index) {
    // flutter defined function
    t1.text = special[index]["key"];
    t2.text=special[index]["value"];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'Enter Parameter',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Container(
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    TextField(
                        controller: t1,
                        inputFormatters: [
                          new WhitelistingTextInputFormatter(
                              RegExp("[a-zA-Z0-9 ]")),
                        ],
                        decoration: new InputDecoration(
                          labelText: "Parameter",
                        )),
                    TextField(
                        controller: t2,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        inputFormatters: [
                          new WhitelistingTextInputFormatter(
                              RegExp("[a-zA-Z0-9 .]")),
                        ],
                        decoration: new InputDecoration(
                          hintText: "Value",
                        )),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: new Text("Add"),
              onPressed: () {
                // creteorder();
                addparam(index);
              },
            ),
          ],
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        // Navigator.pop(context,it)
          print(special);
              //  return 0;
              if (special == null) {
                showsnack("Please add parameters");
              } else {
                print(special);
                print("hey");
                print(items[widget.index]["data"]);
                items[widget.index]["data"] = jsonEncode(special);
                print("hey");
                print(items);
                // return;
                Navigator.pop(context, items);
              }
      },
          child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text("Checklist"),
          
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              print(special);
              //  return 0;
              if (special == null) {
                showsnack("Please add parameters");
              } else {
                print(special);
                print("hey");
                print(items[widget.index]["data"]);
                items[widget.index]["data"] = jsonEncode(special);
                print("hey");
                print(items);
                // return;
                Navigator.pop(context, items);
              }
            },
            label: Row(
              children: [Text("Continue"), Icon(Icons.arrow_forward)],
            )),
        body: Container(
          margin: EdgeInsets.all(10),
          child: items[widget.index]["data"] == null
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/no_parameter.png',
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'No parameters yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: special.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        remarks(index);
                      },
                      child: Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Text((index + 1).toString() + ')',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: Text(
                                            special[index]["key"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ))),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 17),
                                      child: Text(
                                        special[index]["value"],
                                        style: TextStyle(fontSize: 15),
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
