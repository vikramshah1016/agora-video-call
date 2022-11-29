import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:agora_video_call/static/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List callerInfoList = [];
  var loginUserPhone="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCallerInfoList();
  }

  void fetchCallerInfoList()async{
    var ApiUrl = StaticValues.apiURL;
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');

    Map<String, dynamic> _userData = jsonDecode(userData!);
    // print(jsonDecode(userData.toString()));

    late final response;
    try {
      // response = await http.post(
      //   Uri.parse("$ApiUrl/contact-list"),
      //   headers: {
      //     HttpHeaders.contentTypeHeader: "application/json",
      //     'Authorization': 'Bearer $token',
      //   },
      //   body: jsonEncode(<String, String>{
      //     'mobile': mobilenumber
      //   }),
      // );
    }
    catch (e) {
      log(e.toString());
    }
  }
  //
  @override
  Widget build(BuildContext context) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case '/users':
        if (arguments is String) {
          // the details page for one specific user
          return UserDetails(arguments);
        }
        else {
          // a route showing the list of all users
          return UserList();
        }
      default:
        return null;
    }
    return Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            backgroundColor: Colors.green.shade600,
          ),
          body: ListView.builder(
              itemCount: callerInfoList.length,
              itemBuilder: (context, index) {
                return  Card(
                  child: ListTile(
                    title: Text(callerInfoList[index]['mobile']),
                    leading: CircleAvatar(
                        child: Image.network(
                            "https://img.favpng.com/3/7/23/login-google-account-computer-icons-user-png-favpng-ZwgqcU6LVRjJucQ9udYpX00qa.jpg")),
                    trailing:IconButton(
                      icon: Icon(
                        Icons.directions_transit,
                      ),
                      iconSize: 50,
                      color: Colors.green,
                      splashColor: Colors.purple,
                      onPressed: () {},
                    ),
                  ),
                );
              }),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.logout),
              backgroundColor: Colors.green,
              onPressed: () async{
                Navigator.pushNamed(context, "phone");
              }
          )
      );
  }
}
