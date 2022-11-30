import 'dart:convert';
import 'dart:developer';
import 'package:agora_video_call/model/Contact.dart';
import 'package:agora_video_call/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogin = false;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<User> callerInfoList = <User>[];

  var loginUserPhone = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogins();
  }

  Future<void> isLogins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('isLogin') ?? false;
    if (!isLogin) {
      Navigator.pushNamed(context, "phone");
    } else {
      getContactList();
    }
  }

  Future<void> getContactList() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Loading......'),
        backgroundColor: Colors.green,
      ));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdata = prefs.getString('user');
      Map<String, dynamic> map = jsonDecode(userdata!);

      var response = await ApiClient().contactList(map['app_token']);

      if (!response.error) {
        setState(() {
          callerInfoList = response.user!.toList();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("This is loadded"),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Someting went wrong..'),
        backgroundColor: Colors.green,
      ));
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          backgroundColor: Colors.green.shade600,
        ),
        body: ListView.builder(
            itemCount: callerInfoList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(callerInfoList[index].name.toString()),
                  leading: CircleAvatar(
                      child: Image.network(callerInfoList[index].profile.toString())),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.call,
                    ),
                    iconSize: 30,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {},
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: const Icon(Icons.logout),
            backgroundColor: Colors.green,
            onPressed: () async {
              print("logout");
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushNamed(context, "phone");
            }));
  }
}
