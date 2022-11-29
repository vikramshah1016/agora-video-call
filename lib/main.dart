import 'package:agora_video_call/videoConference/join_with_code.dart';
import 'package:agora_video_call/login/phone.dart';
import 'package:agora_video_call/login/verify.dart';
import 'package:flutter/material.dart';
import 'package:agora_video_call/videoConference/home.dart';
import 'package:agora_video_call/home.dart';
import 'package:get/get.dart';

import 'videoConference/new_meeting.dart';

void main() async {
  runApp(GetMaterialApp(
    // initialRoute:  FirebaseAuth.instance.currentUser?.uid != null ? 'home':'phone',
    initialRoute: 'phone',
    debugShowCheckedModeBanner: false,
    routes: {
      // 'phone': (context) => const MyPhone(),
      // 'verify': (context) => const MyVerify(),
      'video_conference_home': (context) => const VideoconferenceHome(),
      'home':(context) => const Home(),
      // 'call_page': (context) =>  CallPage(),
      'join_with_code': (context) => const JoinWithCode(),
      'new_meeting': (context) =>  NewMeeting(),
      'phone':(context) =>MyPhone(),
      // 'verify':(context) =>MyVerify()

    },
  ));
}

