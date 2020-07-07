import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meenal_app_project/HomeScreen.dart';
import 'package:signature/signature.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:path/path.dart' show join;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'LoginScreen.dart';

class SignatureScreen extends StatefulWidget {
  var data;
  SignatureScreen(this.data);
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  var data;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    _controller.addListener(() => print("Value changed"));
  }

  uploadsignature(path) async {
    print("object");
    StorageReference storageReference;
    storageReference =
        FirebaseStorage.instance.ref().child("signatures/${DateTime.now()}");
    print("object");
    final StorageUploadTask uploadTask = storageReference.putFile(File(path));
    print("object");

    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    data["signature"] = url;
    print(data);
    File(path).delete();
    Navigator.pop(context);
    confirm();
  }

  var orders;
  submit() async {
    _showdialogue();
    final user = await SharedPreferences.getInstance();
    data["masterhash"] = user.getString("masterhash");

    print(data);
    Map x = jsonDecode(data);
    // return;
    final String url =
        "https://conexo.in/dev/meenalengg/public/listing.php/lead/create";
    var response = await http.post(
        //encode url
        Uri.encodeFull(url),
        headers: {"accept": "application/json"},
        body: {"key":jsonEncode(data)}
        );
    print("login response"+response.body);
    return;
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);

    if (jsondecoded['message'] == "success") {
      print("success");
      setState(() {
        // orders = jsondecoded["data"];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else if (jsondecoded['message'] == "no_lead_found") {
      setState(() {});
      showsnack("No orders available");
    } else {
      showsnack("Some error has ouccered");
    }
  }

  void _showdupload() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // title: new Text('Compressing...'),
            children: <Widget>[
              Image.asset(
                "assets/images/upload.png",
                height: 100,
                width: 100,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Uploading...",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        });
  }

  showsnack(String message) {
    ////print(message);
    final snackBar = SnackBar(content: Text(message));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Future<bool> confirm() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to submit the details?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  if (data["signature"] == null) {
                    showsnack("Please sign the checklist");
                  } else {
                    submit();
                  }
                }),
          ],
        );
      },
    );
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

  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                key: _scaffoldkey,
          body: ListView(
            children: <Widget>[
              Container(
                color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                  child: Text(
                    'Enter your signature below',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
              //SIGNATURE CANVAS
              Signature(
                controller: _controller,
                height: MediaQuery.of(context).size.height * 0.8,
                backgroundColor: Colors.white,
              ),
              //OK AND CLEAR BUTTONS
              Container(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //SHOW EXPORTED IMAGE IN NEW ROUTE
                    IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () async {
                        if (_controller.isNotEmpty) {
                          _showdupload();
                          var data = await _controller.toPngBytes();
                          int rand = new Math.Random().nextInt(10000);

                          final path = join(
                            (await getTemporaryDirectory()).path,
                            '${rand}.png',
                          );
                          new File(path)..writeAsBytesSync(data);
                          //  ..writeAsBytesSync(img.encodeJpg(gambarKecilx, quality: 95));
                          uploadsignature(path);

                          // confirm();
                        } else {
                          showsnack("Please sign the checklist");
                        }
                      },
                    ),
                    //CLEAR CANVAS
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.white,
                      onPressed: () {
                        setState(() => _controller.clear());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        
      
    );
  }
}
