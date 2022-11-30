import 'package:agora_video_call/videoConference/join_with_code.dart';
import 'package:agora_video_call/login/phone.dart';
import 'package:agora_video_call/login/verify.dart';
import 'package:flutter/material.dart';
import 'package:agora_video_call/videoConference/home.dart';
import 'package:agora_video_call/home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'videoConference/new_meeting.dart';

bool isLogin = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLogin = prefs.getBool('isLogin') ?? false;
  runApp(GetMaterialApp(
    initialRoute:  isLogin ? 'home':'phone',
    debugShowCheckedModeBanner: false,
    routes: {
      'video_conference_home': (context) => const VideoconferenceHome(),
      'home':(context) => const Home(),
      // 'call_page': (context) =>  CallPage(),
      'join_with_code': (context) => const JoinWithCode(),
      'new_meeting': (context) =>  NewMeeting(),
      'phone':(context) =>const MyPhone(),
      'verify':(context) =>MyVerify()

    },
  ));
}

