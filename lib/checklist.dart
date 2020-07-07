import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meenal_app_project/leaddetails.dart';

class Checklist extends StatefulWidget {
  String leadid,inspectorid;
  Checklist(this.leadid,this.inspectorid);
  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");

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

  addparam() {
    print({"key": t1.text, "value": t2.text});
    // return;
    var param = {"key": t1.text, "value": t2.text};
    if (special == null) {
      special = [param];
    } else {
      special.add(param);
    }
    print(special);
    t1.text = "";
    t2.text = "";
    setState(() {});
    Navigator.pop(context);
  }

  void remarks() {
    // flutter defined function
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
                addparam();
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
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Checklist"),
        actions: [
          GestureDetector(
              onTap: () {
                remarks();
              },
              child: Container(padding: EdgeInsets.all(10),child: Icon(Icons.add)))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
       
          onPressed: () {
             print(special);
            //  return 0;
            if (special == null) {
              showsnack("Please add parameters");
            } else {
              print(special);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeadDetails(special,widget.leadid,widget.inspectorid)),
              );
            }
          },
          label: Row(
            children: [Text("Continue"), Icon(Icons.arrow_forward)],
          )),
      body: Container(
        margin: EdgeInsets.all(10),
        child: special == null
            ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/no_parameter.png',),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text('No parameters yet', style: TextStyle(
                        color: Colors.grey
                      ),),)
                  ],
                ),
            )
            : ListView.builder(
                itemCount: special.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Text((index+1).toString() + ')', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15)),
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
                                  margin: EdgeInsets.symmetric(vertical:5, horizontal: 17),
                                  child: Text(
                                    special[index]["value"],
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
