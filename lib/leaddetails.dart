import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:meenal_app_project/signature_screen.dart';

class LeadDetails extends StatefulWidget {
  var checklist, leadid, inspectorid;
  LeadDetails(this.checklist, this.leadid, this.inspectorid);
  @override
  _LeadDetailsState createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
  var data;

  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");
  final TextEditingController t3 = new TextEditingController(text: "");
  final TextEditingController t4 = new TextEditingController(text: "");


  submit() {
    print(widget.checklist);

    data = {
      "leadid": widget.leadid,
      "inspectorid": widget.inspectorid,
      "siterepresentativename": t1.text,
      "designation": t2.text,
      "phoneno": t3.text,
      "remarks": t4.text
    };
    data["data"] = widget.checklist;

    print(data);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignatureScreen(data)),
    );
  }

 
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("hey" + widget.checklist.toString());
  }

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Site Representative Details"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (t1.text == "" || t2.text == "" || t3.text == "" ) {
              showsnack("Please enter valid details");
            } else {
              if (t3.text.length != 10) {
                showsnack("Please enter valid mobile no.");
              } else {
                submit();
              }
            }
          },
          label: Row(
            children: [Text("Continue"), Icon(Icons.arrow_forward)],
          )),
      body: Container(
        margin: EdgeInsets.symmetric(vertical:10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Name', icon: Icon(Icons.person)),
              controller: t1,
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Designation', icon: Icon(Icons.description)),
              controller: t2,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone Number', icon: Icon(Icons.phone)),
              controller: t3,
              keyboardType:TextInputType.number,
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),

            TextField(
              decoration: InputDecoration(labelText: 'Remarks', icon: Icon(Icons.edit)),
              controller: t4,
              keyboardType:TextInputType.text,
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            
          ],
        ),
      ),
    );
  }
}
