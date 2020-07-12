import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meenal_app_project/leaddetails.dart';

import 'checklist.dart';

class Items extends StatefulWidget {
  String leadid,inspectorid;
  Items(this.leadid,this.inspectorid);
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");

 var items;
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
    print({"name": t1.text});
    // return;
    var param = {"name": t1.text,"data":"[]"};
    if (items == null) {
      items = [param];
    } else {
      items.add(param);
    }
    print(items);
    t1.text = "";
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
            'Enter item name',
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
                          hintText: "Item name",
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
            new FlatButton(
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
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Items"),
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
             print(items);
            //  return 0;
            if (items == null) {
              showsnack("Please add items");
            } else {
              print(items);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeadDetails(items,widget.leadid,widget.inspectorid)),
              );
            }
          },
          label: Row(
            children: [Text("Continue"), Icon(Icons.arrow_forward)],
          )),
      body: Container(
        margin: EdgeInsets.all(10),
        child: items == null
            ? Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Add Items",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async{
                     items = await  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Checklist(
                            items,index)),
                  );
                  print(items);
                    },
                                      child: Card(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      items[index]["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ))),
                            
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
