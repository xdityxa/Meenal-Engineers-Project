import 'package:flutter/material.dart';
import 'package:meenal_app_project/HomeScreen.dart';
import 'package:meenal_app_project/LoginScreen.dart';
import 'nointernet.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Meenal Engineers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Meenal Engineers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    checkinternet();
  }

  checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final user = await SharedPreferences.getInstance();

        if (user.getString("session_token") == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          checksession();
        }
      }
    } on SocketException catch (_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoInternet()));
    }
  }

  checksession() async {
    final user = await SharedPreferences.getInstance();

    final String url =
        "https://conexo.in/dev/meenalengg/public/authenticate.php/user/checksession";
    var response = await http.post(
      //encode url
      Uri.encodeFull(url),
      headers: {"accept": "application/json"},
      body: {"sessiontoken": user.getString("session_token")},
    );
    //print("login response"+response.body);
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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (jsondecoded["message"] == "session_expired") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else if (jsondecoded["message"] == "something_went_worng") {
      // showsnack("Some error has ouccered");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 0),
                child: Image.asset(
                  'assets/images/company_logo.jpeg',
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            Container(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
