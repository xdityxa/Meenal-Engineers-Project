import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:meenal_app_project/HomeScreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:login/home_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");
  login() async {
    _showdialogue();
    print(jsonEncode({"mobileno": t1.text, "password": t2.text}));
    final String url =
        "https://conexo.in/dev/meenalengg/public/authenticate.php/user/login";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"mobileno": t1.text, "password": t2.text},
    );
    print("login response" + response.body);
    var jsondecoded = json.decode(response.body);
    print(jsondecoded);
    var userdata = jsondecoded["data"];
    if (jsondecoded['message'] == "success") {
      final user = await SharedPreferences.getInstance();
      user.setString('session_token', userdata["session_token"]);
      user.setString('masterhash', userdata["masterhash"]);
      user.setString('fullname', userdata["fullname"]);
      user.setString('mobileno', userdata["mobileno"]);
      user.setString('email', userdata["email"]);
      print(user.toString());
      // await gsmtoken();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (jsondecoded["message"] == "invalid_credentials") {
      Navigator.pop(context);
      showsnack("Mobile or Password incorrect");
    } else if (jsondecoded["message"] == "missing_parameters") {
      showsnack("please enter valid mobile no. nad password");
    } else if (jsondecoded["message"] == "some_error_has_ouccered") {
      Navigator.pop(context);
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
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 25.0),
                  height: 70,
                  child: Image.asset(
                    'assets/images/company_logo.jpeg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 50.0, bottom: 10.0),
                          child: TextFormField(
                            controller: t1,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.length != 10 || value.isEmpty) {
                                return 'Please enter Mobile no.';
                              }
                            },
                            autofocus: false,
                            // initialValue: 'abc@gmail.com',
                            decoration: InputDecoration(
                              labelText: 'Mobile No.',

                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty || value.length < 6)
                              return 'Password must be atleast 6 characters long';
                          },
                          autofocus: false,
                          // initialValue: 'some password',

                          obscureText: true,
                          controller: t2,
                          decoration: InputDecoration(
                            labelText: 'Password',

                            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        login();
                      }
                      // Navigator.of(context).pushNamed('home');
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.blue,
                    child:
                        Text('Log In', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
