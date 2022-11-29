import 'dart:convert';
import 'dart:developer';
import 'package:agora_video_call/videoConference/join_with_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'new_meeting.dart';

class VideoconferenceHome extends StatefulWidget {
  const VideoconferenceHome({Key? key}) : super(key: key);

  @override
  State<VideoconferenceHome> createState() => _VideoconferenceHomeState();
}

class _VideoconferenceHomeState extends State<VideoconferenceHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video conference"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
          child: ElevatedButton.icon(onPressed: (){
           Get.to(NewMeeting());
          }, icon: Icon(Icons.add), label: Text("New Meeting"),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(350, 30),
            primary: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
            )
          ),
          ),
          ),
          Divider(thickness: 1, height: 40,indent: 40,endIndent: 20,),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: OutlinedButton.icon(onPressed: (){
              Get.to(JoinWithCode());
            }, icon: Icon(Icons.margin),label: Text("Join with a code"),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 30),
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: OutlinedButton.icon(onPressed: (){
              Get.to(JoinWithCode());
            }, icon: Icon(Icons.video_call),label: Text("test video call"),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 30),
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  )
              ),
            ),
          ),
          SizedBox(height:100),
          Image.network(
              "https://user-images.githubusercontent.com/67534990/127524449-fa11a8eb-473a-4443-962a-07a3e41c71c0.png")
        ],
      )
    );
  }
}
